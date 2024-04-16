package com.example.sGreenTime.service;

import com.example.sGreenTime.dto.MemberDTO;
import com.example.sGreenTime.entity.CarbonInObjEntity;
import com.example.sGreenTime.entity.StatisticsEntity;
import com.example.sGreenTime.repository.CarbonInObjRepository;
import com.example.sGreenTime.repository.StatisticsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.DecimalFormat;
import java.time.LocalDate;
import java.util.Optional;

@Service
@Transactional
@RequiredArgsConstructor
public class CarbonInObjService {

    private final StatisticsRepository statisticsRepository;
    private final CarbonInObjRepository carbonInObjRepository;

    @Transactional
    public void save(String id, LocalDate yesterday){
        Optional<StatisticsEntity> statisticsEntity = statisticsRepository.findByIdAndDate(id, yesterday);
        CarbonInObjEntity carbonInObjEntity = new CarbonInObjEntity();

        if(statisticsEntity.isPresent()){
            StatisticsEntity statistics = statisticsEntity.get();

            //1g -> 8.26m
            float car = (float) (statistics.getTotalCarbonUsage() * 8.26);
            //11900g/365 = 32.6g
            //내가 나무 1그루가 n일동안 흡수하는 이산화탄소량을 절감하였다.
            float tree = (float) (statistics.getTotalCarbonUsage() / 32.6);

            DecimalFormat df = new DecimalFormat("#.#");

            String formattedNumber = df.format(car);
            float resultCar = Float.parseFloat(formattedNumber);

            formattedNumber = df.format(tree);
            float resultTree = Float.parseFloat(formattedNumber);


            carbonInObjEntity.setCar(resultCar);
            carbonInObjEntity.setTree(resultTree);
            carbonInObjEntity.setId(id);
            carbonInObjEntity.setTotalCarbonUsage(statistics.getTotalCarbonUsage());
            carbonInObjEntity.setDate(yesterday);
            carbonInObjRepository.save(carbonInObjEntity);
        }
    }

    public CarbonInObjEntity find(MemberDTO memberDTO) {
        LocalDate yesterday = LocalDate.now().minusDays(1);
        Optional<CarbonInObjEntity> carbonInObjEntity = carbonInObjRepository.findByIdAndDate(memberDTO.getId(), yesterday);
        if(carbonInObjEntity.isPresent()){
            return carbonInObjEntity.get();
        }
        return null;
    }
}
