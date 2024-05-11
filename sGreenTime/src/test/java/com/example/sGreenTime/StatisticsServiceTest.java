package com.example.sGreenTime;

import com.example.sGreenTime.dto.MemberDTO;
import com.example.sGreenTime.entity.StatisticsEntity;
import com.example.sGreenTime.repository.StatisticsRepository;
import com.example.sGreenTime.service.StatisticsService;
import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@SpringBootTest
@Transactional
public class StatisticsServiceTest {
    @Autowired
    StatisticsService statisticsService;
    @Autowired
    StatisticsRepository statisticsRepository;
    @Autowired
    EntityManager em;

    @DisplayName("statisticsTest")
    @Test
    public void StatisticsTest(){
        MemberDTO member = new MemberDTO();
        member.setId("33");
        LocalDate day = LocalDate.now().minusDays(1);
        statisticsService.find(member, day);

        // 일주일치 매일 가져오기 test
        List<StatisticsEntity> statisticsEntityList = new ArrayList<>();
        for(int i = 0;i<7;i++){
            day = LocalDate.now().minusDays(i+1);
            statisticsEntityList.add(statisticsService.find(member, day));
        }

        for(StatisticsEntity entity : statisticsEntityList){
            System.out.println(entity.getDate() + " " + entity.getDayCarbonUsage() + " " + entity.getTotalCarbonUsage());
        }

    }
}
