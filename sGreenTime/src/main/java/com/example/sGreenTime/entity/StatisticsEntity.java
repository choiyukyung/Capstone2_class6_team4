package com.example.sGreenTime.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Entity
@Setter
@Getter
@Table(name = "statistics_table")
public class StatisticsEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="statistics_id")
    private int statisticsId; //pk
    @Column
    private String id;
    @Column
    private float dayCarbonUsage;
    @Column
    private float weekCarbonUsage;
    @Column
    private float totalCarbonUsage;
    @Column @JsonIgnore
    private LocalDate date;
    @Column
    private int cDate; // 누적일

}
