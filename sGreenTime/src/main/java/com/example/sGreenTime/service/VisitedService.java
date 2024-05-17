package com.example.sGreenTime.service;

import com.example.sGreenTime.dto.VisitedTrailDTO;
import com.example.sGreenTime.entity.VisitedTrailEntity;
import com.example.sGreenTime.repository.VisitedRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class VisitedService {
    private final VisitedRepository visitedRepository;

    public List<String> getVisitedTrailLnkNam(String id){
        List<VisitedTrailEntity> visitedTrails = visitedRepository.findAllByIdString(id);
        List<String> lnkNamList = new ArrayList<>();
        for(VisitedTrailEntity trail : visitedTrails){
            lnkNamList.add(trail.getLnkNam());
        }
        return lnkNamList;
    }

    public void saveTrail(VisitedTrailDTO visitedTrailDTO){
        VisitedTrailEntity newVisitedTrailEntity = VisitedTrailEntity.toVisitedTrailEntity(visitedTrailDTO);
        visitedRepository.save(newVisitedTrailEntity);
    }
}
