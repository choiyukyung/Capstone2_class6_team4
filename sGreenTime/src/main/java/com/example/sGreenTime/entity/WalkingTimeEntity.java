package com.example.sGreenTime.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Entity
@Setter
@Getter
@Table(name = "walking_time_table")
public class WalkingTimeEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="walking_time_id")
    private int walkingTimeId;
    @Column
    private String id;
    @Column
    private LocalDate date;
    @Column
    private float walkingTime; //분으로 소숫점 첫째자리까지 저장하기
}
