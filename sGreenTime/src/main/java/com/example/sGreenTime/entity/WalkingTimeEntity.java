package com.example.sGreenTime.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalDateTime;

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
    @Column @JsonIgnore
    private LocalDateTime dateTime;
    @Column
    private float walkingTime; //분으로 소숫점 첫째자리까지 저장하기
}
