package com.example.sGreenTime.controller;


import com.example.sGreenTime.dto.MemberDTO;
import com.example.sGreenTime.dto.VisitedHikingDTO;
import com.example.sGreenTime.dto.VisitedParkDTO;
import com.example.sGreenTime.dto.VisitedTrailDTO;
import com.example.sGreenTime.service.VisitedService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

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

    @PostMapping("/notVisitedTrail")
    public String notVisitedTrail(@RequestBody VisitedTrailDTO visitedTrailDTO){
        return "farTrail";
    }

    @PostMapping("/visitedHikings")
    public List<String> getVisitedHikings(Model model, String id){
        List<String> visitedHikingMntnNmList = visitedService.getVisitedHikingMntnNm(id);
        model.addAttribute("visitedHikingList", visitedHikingMntnNmList);
        return visitedHikingMntnNmList;
    }

    @PostMapping("/addVisitedHiking")
    public void addVisitedHiking(@RequestBody VisitedHikingDTO visitedHikingDTO){
        System.out.println(visitedHikingDTO.getMntnNm());
        visitedService.saveHiking(visitedHikingDTO);
    }

    @PostMapping("/notVisitedHiking")
    public String notVisitedHiking(@RequestBody VisitedHikingDTO visitedHikingDTO){
        return "farHiking";
    }

    @PostMapping("/visitedParks")
    public List<String> getVisitedParks(Model model, String id){
        List<String> visitedParkNameList = visitedService.getVisitedParkName(id);
        model.addAttribute("visitedParkList", visitedParkNameList);
        return visitedParkNameList;
    }

    @PostMapping("/addVisitedPark")
    public void addVisitedPark(@RequestBody VisitedParkDTO visitedParkDTO){
        System.out.println(visitedParkDTO.getParkName());
        visitedService.savePark(visitedParkDTO);
    }

    @PostMapping("/notVisitedPark")
    public String notVisitedPark(@RequestBody VisitedParkDTO visitedParkDTO){
        return "farPark";
    }


}
