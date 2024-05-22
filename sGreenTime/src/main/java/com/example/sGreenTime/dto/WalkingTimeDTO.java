package com.example.sGreenTime.dto;

import jakarta.persistence.Column;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@ToString
public class WalkingTimeDTO {
    private int walkingTimeId;
    private String id;
    private float totalWalkTime;
    private float totalDistractionCnt;
}
