package com.example.sGreenTime;

import com.example.sGreenTime.entity.AppInfoEntity;
import com.example.sGreenTime.entity.MemberEntity;
import com.example.sGreenTime.entity.UsageStatsEntity;
import com.example.sGreenTime.repository.AppInfoRepository;
import com.example.sGreenTime.service.AppInfoService;
import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@SpringBootTest
@Transactional
public class AppInfoServiceTest {
    @Autowired
    AppInfoService appInfoService;
    @Autowired
    AppInfoRepository appInfoRepository;
    @Autowired
    EntityManager em;

    @DisplayName("appTest")
    @Test
    public void AppInfoTest(){
        //given
        MemberEntity member = new MemberEntity();
        member.setId("33");

        UsageStatsEntity usageStats1 = new UsageStatsEntity();
        usageStats1.setId("33");
        usageStats1.setPackageName("com.google.android.youtube");
        usageStats1.setTotalTimeInForeground("10");

        em.persist(usageStats1);

        UsageStatsEntity usageStats2 = new UsageStatsEntity();
        usageStats2.setId("33");
        usageStats2.setPackageName("com.kakao.talk");
        usageStats2.setTotalTimeInForeground("10");

        em.persist(usageStats2);

        appInfoService.updateAppInfo(member);

        Optional<AppInfoEntity> appInfoEntity1 = appInfoRepository.findById(member.getId()).stream().findFirst();

        System.out.println(appInfoEntity1);

    }
}
