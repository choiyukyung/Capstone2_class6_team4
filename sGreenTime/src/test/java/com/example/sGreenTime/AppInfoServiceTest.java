package com.example.sGreenTime;

import com.example.sGreenTime.controller.AppInfoController;
import com.example.sGreenTime.dto.UsageStatsDTO;
import com.example.sGreenTime.entity.AppInfoEntity;
import com.example.sGreenTime.entity.MemberEntity;
import com.example.sGreenTime.entity.UsageStatsEntity;
import com.example.sGreenTime.repository.AppInfoRepository;
import com.example.sGreenTime.repository.UsageStatsRepository;
import com.example.sGreenTime.service.AppInfoService;
import com.example.sGreenTime.service.UsageStatsService;
import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@SpringBootTest
@Transactional
public class AppInfoServiceTest {
    @Autowired
    AppInfoService appInfoService;
    @Autowired
    AppInfoRepository appInfoRepository;
    @Autowired
    UsageStatsService usageStatsService;
    @Autowired
    UsageStatsRepository usageStatsRepository;
    @Autowired
    AppInfoController appInfoController;
    @Autowired
    EntityManager em;

    @DisplayName("appTest")
    @Test
    public void AppInfoTest(){
        //given
        List<AppInfoEntity> appInfoEntityList = appInfoController.sendChange();
        for(AppInfoEntity a : appInfoEntityList){
            System.out.println(a.getAppEntry());
            System.out.println(a.getAppCarbon());
        }
        /*
        UsageStatsDTO usageStats1 = new UsageStatsDTO();
        usageStats1.setId("33");
        usageStats1.setPackageName("com.google.android.youtube");
        usageStats1.setNowTimeStamp("11111111");
        usageStats1.setTotalTimeInForeground("60000");

        UsageStatsEntity usageStatsEntity1 = usageStatsService.save(usageStats1);
        AppInfoEntity appInfo1 = appInfoService.updateAppInfo(usageStatsEntity1);
*/
//        UsageStatsEntity usageStats2 = new UsageStatsEntity();
//        usageStats2.setId("33");
//        usageStats2.setPackageName("com.kakao.talk");
//        usageStats2.setNowTimeStamp("11111111");
//        usageStats2.setTotalTimeInForeground("10");
//
//        em.persist(usageStats2);
//
//        UsageStatsEntity usageStats3 = new UsageStatsEntity();
//        usageStats3.setId("33");
//        usageStats3.setPackageName("com.kakao.talk");
//        usageStats3.setNowTimeStamp("11111112");
//        usageStats3.setTotalTimeInForeground("10");
//
//        em.persist(usageStats3);
//
//        UsageStatsEntity usageStats4 = new UsageStatsEntity();
//        usageStats4.setId("34");
//        usageStats4.setPackageName("com.kakao.talk");
//        usageStats4.setNowTimeStamp("11111111");
//        usageStats4.setTotalTimeInForeground("10");
//
//        em.persist(usageStats4);
//
//        appInfoService.updateAppInfo(usageStats1);
//
//        Optional<AppInfoEntity> appInfoEntity1 = appInfoRepository.findById(member.getId()).stream().findFirst();
//
//        System.out.println(appInfoEntity1);

    }
}
