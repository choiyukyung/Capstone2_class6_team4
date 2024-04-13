package com.example.sGreenTime;

import com.example.sGreenTime.dto.MemberDTO;
import com.example.sGreenTime.repository.StatisticsRepository;
import com.example.sGreenTime.service.StatisticsService;
import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

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
        statisticsService.find(member);
    }
}
