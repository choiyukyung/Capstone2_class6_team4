package com.example.sGreenTime.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@Table(name = "app_info_table")
public class AppInfoEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "screentime_id")
    private int screentimeId;
    @Column
    private LocalDateTime startDate;
    @Column
    private LocalDateTime endDate;
    @Column
    private String id;
    @Column
    private String appEntry;
    @Column
    private String appIcon;
    @Column
    private String appTime;
    @Column
    private float appCarbon;


}
