package com.example.sGreenTime.controller;

import com.example.sGreenTime.dto.WalkingTimeDTO;
import com.example.sGreenTime.service.WalkingTimeService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
public class WalkingTimeController {
    private final WalkingTimeService walkingTimeService;
    @PostMapping("/walkingTime")
    public Map<String, Object> getWalkingTimeInfo(@RequestBody WalkingTimeDTO walkingTimeDTO){
        walkingTimeService.toWalkingTimeEntity(walkingTimeDTO);
        return walkingTimeService.getVisitedPlaces(walkingTimeDTO);
    }
}
