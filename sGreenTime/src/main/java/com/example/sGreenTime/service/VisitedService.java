package com.example.sGreenTime.service;

import com.example.sGreenTime.dto.VisitedHikingDTO;
import com.example.sGreenTime.dto.VisitedParkDTO;
import com.example.sGreenTime.dto.VisitedTrailDTO;
import com.example.sGreenTime.entity.VisitedHikingEntity;
import com.example.sGreenTime.entity.VisitedParkEntity;
import com.example.sGreenTime.entity.VisitedTrailEntity;
import com.example.sGreenTime.repository.VisitedRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
@RequiredArgsConstructor
public class VisitedService {
    private final VisitedRepository visitedRepository;

    public List<String> getVisitedTrailLnkNam(String id){
        List<VisitedTrailEntity> visitedTrails = visitedRepository.findTrailByIdString(id);
        List<String> lnkNamList = new ArrayList<>();
        for(VisitedTrailEntity trail : visitedTrails){
            lnkNamList.add(trail.getLnkNam());
        }
        return lnkNamList;
    }

    public void saveTrail(VisitedTrailDTO visitedTrailDTO){
        VisitedTrailEntity visitedTrailEntity = VisitedTrailEntity.toVisitedTrailEntity(visitedTrailDTO);
        visitedTrailEntity.setVisitTime(LocalDateTime.now());
        visitedRepository.save(visitedTrailEntity);
    }

    public List<String> getVisitedHikingMntnNm(String id){
        List<VisitedHikingEntity> visitedHikings = visitedRepository.findHikingByIdString(id);
        List<String> mntnNmList = new ArrayList<>();
        for(VisitedHikingEntity trail : visitedHikings){
            mntnNmList.add(trail.getMntnNm());
        }
        return mntnNmList;
    }

    public void saveHiking(VisitedHikingDTO visitedHikingDTO){
        VisitedHikingEntity visitedHikingEntity = VisitedHikingEntity.toVisitedHikingEntity(visitedHikingDTO);
        visitedHikingEntity.setVisitTime(LocalDateTime.now());
        visitedRepository.save(visitedHikingEntity);
    }

    public List<String> getVisitedParkName(String id){
        List<VisitedParkEntity> visitedParks = visitedRepository.findParkByIdString(id);
        List<String> mntnNmList = new ArrayList<>();
        for(VisitedParkEntity trail : visitedParks){
            mntnNmList.add(trail.getParkName());
        }
        return mntnNmList;
    }

    public void savePark(VisitedParkDTO visitedParkDTO){
        VisitedParkEntity visitedParkEntity = VisitedParkEntity.toVisitedParkEntity(visitedParkDTO);
        visitedParkEntity.setVisitTime(LocalDateTime.now());
        visitedRepository.save(visitedParkEntity);
    }

    public Map<String, Object> findMostRecentVisitedPlace(String id){
        VisitedTrailEntity recentTrail = visitedRepository.findRecentVisitedTrail(id);
        VisitedHikingEntity recentHiking = visitedRepository.findRecentVisitedHiking(id);
        VisitedParkEntity recentPark = visitedRepository.findRecentVisitedPark(id);

        Object mostRecentVisitedPlace = null;
        LocalDateTime mostRecentTime = null;
        String placeType = "";

        if(recentTrail != null){
            mostRecentVisitedPlace = recentTrail;
            mostRecentTime = recentTrail.getVisitTime();
            placeType = "trail";
        }
        if(recentHiking != null && (mostRecentTime == null|| recentHiking.getVisitTime().isAfter(mostRecentTime))){
            mostRecentVisitedPlace = recentHiking;
            mostRecentTime = recentHiking.getVisitTime();
            placeType = "hiking";
        }
        if(recentPark != null && (mostRecentTime == null|| recentPark.getVisitTime().isAfter(mostRecentTime))){
            mostRecentVisitedPlace = recentPark;
            mostRecentTime = recentPark.getVisitTime();
            placeType = "park";
        }

        Map<String, Object> result = new HashMap<>();
        
        //LocalDateTime nowMinusThreeMin = LocalDateTime.now().minusMinutes(3);
        LocalDateTime nowMinus20Sec = LocalDateTime.now().minusSeconds(20);
        if(mostRecentTime.isAfter(nowMinus20Sec)) {
            result.put(placeType, mostRecentVisitedPlace);
        }
        return result;

    }
}
