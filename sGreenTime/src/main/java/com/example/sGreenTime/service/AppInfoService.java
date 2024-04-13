package com.example.sGreenTime.service;

import com.example.sGreenTime.dto.MemberDTO;
import com.example.sGreenTime.dto.UsageStatsDTO;
import com.example.sGreenTime.entity.AppInfoEntity;
import com.example.sGreenTime.entity.MemberEntity;
import com.example.sGreenTime.entity.UsageStatsEntity;
import com.example.sGreenTime.repository.AppInfoRepository;
import com.example.sGreenTime.repository.UsageStatsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.cglib.core.Local;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
@RequiredArgsConstructor
public class AppInfoService {
    private final UsageStatsRepository usageStatsRepository;
    private final AppInfoRepository appInfoRepository;

    public AppInfoEntity updateAppInfo(UsageStatsEntity usageStatsEntity){

        long millisecondsSinceEpoch = Long.parseLong(usageStatsEntity.getNowTimeStamp());
        Instant instant = Instant.ofEpochMilli(millisecondsSinceEpoch);
        LocalDateTime nowTime = LocalDateTime.ofInstant(instant, ZoneId.systemDefault());

            String appName = usageStatsEntity.getPackageName();
            String appTime = usageStatsEntity.getTotalTimeInForeground();
            float appCarbon;

            //앱 이름 파싱 불가능 문제
            //동영상 어플
            if(appName == "youtube"){
                appCarbon = (float) (Float.valueOf(appTime)*0.46);
            } else if (appName == "netflix") {
                appCarbon = (float) (Float.valueOf(appTime)*0.46);
            } else if (appName == "tving") {
                appCarbon = (float) (Float.valueOf(appTime)*0.46);
            } else if (appName == "wavve") {
                appCarbon = (float) (Float.valueOf(appTime)*0.46);
            } else if (appName == "coupang play") {
                appCarbon = (float) (Float.valueOf(appTime)*0.46);
            } else if (appName == "disney+") {
                appCarbon = (float) (Float.valueOf(appTime)*0.46);
            }
            ///

            else if (appName == "X") {
                appCarbon = (float) (Float.valueOf(appTime)*0.55);
            } else if (appName == "linkedIn") {
                appCarbon = (float) (Float.valueOf(appTime)*0.71);
            } else if (appName == "facebook") {
                appCarbon = (float) (Float.valueOf(appTime)*0.79);
            }

            //채팅 어플
            else if (appName == "snapchat") {
                appCarbon = (float) (Float.valueOf(appTime)*0.87);
            } else if (appName == "kakaotalk") {
                appCarbon = (float) (Float.valueOf(appTime)*0.87);
            } else if (appName == "line") {
                appCarbon = (float) (Float.valueOf(appTime)*0.87);
            } else if (appName == "telegram") {
                appCarbon = (float) (Float.valueOf(appTime)*0.87);
            }
            ///

            else if (appName == "instagram") {
                appCarbon = (float) (Float.valueOf(appTime)*1.05);
            } else if (appName == "pinterest") {
                appCarbon = (float) (Float.valueOf(appTime)*1.3);
            } else if (appName == "reddit") {
                appCarbon = (float) (Float.valueOf(appTime)*2.48);
            } else if (appName == "tiktok") {
                appCarbon = (float) (Float.valueOf(appTime)*2.63);
            } else {
                appCarbon = (float) (Float.valueOf(appTime)*0.1);
            }

            AppInfoEntity newAppInfo = new AppInfoEntity();
            newAppInfo.setStartDate(nowTime.minusDays(1));
            newAppInfo.setEndDate(nowTime);
            newAppInfo.setId(usageStatsEntity.getId());
            newAppInfo.setAppEntry(appName);
            newAppInfo.setAppTime(appTime);
            newAppInfo.setAppCarbon(appCarbon);

            appInfoRepository.save(newAppInfo);
            return newAppInfo;

    }
}
