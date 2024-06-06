package com.example.sGreenTime.controller;

import com.example.sGreenTime.dto.MemberDTO;
import com.example.sGreenTime.dto.UsageStatsDTO;
import com.example.sGreenTime.entity.AppInfoEntity;
import com.example.sGreenTime.entity.UsageStatsEntity;
import com.example.sGreenTime.service.AppInfoService;
import com.example.sGreenTime.service.UsageStatsService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
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

        List<UsageStatsDTO> uniqueUsageStatsDTOList = new ArrayList<>();

        for (UsageStatsDTO usageStatsDTO : usageStatsDTOList) {
            boolean found = false;
            for (UsageStatsDTO uniqueUsageStatsDTO : uniqueUsageStatsDTOList) {
                if (uniqueUsageStatsDTO.getPackageName().equals(usageStatsDTO.getPackageName())) {
                    int totalTime = Integer.parseInt(usageStatsDTO.getTotalTimeInForeground()) + Integer.parseInt(uniqueUsageStatsDTO.getTotalTimeInForeground());
                    uniqueUsageStatsDTO.setTotalTimeInForeground(Integer.toString(totalTime));
                    found = true;
                    break;
                }
            }
            if (!found) {
                UsageStatsDTO usageStatsDTO1 = new UsageStatsDTO();
                usageStatsDTO1.setId(usageStatsDTO.getId());
                usageStatsDTO1.setNowTimeStamp(usageStatsDTO.getNowTimeStamp());
                usageStatsDTO1.setPackageName(usageStatsDTO.getPackageName());
                usageStatsDTO1.setLastTimeUsed(usageStatsDTO.getPackageName());
                usageStatsDTO1.setTotalTimeInForeground(usageStatsDTO.getTotalTimeInForeground());
                uniqueUsageStatsDTOList.add(usageStatsDTO1);
            }
        }


        for(UsageStatsDTO usageStatsDTO : uniqueUsageStatsDTOList){
            if(Integer.parseInt(usageStatsDTO.getTotalTimeInForeground()) > 60000){
                UsageStatsEntity entity = usageStatsService.save(usageStatsDTO);
                AppInfoEntity appInfo = appInfoService.updateAppInfo(entity);
                appInfoList.add(appInfo);
            }
        }
        Collections.sort(appInfoList, (e1, e2) -> Float.compare(e2.getAppCarbon(), e1.getAppCarbon()));
        if (appInfoList.size() < 10){
            return appInfoList;
        }
        return appInfoList.subList(0, 10);
    }

    // 사용자의 id 주면 앱별 탄소 사용량, 앱 사용량 보내기(전날 하루 00시 ~ 23시 55분)
    @PostMapping("/appInfoYesterday")
    public List<AppInfoEntity> sendYesterday(@RequestBody MemberDTO memberDTO) {
        LocalDateTime today = LocalDateTime.now().toLocalDate().atStartOfDay().minusDays(1);
        List<AppInfoEntity> appInfoEntityList = appInfoService.findAppInfoOneDay(memberDTO, today);
        Collections.sort(appInfoEntityList, (e1, e2) -> Float.compare(Math.abs(e2.getAppCarbon()), Math.abs(e1.getAppCarbon())));

        return appInfoEntityList.subList(0, 4);
    }

    // 사용자의 id 주면 앱별 탄소 사용량 전날-전전날 보내기(값이 +면 어제가 많이 사용한 것)
    //[{"screentimeId":0,"startDate":null,"endDate":null,"id":"33","appEntry":"youtube","appIcon":null,"appTime":null,"appCarbon":11.5},{"screentimeId":0,"startDate":null,"endDate":null,"id":"33","appEntry":"kakaotalk","appIcon":null,"appTime":null,"appCarbon":11.5}]
    //여기서 appEntry와 appCarbon만 어제와 그제의 차이를 나타내는 유의미한 정보고(+id, appIcon) 나머지는 의미 없는 정보임.
    @PostMapping("/appInfoChange")
    public List<AppInfoEntity> sendChange() {
        MemberDTO memberDTO = new MemberDTO();
        memberDTO.setId("master");
        /*
        LocalDateTime yesterday = LocalDate.now().minusDays(1).atStartOfDay();
        List<AppInfoEntity> appInfoEntityYesterday = appInfoService.findAppInfoOneDay(memberDTO, yesterday);
        LocalDateTime yesterday2 = LocalDate.now().minusDays(2).atStartOfDay();
        List<AppInfoEntity> appInfoEntityYesterday2 = appInfoService.findAppInfoOneDay(memberDTO, yesterday2);
        */
        LocalDateTime today = LocalDateTime.now().toLocalDate().atStartOfDay().minusDays(1);
        List<AppInfoEntity> appInfoEntityYesterday = appInfoService.findAppInfoOneDay(memberDTO, today);
        List<AppInfoEntity> appInfoEntityYesterday2 = appInfoService.findAppInfoOneDay(memberDTO, today.minusDays(1));

        List<AppInfoEntity> appInfoEntityList = new ArrayList<>();
        boolean present = false; //어제는 썼는데 그제는 안 씀(==false)
        for(AppInfoEntity yes1 : appInfoEntityYesterday){
            for(AppInfoEntity yes2 : appInfoEntityYesterday2){
                if(yes1.getAppEntry().equals(yes2.getAppEntry())){
                    present = true;
                    AppInfoEntity appInfoEntity = new AppInfoEntity();
                    float appCarbonChange = yes1.getAppCarbon()-yes2.getAppCarbon();
                    appInfoEntity.setAppCarbon(appCarbonChange);
                    appInfoEntity.setId(memberDTO.getId());
                    appInfoEntity.setAppEntry(yes1.getAppEntry());
                    appInfoEntity.setAppIcon(yes1.getAppIcon());
                    appInfoEntityList.add(appInfoEntity);
                    break;
                }
            }
            if(!present){
                AppInfoEntity appInfoEntity = new AppInfoEntity();
                appInfoEntity.setAppCarbon(yes1.getAppCarbon());
                appInfoEntity.setId(memberDTO.getId());
                appInfoEntity.setAppEntry(yes1.getAppEntry());
                appInfoEntity.setAppIcon(yes1.getAppIcon());
                appInfoEntityList.add(appInfoEntity);
            }
            present = false;
        }

        //그제는 썼는데 어제는 안 씀(==false)
        for(AppInfoEntity yes2 : appInfoEntityYesterday) {
            for (AppInfoEntity list : appInfoEntityList) {
                if(yes2.getAppEntry().equals(list.getAppEntry())){
                    present = true;
                    break;
                }
            }
            if(!present){
                AppInfoEntity appInfoEntity = new AppInfoEntity();
                appInfoEntity.setAppCarbon((-1)*yes2.getAppCarbon());
                appInfoEntity.setId(memberDTO.getId());
                appInfoEntity.setAppEntry(yes2.getAppEntry());
                appInfoEntity.setAppIcon(yes2.getAppIcon());
                appInfoEntityList.add(appInfoEntity);
            }
        }

        //절댓값이 큰 7개
        Collections.sort(appInfoEntityList, (e1, e2) -> Float.compare(Math.abs(e2.getAppCarbon()), Math.abs(e1.getAppCarbon())));


        return appInfoEntityList.subList(0, 7);
    }
}
