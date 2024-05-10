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
        System.out.println(appInfoList);
        return appInfoList;
    }

    // 사용자의 id 주면 앱별 탄소 사용량 보내기(전날 하루 00시 ~ 23시 55분)
    @PostMapping("/appInfoYesterday")
    public List<AppInfoEntity> sendYesterday(@RequestBody MemberDTO memberDTO) {
        LocalDateTime yesterday = LocalDate.now().minusDays(1).atStartOfDay();
        List<AppInfoEntity> appInfoEntityList = appInfoService.findAppInfoOneDay(memberDTO, yesterday);
        return appInfoEntityList;
    }

    // 사용자의 id 주면 앱별 탄소 사용량 전날-전전날 보내기(값이 +면 어제가 많이 사용한 것)
    //[{"screentimeId":0,"startDate":null,"endDate":null,"id":"33","appEntry":"youtube","appIcon":null,"appTime":null,"appCarbon":11.5},{"screentimeId":0,"startDate":null,"endDate":null,"id":"33","appEntry":"kakaotalk","appIcon":null,"appTime":null,"appCarbon":11.5}]
    //여기서 appEntry와 appCarbon만 어제와 그제의 차이를 나타내는 유의미한 정보고(+id, appIcon) 나머지는 의미 없는 정보임.
    @GetMapping("/appInfoChange")
    public List<AppInfoEntity> sendChange() {
        MemberDTO memberDTO = new MemberDTO();
        memberDTO.setId("33");
        LocalDateTime yesterday = LocalDate.now().minusDays(1).atStartOfDay();
        List<AppInfoEntity> appInfoEntityYesterday = appInfoService.findAppInfoOneDay(memberDTO, yesterday);
        LocalDateTime yesterday2 = LocalDate.now().minusDays(2).atStartOfDay();
        List<AppInfoEntity> appInfoEntityYesterday2 = appInfoService.findAppInfoOneDay(memberDTO, yesterday2);

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

        return appInfoEntityList;
    }
}
