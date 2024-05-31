package com.example.sGreenTime.controller;

import com.example.sGreenTime.dto.MemberDTO;
import com.example.sGreenTime.dto.WalkingTimeDTO;
import com.example.sGreenTime.entity.WalkingTimeEntity;
import com.example.sGreenTime.service.VisitedService;
import com.example.sGreenTime.service.WalkingTimeService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
public class WalkingTimeController {

    private final WalkingTimeService walkingTimeService;
    private final VisitedService visitedService;

    //@PostMapping(value = "/startWalk", produces = MediaType.APPLICATION_JSON_VALUE)
    @PostMapping("/startWalk")
    public Map<String, Object> getRecentVisitedPlace(@RequestBody MemberDTO memberDTO){
        Map<String, Object> map = new HashMap<>();
        map.put("place", visitedService.findMostRecentVisitedPlace(memberDTO.getId()));
        map.put("rank", walkingTimeService.getWalkingMyRank(memberDTO.getId()));
        return map;
    }

    @PostMapping("/endWalk")
    public Map<String, Object> getWalkingTimeInfo(@RequestBody WalkingTimeDTO walkingTimeDTO) {
        walkingTimeService.toWalkingTimeEntity(walkingTimeDTO);
        Map<String, Object> map = new HashMap<>();
        map.put("walking", walkingTimeService.getWalkingTimeInCar(walkingTimeDTO));
        map.put("rank", walkingTimeService.getWalkingMyRank(walkingTimeDTO.getId()));
        return map;
    }

    @PostMapping("/rankingTop10")
    public List<WalkingTimeEntity> rankingTop10() {
        return walkingTimeService.getWalkingTop10();
    }
}
