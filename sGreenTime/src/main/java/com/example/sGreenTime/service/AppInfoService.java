package com.example.sGreenTime.service;

import com.example.sGreenTime.entity.AppInfoEntity;
import com.example.sGreenTime.entity.MemberEntity;
import com.example.sGreenTime.entity.UsageStatsEntity;
import com.example.sGreenTime.repository.AppInfoRepository;
import com.example.sGreenTime.repository.UsageStatsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
@RequiredArgsConstructor
public class AppInfoService {
    private final UsageStatsRepository usageStatsRepository;
    private final AppInfoRepository appInfoRepository;

    public void updateAppInfo(MemberEntity memberEntity){
        List<UsageStatsEntity> usageStatsEntityList = usageStatsRepository.findByUserId(memberEntity.getId());
        LocalDateTime nowTime = LocalDateTime.now();

        for(UsageStatsEntity usageStats : usageStatsEntityList){
            String appName = usageStats.getPackageName();
            String appTime = usageStats.getTotalTimeInForeground();
            float appCarbon;

            //앱 이름 파싱 불가능 문제
            //동영상 어플
            if(appName == "com.google.android.youtube"){
                appCarbon = (float) (Float.valueOf(appTime)*0.46);
                appName = "youtube";
            } else if (appName == "com.netflix.mediaclient") {
                appCarbon = (float) (Float.valueOf(appTime)*0.46);
                appName = "netflix";
            } else if (appName == "net.cj.cjhv.gs.tving") {
                appCarbon = (float) (Float.valueOf(appTime)*0.46);
                appName = "tving";
            } else if (appName == "kr.co.captv.pooqV2") {
                appCarbon = (float) (Float.valueOf(appTime)*0.46);
                appName = "wavve";
            } else if (appName == "com.coupang.mobile.play") {
                appCarbon = (float) (Float.valueOf(appTime)*0.46);
                appName = "coupang play";
            } else if (appName == "com.disney.disneyplus") {
                appCarbon = (float) (Float.valueOf(appTime)*0.46);
                appName = "disney+";
            }
            ///

            else if (appName == "com.twitter.android") {
                appCarbon = (float) (Float.valueOf(appTime)*0.55);
                appName = "X";
            } else if (appName == "com.linkedin.android") {
                appCarbon = (float) (Float.valueOf(appTime)*0.71);
                appName = "linkedIn";
            } else if (appName == "com.facebook.katana") {
                appCarbon = (float) (Float.valueOf(appTime)*0.79);
                appName = "facebook";
            }

            //채팅 어플
            else if (appName == "com.snapchat.android") {
                appCarbon = (float) (Float.valueOf(appTime)*0.87);
                appName = "snapchat";
            } else if (appName == "com.kakao.talk") {
                appCarbon = (float) (Float.valueOf(appTime)*0.87);
                appName = "kakaotalk";
            } else if (appName == "jp.naver.line.android") {
                appCarbon = (float) (Float.valueOf(appTime)*0.87);
                appName = "line";
            } else if (appName == "org.telegram.messenger") {
                appCarbon = (float) (Float.valueOf(appTime)*0.87);
                appName = "telegram";
            }
            ///

            else if (appName == "com.instagram.android") {
                appCarbon = (float) (Float.valueOf(appTime)*1.05);
                appName = "instagram";
            } else if (appName == "com.pinterest") {
                appCarbon = (float) (Float.valueOf(appTime)*1.3);
                appName = "pinterest";
            } else if (appName == "com.reddit.frontpage") {
                appCarbon = (float) (Float.valueOf(appTime)*2.48);
                appName = "reddit";
            } else if (appName == "com.ss.android.ugc.trill") {
                appCarbon = (float) (Float.valueOf(appTime)*2.63);
                appName = "tiktok";
            } else {
                appCarbon = (float) (Float.valueOf(appTime)*0.1);
            }

            AppInfoEntity newAppInfo = new AppInfoEntity();
            newAppInfo.setStartDate(LocalDateTime.now().toLocalDate().atStartOfDay());
            newAppInfo.setEndDate(nowTime);
            newAppInfo.setId(memberEntity.getId());
            newAppInfo.setAppEntry(appName);
            newAppInfo.setAppTime(appTime);
            newAppInfo.setAppCarbon(appCarbon);

            appInfoRepository.save(newAppInfo);
        }



    }
}
