package com.example.sGreenTime.service;

import com.example.sGreenTime.dto.UsageStatsDTO;
import com.example.sGreenTime.entity.UsageStatsEntity;
import com.example.sGreenTime.repository.UsageStatsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
        int totalTime = timeInMillisec / 60000;

        // 동영상 어플
        if(packageName.equals("com.google.android.youtube")){
            packageName = "Youtube";
        } else if (packageName.equals("com.netflix.mediaclient")) {
            packageName = "Netflix";
        } else if (packageName.equals("net.cj.cjhv.gs.tving")) {
            packageName = "Tving";
        } else if (packageName.equals("kr.co.captv.pooqV2")) {
            packageName = "Wavve";
        } else if (packageName.equals("com.coupang.mobile.play")) {
            packageName = "Coupang play";
        } else if (packageName.equals("com.disney.disneyplus")) {
            packageName = "Disney+";
        }
        ///

        else if (packageName.equals("com.twitter.android")) {
            packageName = "X";
        } else if (packageName.equals("com.linkedin.android")) {
            packageName = "LinkedIn";
        } else if (packageName.equals("com.facebook.katana")) {
            packageName = "Facebook";
        }

        //채팅 어플
        else if (packageName.equals("com.snapchat.android")) {
            packageName = "Snapchat";
        } else if (packageName.equals("com.kakao.talk")) {
            packageName = "Kakaotalk";
        } else if (packageName.equals("jp.naver.line.android")) {
            packageName = "Line";
        } else if (packageName.equals("org.telegram.messenger")) {
            packageName = "Telegram";
        }
        ///

        else if (packageName.equals("com.instagram.android")) {
            packageName = "Instagram";
        } else if (packageName.equals("com.pinterest")) {
            packageName = "Pinterest";
        } else if (packageName.equals("com.reddit.frontpage")) {
            packageName = "Reddit";
        } else if (packageName.equals("com.ss.android.ugc.trill")) {
            packageName = "Tiktok";
        }

        // 여기서부터 새로 추가
        else if (packageName.equals("com.samsung.android.calendar")) {
            packageName = "Samsung calendar";
        } else if (packageName.equals("com.discord")) {
            packageName = "Discord";
        } else if (packageName.equals("com.musinsa.store")) {
            packageName = "Musinsa";
        } else if (packageName.equals("com.android.chrome")) {
            packageName = "Chrome";
        } else if (packageName.equals("com.spotify.music")) {
            packageName = "Spotify";
        } else if (packageName.equals("com.airbnb.android")) {
            packageName = "Airbnb";
        } else if (packageName.equals("com.android.settings")) {
            packageName = "Settings";
        } else if (packageName.equals("samsung.android.spay")) {
            packageName = "Samsung Wallet";
        } else if (packageName.equals("com.kakao.taxi")) {
            packageName = "Kakao T";
        } else if (packageName.equals("com.example.capstone")){
            packageName = "SGreenTime";
        } else if (packageName.equals("com.nhn.android.search")){
            packageName = "Naver";
        } else if (packageName.equals("com.sec.android.camera")){
            packageName = "Camera";
        }


        //game(종류별)
        else if (packageName.equals("com.kiloo.subwaysurf")){
            packageName = "Subway Surfers";
        } else if (packageName.equals("com.kitkagames.fallbuddies")){
            packageName = "Stumble Guys";
        } else if (packageName.equals("com.roblox.client")){
            packageName = "Roblox";
        } else if (packageName.equals("com.king.candycrushsaga")){
            packageName = "Candy Crush Saga";
        } else if (packageName.equals("com.easygames.race")){
            packageName = "Race Master 3D";
        } else if (packageName.equals("com.miniclip.eightballpool")){
            packageName = "8 Ball Pool";
        } else if (packageName.equals("com.ea.gp.fifamobile")){
            packageName = "FIFA Mobile";
        } else if (packageName.equals("com.fusee.MergeMaster")){
            packageName = "Merge Master";
        } else if (packageName.equals("com.dts.freefireth")){
            packageName = "Garena Free Fire";
        }


        else {
            packageName = "others";
        }
        UsageStatsEntity entity = UsageStatsEntity.toUsageStatsEntity(usageStatsDTO.getUsageStatsId(), usageStatsDTO.getId(), usageStatsDTO.getLastTimeUsed(), packageName, Integer.toString(totalTime), usageStatsDTO.getNowTimeStamp());
        usageStatsRepository.save(entity);
        System.out.println(packageName);
        return entity;
    }
}
