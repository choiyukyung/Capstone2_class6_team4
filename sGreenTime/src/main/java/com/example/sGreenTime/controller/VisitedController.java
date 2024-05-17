package com.example.sGreenTime.controller;


import com.example.sGreenTime.dto.VisitedTrailDTO;
import com.example.sGreenTime.entity.VisitedTrailEntity;
import com.example.sGreenTime.service.VisitedService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
public class VisitedController {

    private final VisitedService visitedService;

    @PostMapping("/visitedTrails")
    public List<String> getVisitedTrails(Model model, String id){
        List<String> visitedTrailLnkNamList = visitedService.getVisitedTrailLnkNam(id);
        model.addAttribute("visitedTrailList", visitedTrailLnkNamList);
        return visitedTrailLnkNamList;
    }

    @PostMapping("/addVisitedTrail")
    public void addVisitedTrail(@RequestBody VisitedTrailDTO visitedTrailDTO){
        System.out.println(visitedTrailDTO.getCatNam());
        visitedService.saveTrail(visitedTrailDTO);
    }
}
