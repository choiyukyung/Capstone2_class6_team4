package com.example.sGreenTime.controller;

import com.example.sGreenTime.dto.UsageStatsDTO;
import com.example.sGreenTime.entity.AppInfoEntity;
import com.example.sGreenTime.entity.UsageStatsEntity;
import com.example.sGreenTime.service.AppInfoService;
import com.example.sGreenTime.service.UsageStatsService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
public class AppInfoController {

    private final UsageStatsService usageStatsService;
    private final AppInfoService appInfoService;

    @PostMapping("/appInfo")
    public List<AppInfoEntity> saveAndSend(@RequestBody List<UsageStatsDTO> usageStatsDTOList){
        List<AppInfoEntity> appInfoList = new ArrayList<>();
        for(UsageStatsDTO usageStatsDTO : usageStatsDTOList){
            UsageStatsEntity entity = usageStatsService.save(usageStatsDTO);
            AppInfoEntity appInfo = appInfoService.updateAppInfo(entity);
            appInfoList.add(appInfo);
        }
        return appInfoList;
    }
}
