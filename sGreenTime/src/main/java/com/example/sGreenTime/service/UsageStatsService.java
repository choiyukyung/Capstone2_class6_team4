package com.example.sGreenTime.service;

import com.example.sGreenTime.dto.UsageStatsDTO;
import com.example.sGreenTime.entity.UsageStatsEntity;
import com.example.sGreenTime.repository.UsageStatsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class UsageStatsService {
    private final UsageStatsRepository usageStatsRepository;

    @Transactional
    public UsageStatsEntity save(UsageStatsDTO usageStatsDTO) {
        String packageName = usageStatsDTO.getPackageName();
        System.out.println(packageName);


        //totaltimeinforeground 분으로 가공 필요
        int timeInMillisec = Integer.parseInt(usageStatsDTO.getTotalTimeInForeground());
        int totalTime = timeInMillisec / 6000;

        // 동영상 어플
        if(packageName.equals("com.google.android.youtube")){
            packageName = "youtube";
        } else if (packageName.equals("com.netflix.mediaclient")) {
            packageName = "netflix";
        } else if (packageName.equals("net.cj.cjhv.gs.tving")) {
            packageName = "tving";
        } else if (packageName.equals("kr.co.captv.pooqV2")) {
            packageName = "wavve";
        } else if (packageName.equals("com.coupang.mobile.play")) {
            packageName = "coupang play";
        } else if (packageName.equals("com.disney.disneyplus")) {
            packageName = "disney+";
        }
        ///

        else if (packageName.equals("com.twitter.android")) {
            packageName = "X";
        } else if (packageName.equals("com.linkedin.android")) {
            packageName = "linkedIn";
        } else if (packageName.equals("com.facebook.katana")) {
            packageName = "facebook";
        }

        //채팅 어플
        else if (packageName.equals("com.snapchat.android")) {
            packageName = "snapchat";
        } else if (packageName.equals("com.kakao.talk")) {
            packageName = "kakaotalk";
        } else if (packageName.equals("jp.naver.line.android")) {
            packageName = "line";
        } else if (packageName.equals("org.telegram.messenger")) {
            packageName = "telegram";
        }
        ///

        else if (packageName.equals("com.instagram.android")) {
            packageName = "instagram";
        } else if (packageName.equals("com.pinterest")) {
            packageName = "pinterest";
        } else if (packageName.equals("com.reddit.frontpage")) {
            packageName = "reddit";
        } else if (packageName.equals("com.ss.android.ugc.trill")) {
            packageName = "tiktok";
        } else {
        }
        UsageStatsEntity entity = UsageStatsEntity.toUsageStatsEntity(usageStatsDTO.getUsageStatsId(), usageStatsDTO.getId(), usageStatsDTO.getLastTimeUsed(), packageName, Integer.toString(totalTime), usageStatsDTO.getNowTimeStamp());
        usageStatsRepository.save(entity);
        System.out.println(packageName);
        return entity;
    }
}
