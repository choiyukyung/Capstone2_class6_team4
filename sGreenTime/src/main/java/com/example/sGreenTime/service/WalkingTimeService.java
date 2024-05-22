package com.example.sGreenTime.service;

import com.example.sGreenTime.dto.WalkingTimeDTO;
import com.example.sGreenTime.entity.VisitedHikingEntity;
import com.example.sGreenTime.entity.VisitedParkEntity;
import com.example.sGreenTime.entity.VisitedTrailEntity;
import com.example.sGreenTime.entity.WalkingTimeEntity;
import com.example.sGreenTime.repository.VisitedRepository;
import com.example.sGreenTime.repository.WalkingTimeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.*;

@Service
@Transactional
@RequiredArgsConstructor
public class WalkingTimeService {
    private final WalkingTimeRepository walkingTimeRepository;
    private final VisitedRepository visitedRepository;

    public WalkingTimeEntity toWalkingTimeEntity(WalkingTimeDTO walkingTimeDTO) {
        WalkingTimeEntity walkingTimeEntity = new WalkingTimeEntity();
        walkingTimeEntity.setId(walkingTimeDTO.getId());
        walkingTimeEntity.setDateTime(LocalDateTime.now());
        float totalWalkingTimeInMinutes = walkingTimeDTO.getTotalWalkTime() / (1000f * 60f);
        walkingTimeEntity.setWalkingTime(Math.round(totalWalkingTimeInMinutes * 10f) / 10f);
        walkingTimeRepository.save(walkingTimeEntity);
        return walkingTimeEntity;
    }

    public Map<String, Object> getVisitedPlaces(WalkingTimeDTO walkingTimeDTO) {
        float totalWalkingTimeInMinutes = walkingTimeDTO.getTotalWalkTime() / (1000f * 60f);
        LocalDateTime endTime = LocalDateTime.now();
        LocalDateTime startTime = endTime.minus((long) (totalWalkingTimeInMinutes * 60), ChronoUnit.SECONDS);
        List<VisitedTrailEntity> trails = visitedRepository.findTrailByVisitedTime(startTime, endTime, walkingTimeDTO.getId());
        List<VisitedHikingEntity> hikings = visitedRepository.findHikingByVisitedTime(startTime, endTime, walkingTimeDTO.getId());
        List<VisitedParkEntity> parks = visitedRepository.findParkByVisitedTime(startTime, endTime, walkingTimeDTO.getId());
        Map<String, Object> result = new HashMap<>();
        result.put("trails", trails);
        result.put("hikings", hikings);
        result.put("parks", parks);

        //자동차로 변환한 값 계산
        //휴대폰 1분에 0.1g
        //1g에 8.26m
        //=> 휴대폰 1분에 0.826m
        float totalWalkingTimeInCar = (float) (totalWalkingTimeInMinutes * 0.826);
        result.put("totalWalkTimeInCar", totalWalkingTimeInCar);
        return result;

    }

    public List<WalkingTimeEntity> getWalkingTimeWeek() {
        List<WalkingTimeEntity> all = walkingTimeRepository.findAll();

        List<WalkingTimeEntity> week = new ArrayList<>();

        LocalDateTime now = LocalDateTime.now(); // 현재 날짜와 시간
        LocalDateTime aWeekAgo = now.minusDays(6);
        //일주일 안의 데이터 안에서 사용자별로 WalkingTime 합 구하기
        for (WalkingTimeEntity entity : all) {
            //일주일 안에 포함
            if (!entity.getDateTime().isBefore(aWeekAgo) && !entity.getDateTime().isAfter(now)) {
                String id = entity.getId();
                boolean exist = false;
                if (week != null) {
                    for (WalkingTimeEntity entityWeek : week) {
                        if (entityWeek.getId().equals(id)) {
                            entityWeek.setWalkingTime(entityWeek.getWalkingTime() + entity.getWalkingTime());
                            exist = true;
                            break;
                        }
                    }
                }
                if (!exist) {
                    week.add(entity);
                }
            }
        }
        return week;

    }

    public List<WalkingTimeEntity> getWalkingTop10() {
        List<WalkingTimeEntity> weekAll = getWalkingTimeWeek();

        if (weekAll.isEmpty() || weekAll.size() <= 10) {
            return weekAll;
        }

        Collections.sort(weekAll, Comparator.comparing(WalkingTimeEntity::getWalkingTime).reversed());
        return weekAll.subList(0, 10);
    }
}
