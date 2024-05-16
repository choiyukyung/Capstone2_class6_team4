package com.example.sGreenTime.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Setter
@Getter
@Table(name = "visited_hiking_table")
public class VisitedHikingEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="hiking_id")
    private int hikingId;
    @Column
    private String id;
    @Column
    private String upMin;
    @Column
    private String downMin;
    @Column
    private String mntnMm;
    @Column
    private String secLen;
    @Column
    private String catNam;
    //{"up_min":"3","down_min":"2","mntn_nm":"배봉산","sec_len":"180","cat_nam":"하"}
}
