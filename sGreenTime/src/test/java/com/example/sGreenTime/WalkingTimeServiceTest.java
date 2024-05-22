package com.example.sGreenTime;

import com.example.sGreenTime.dto.WalkingTimeDTO;
import com.example.sGreenTime.entity.WalkingTimeEntity;
import com.example.sGreenTime.repository.WalkingTimeRepository;
import com.example.sGreenTime.service.WalkingTimeService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@SpringBootTest
@Transactional
public class WalkingTimeServiceTest {
    @Autowired
    WalkingTimeService walkingTimeService;
    @Autowired
    WalkingTimeRepository walkingTimeRepository;

    @DisplayName("WalkingTimeTest")
    @Test
    public void walkingTimeTest(){
        WalkingTimeDTO walkingTimeDTO1 = new WalkingTimeDTO();
        walkingTimeDTO1.setTotalWalkTime(600000);
        walkingTimeDTO1.setId("sample");
        Map<String, Object> result =walkingTimeService.getVisitedPlaces(walkingTimeDTO1);
        System.out.println(result.get("parks"));
        System.out.println(result.get("trails"));
        System.out.println(result.get("hikings"));
        System.out.println(result.get("totalWalkTimeInCar"));

        List<WalkingTimeEntity> top10 = walkingTimeService.getWalkingTop10();
        for(WalkingTimeEntity i : top10){
            System.out.println(i.getId());
            System.out.println(i.getWalkingTime());
        }
    }
}
