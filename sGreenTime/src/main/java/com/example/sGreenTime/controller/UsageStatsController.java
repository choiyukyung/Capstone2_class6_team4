package com.example.sGreenTime.controller;

import com.example.sGreenTime.dto.UsageStatsDTO;
import com.example.sGreenTime.entity.UsageStatsEntity;
import com.example.sGreenTime.service.UsageStatsService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
public class UsageStatsController {

    private final UsageStatsService usageStatsService;

    @PostMapping("/usageStats")
    public List<UsageStatsEntity> saveAndSend(@RequestBody List<UsageStatsDTO> usageStatsDTOList) {
        List<UsageStatsEntity> entityList = new ArrayList<>();
        for (UsageStatsDTO usageStatsDTO : usageStatsDTOList) {
            //totaltimeinforeground 분으로 가공
            int timeInMillisec = Integer.parseInt(usageStatsDTO.getTotalTimeInForeground());
            int totalTime = timeInMillisec / 60000;
            if (totalTime > 0) {
                UsageStatsEntity entity = usageStatsService.save(usageStatsDTO);
                entityList.add(entity);
            }
        }

        Collections.sort(entityList, (e1, e2) -> Integer.compare(Integer.parseInt(e2.getTotalTimeInForeground()), Integer.parseInt(e1.getTotalTimeInForeground())));
        if (entityList.size() < 10) {
            return entityList;
        }
        return entityList.subList(0, 10);
    }


}

