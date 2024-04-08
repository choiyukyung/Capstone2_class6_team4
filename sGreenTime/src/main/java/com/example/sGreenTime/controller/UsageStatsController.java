package com.example.sGreenTime.controller;

import com.example.sGreenTime.dto.UsageStatsDTO;
import com.example.sGreenTime.service.UsageStatsService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
public class UsageStatsController {

    private final UsageStatsService usageStatsService;

    @PostMapping("/usageStats")
    public UsageStatsDTO save(@RequestBody UsageStatsDTO usageStatsDTO){
        usageStatsService.save(usageStatsDTO);
        return usageStatsDTO;
    }
}
