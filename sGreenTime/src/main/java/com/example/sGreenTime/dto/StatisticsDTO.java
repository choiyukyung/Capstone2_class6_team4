package com.example.sGreenTime.dto;

import com.example.sGreenTime.entity.StatisticsEntity;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@ToString
public class StatisticsDTO {
    private int statisticsId; //pk
    private String id;
    private float dayCarbonUsage;
    private float weekCarbonUsage;
    private float totalCarbonUsage;
    private LocalDate date;
    private int cDate;

    public static StatisticsDTO toStatisticsDTO(StatisticsEntity statisticsEntity){
        StatisticsDTO statisticsDTO = new StatisticsDTO();
        statisticsDTO.setStatisticsId(statisticsEntity.getStatisticsId());
        statisticsDTO.setId(statisticsEntity.getId());
        statisticsDTO.setDayCarbonUsage(statisticsEntity.getDayCarbonUsage());
        statisticsDTO.setWeekCarbonUsage(statisticsEntity.getWeekCarbonUsage());
        statisticsDTO.setTotalCarbonUsage(statisticsEntity.getTotalCarbonUsage());
        statisticsDTO.setDate(statisticsEntity.getDate());
        statisticsDTO.setCDate(statisticsDTO.getCDate());
        return statisticsDTO;
    }
}
