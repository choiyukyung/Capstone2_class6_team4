package com.example.sGreenTime.controller;

import com.example.sGreenTime.dto.MemberDTO;
import com.example.sGreenTime.dto.StatisticsDTO;
import com.example.sGreenTime.entity.StatisticsEntity;
import com.example.sGreenTime.service.StatisticsService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
public class StatisticsController {

    public final StatisticsService statisticsService;

    @PostMapping("/statistics")
    public StatisticsDTO send(@RequestBody MemberDTO memberDTO){
        LocalDate day = LocalDate.now().minusDays(1);
        return StatisticsDTO.toStatisticsDTO(statisticsService.find(memberDTO.getId(), day));
    }

    @PostMapping("/statistics7days")
    public List<StatisticsEntity> send7days(@RequestBody MemberDTO memberDTO){
        List<StatisticsEntity> statisticsEntityList = new ArrayList<>();
        for(int i = 0;i<7;i++){
            LocalDate day = LocalDate.now().minusDays(i+1);
            statisticsEntityList.add(statisticsService.find(memberDTO.getId(), day));
        }

        return statisticsEntityList;
    }

    @PostMapping("/userBaseValue")
    public float baseValue(@RequestBody MemberDTO memberDTO){
        LocalDate day = LocalDate.now().minusDays(1);
        StatisticsEntity statisticsEntity = statisticsService.find(memberDTO.getId(), day);
        float totalCarbonUsage = statisticsEntity.getTotalCarbonUsage();
        int cDate = statisticsEntity.getCDate();
        return totalCarbonUsage/cDate;
    }

}
