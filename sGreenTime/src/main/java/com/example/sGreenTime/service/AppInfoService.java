package com.example.sGreenTime.service;

import com.example.sGreenTime.dto.MemberDTO;
import com.example.sGreenTime.entity.AppInfoEntity;
import com.example.sGreenTime.entity.UsageStatsEntity;
import com.example.sGreenTime.repository.AppInfoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class AppInfoService {
    private final AppInfoRepository appInfoRepository;

    public List<AppInfoEntity> findAppInfoOneDay(MemberDTO memberDTO, LocalDateTime day){

        String id = memberDTO.getId();
        List<AppInfoEntity> appInfoEntityList = appInfoRepository.findByIdandStartDate(id, day);

        List<AppInfoEntity> appInfoEntityYesterday = new ArrayList<>();
        if(!appInfoEntityList.isEmpty()){
            for(AppInfoEntity i : appInfoEntityList){
                if(i.getEndDate().toLocalTime().isAfter(LocalTime.of(23, 50))){
                    appInfoEntityYesterday.add(i);
                }
            }
            if(appInfoEntityYesterday.isEmpty()){
                System.out.println("사용자의 어제 appInfo 정보가 없습니다.");
            }
        }
        else{
            System.out.println("사용자의 appInfo 정보가 없습니다.");
        }
        return appInfoEntityYesterday;

    }

    public AppInfoEntity updateAppInfo(UsageStatsEntity usageStatsEntity){

        long millisecondsSinceEpoch = Long.parseLong(usageStatsEntity.getNowTimeStamp());
        Instant instant = Instant.ofEpochMilli(millisecondsSinceEpoch);
        LocalDateTime nowTime = LocalDateTime.ofInstant(instant, ZoneId.systemDefault());

            String appName = usageStatsEntity.getPackageName();
            String appTime = usageStatsEntity.getTotalTimeInForeground(); //UsageStatsEntity - min
            float appCarbon;

            //앱 이름 파싱 불가능 문제
            //동영상 어플
            if(appName == "Youtube"){
                appCarbon = (float) (Float.valueOf(appTime)*0.87);
            } else if (appName == "Netflix") {
                appCarbon = (float) (Float.valueOf(appTime)*0.87);
            } else if (appName == "Tving") {
                appCarbon = (float) (Float.valueOf(appTime)*0.87);
            } else if (appName == "Wavve") {
                appCarbon = (float) (Float.valueOf(appTime)*0.87);
            } else if (appName == "Coupang play") {
                appCarbon = (float) (Float.valueOf(appTime)*0.87);
            } else if (appName == "Disney+") {
                appCarbon = (float) (Float.valueOf(appTime)*0.87);
            }
            ///

            else if (appName == "X") {
                appCarbon = (float) (Float.valueOf(appTime)*0.52);
            } else if (appName == "LinkedIn") {
                appCarbon = (float) (Float.valueOf(appTime)*0.47);
            } else if (appName == "Facebook") {
                appCarbon = (float) (Float.valueOf(appTime)*0.63);
            }

            //채팅 어플
            else if (appName == "Snapchat") {
                appCarbon = (float) (Float.valueOf(appTime)*0.65);
            } else if (appName == "Kakaotalk") {
                appCarbon = (float) (Float.valueOf(appTime)*0.65);
            } else if (appName == "Line") {
                appCarbon = (float) (Float.valueOf(appTime)*0.65);
            } else if (appName == "Telegram") {
                appCarbon = (float) (Float.valueOf(appTime)*0.65);
            }
            ///

            else if (appName == "Instagram") {
                appCarbon = (float) (Float.valueOf(appTime)*0.87);
            } else if (appName == "Pinterest") {
                appCarbon = (float) (Float.valueOf(appTime)*0.66);
            } else if (appName == "Reddit") {
                appCarbon = (float) (Float.valueOf(appTime)*0.92);
            } else if (appName == "Tiktok") {
                appCarbon = (float) (Float.valueOf(appTime)*0.96);
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
