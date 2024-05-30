package com.example.sGreenTime.service;

import com.example.sGreenTime.entity.MyPlaceEntity;
import com.example.sGreenTime.entity.VisitedParkEntity;
import com.example.sGreenTime.repository.MyPlaceRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class MyPlaceService {
    private final MyPlaceRepository myPlaceRepository;

    public List<MyPlaceEntity> findMyPlaceById(String id){
        return myPlaceRepository.findById(id);

    }
}
