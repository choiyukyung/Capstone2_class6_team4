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
import java.util.List;

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
        System.out.println("111");
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
        VisitedHikingEntity newVisitedHikingEntity = VisitedHikingEntity.toVisitedHikingEntity(visitedHikingDTO);
        visitedRepository.save(newVisitedHikingEntity);
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
        VisitedParkEntity newVisitedParkEntity = VisitedParkEntity.toVisitedParkEntity(visitedParkDTO);
        visitedRepository.save(newVisitedParkEntity);
    }
}
