package com.example.sGreenTime.service;

import com.example.sGreenTime.dto.MemberDTO;
import com.example.sGreenTime.entity.AppInfoEntity;
import com.example.sGreenTime.entity.StatisticsEntity;
import com.example.sGreenTime.repository.AppInfoRepository;
import com.example.sGreenTime.repository.StatisticsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
@RequiredArgsConstructor
public class StatisticsService {
    private final StatisticsRepository statisticsRepository;
    private final AppInfoRepository appInfoRepository;
    private final CarbonInObjService carbonInObjService;

    @Transactional
    public StatisticsEntity find(MemberDTO memberDTO){
        LocalDate yesterday = LocalDate.now().minusDays(1);
        String id = memberDTO.getId();
        Optional<StatisticsEntity> statisticsEntity = statisticsRepository.findByIdAndDate(id, yesterday);
        //해당 아이디에 어제까지의 날짜의 정보가 있는지 확인
        if(statisticsEntity.isPresent()){
            return statisticsEntity.get();
        }

        return save(id, yesterday);
    }
    @Transactional
    public StatisticsEntity save(String id, LocalDate yesterday){
        LocalDate lastWeekStart = yesterday.minusDays(7);

        List<AppInfoEntity> appInfoEntityList = appInfoRepository.findById(id);

        StatisticsEntity statisticsEntity = new StatisticsEntity();
        statisticsEntity.setId(id);
        statisticsEntity.setDate(yesterday);

        float weekCarbonUsage = 0;
        float totalCarbonUsage = 0;

        for(AppInfoEntity appInfoEntity : appInfoEntityList){
            //하루의 온전한 사용시간이 있어야 함.
            // (24시간 단위로만 사용시간을 저장한다고 했으니까 23:50에 이후(23:55) 받아오는 시간으로 온전한 사용시간을 지정)
            LocalTime endTime = appInfoEntity.getEndDate().toLocalTime();
            if(endTime.isAfter(LocalTime.of(23, 50))) {
                LocalDate appStartDate = appInfoEntity.getStartDate().toLocalDate();
                if(appStartDate.equals(yesterday)) { //2024-04-12T00:00
                    statisticsEntity.setDayCarbonUsage(appInfoEntity.getAppCarbon());
                    System.out.println("yesterday : " + appInfoEntity.getAppCarbon());
                }
                if(appStartDate.isAfter(lastWeekStart.minusDays(1)) && appStartDate.isBefore(yesterday.plusDays(1))){
                    weekCarbonUsage += appInfoEntity.getAppCarbon();
                    System.out.println("week : " + appInfoEntity.getAppCarbon());
                }
                totalCarbonUsage += appInfoEntity.getAppCarbon();
            }

        }

        statisticsEntity.setWeekCarbonUsage(weekCarbonUsage);
        statisticsEntity.setTotalCarbonUsage(totalCarbonUsage);
        statisticsRepository.save(statisticsEntity);

        carbonInObjService.save(id, yesterday);
        return statisticsEntity;
    }

}
