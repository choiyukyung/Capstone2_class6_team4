package com.example.sGreenTime.controller;

import com.example.sGreenTime.dto.MemberDTO;
import com.example.sGreenTime.dto.StatisticsDTO;
import com.example.sGreenTime.service.StatisticsService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
public class StatisticsController {

    public final StatisticsService statisticsService;

    @PostMapping("/statistics")
    public StatisticsDTO send(@RequestBody MemberDTO memberDTO){
        return StatisticsDTO.toStatisticsDTO(statisticsService.find(memberDTO));
    }


}
