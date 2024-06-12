package com.example.sGreenTime.service;

import com.example.sGreenTime.dto.WalkingTimeDTO;
import com.example.sGreenTime.entity.WalkingTimeEntity;
import com.example.sGreenTime.repository.VisitedRepository;
import com.example.sGreenTime.repository.WalkingTimeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;

@Service
@Transactional
@RequiredArgsConstructor
public class WalkingTimeService {
    private final WalkingTimeRepository walkingTimeRepository;
    private final VisitedRepository visitedRepository;
    private final StatisticsService statisticsService;

    public WalkingTimeEntity toWalkingTimeEntity(WalkingTimeDTO walkingTimeDTO) {
        WalkingTimeEntity walkingTimeEntity = new WalkingTimeEntity();
        walkingTimeEntity.setId(walkingTimeDTO.getId());
        walkingTimeEntity.setDateTime(LocalDateTime.now());
        float totalWalkingTimeInMinutes = walkingTimeDTO.getTotalWalkTime() / (1000f * 60f);
        walkingTimeEntity.setWalkingTime(Math.round(totalWalkingTimeInMinutes * 10f) / 10f);
        walkingTimeRepository.save(walkingTimeEntity);
        return walkingTimeEntity;
    }

    public Map<String, Float> getWalkingTimeInCar(WalkingTimeDTO walkingTimeDTO) {
        float totalWalkingTimeInMinutes = walkingTimeDTO.getTotalWalkTime() / (1000f * 60f);

        Map<String, Float> totalWalkingTimeIn = new HashMap<>();
        //자동차로 변환한 값 계산
        //휴대폰 1분에 userCarbonAvgPerMin에서 얻어온 값 (0.25g)
        //산책동안 아낀 총 carbon: 0.25*시간(분단위)
        //탄소 1g에 8.26m
        //총 carbon*8.26
        float myCarbonAvgPerMin = statisticsService.userCarbonAvgPerMin(walkingTimeDTO.getId());
        float totalCarbon = myCarbonAvgPerMin * totalWalkingTimeInMinutes;
        float totalWalkingTimeInCar = (float) (totalCarbon * 8.26);
        totalWalkingTimeIn.put("car", totalWalkingTimeInCar);

        //나무로 변환한 값 계산
        //휴대폰 1분에 0.1g
        //나무 1그루가 하루동안 흡수하는 이산화탄소량 11900g/365 = 32.6g
        //나무는 1g을 1/32.6일동안 흡수
        //나무 1그루가 1시간 동안 흡수하는 이산화탄소량 1.36g
        //산책동안 아낀 탄소량 / 1.36 = 시간당 나무가 흡수하는 이산화탄소량으로 변환한 산책탄소량
        float totalWalkingTimeInTree = (float) (totalCarbon / 1.36);
        totalWalkingTimeIn.put("tree", totalWalkingTimeInTree);

        return totalWalkingTimeIn;

    }

    public List<WalkingTimeEntity> getWalkingTimeWeek() {

        List<WalkingTimeEntity> all = walkingTimeRepository.findAll();
        Map<String, WalkingTimeEntity> weekMap = new HashMap<>();

        LocalDateTime now = LocalDateTime.now(); // 현재 날짜와 시간
        LocalDateTime aWeekAgo = now.minusDays(6);

        // 일주일 안의 데이터 안에서 사용자별로 WalkingTime 합 구하기
        for (WalkingTimeEntity entity : all) {
            // 일주일 안에 포함
            if (!entity.getDateTime().isBefore(aWeekAgo) && !entity.getDateTime().isAfter(now)) {
                String id = entity.getId();
                if (weekMap.containsKey(id)) {
                    // 이미 존재하면 기존 값에 더하기
                    WalkingTimeEntity existingEntity = weekMap.get(id);
                    existingEntity.setWalkingTime(existingEntity.getWalkingTime() + entity.getWalkingTime());
                } else {
                    // 존재하지 않으면 새로 추가
                    WalkingTimeEntity newEntity = new WalkingTimeEntity();
                    newEntity.setId(entity.getId());
                    newEntity.setWalkingTime(entity.getWalkingTime());
                    newEntity.setDateTime(entity.getDateTime());
                    weekMap.put(id, newEntity);
                }
            }
        }

        // Map의 값을 리스트로 변환
        List<WalkingTimeEntity> week = new ArrayList<>(weekMap.values());

        for (WalkingTimeEntity entity : week) {
            System.out.println(entity.getId() + " : " + entity.getWalkingTime());
        }
        return week;

    }

    public List<WalkingTimeEntity> getWalkingTop10() {
        List<WalkingTimeEntity> weekAll = getWalkingTimeWeek();

        if (weekAll.isEmpty()) {
            return weekAll;
        }

        Collections.sort(weekAll, Comparator.comparing(WalkingTimeEntity::getWalkingTime).reversed());
        if (weekAll.size() < 10) {
            return weekAll;
        }
        return weekAll.subList(0, 10);
    }

    public int getWalkingMyRank(String id) {
        List<WalkingTimeEntity> weekAll = getWalkingTimeWeek();

        Collections.sort(weekAll, Comparator.comparing(WalkingTimeEntity::getWalkingTime).reversed());

        //우리 사용자 찾기
        int i = 0;
        for (WalkingTimeEntity w : weekAll) {
            i++;
            if (w.getId().equals(id)) {
                return i;
            }
        }
        return 0;
    }

}
