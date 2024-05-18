package com.example.sGreenTime;

import com.example.sGreenTime.service.VisitedService;
import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@SpringBootTest
@Transactional
public class MapServiceTest {

    @Autowired
    EntityManager em;

    @Autowired
    VisitedService visitedService;

    @DisplayName("mapTest")
    @Test

    //("/visitedTrails")
    public void MapTest() {
        String id = "sample";
        List<String> visitedTrailLnkNamList = visitedService.getVisitedTrailLnkNam(id);
        //model.addAttribute("visitedTrailList", visitedTrailLnkNamList);
        System.out.println(visitedTrailLnkNamList);
    }

}
