package com.example.sGreenTime.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Setter
@Getter
@Table(name = "visited_park_table")
public class VisitedParkEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="park_id")
    private int parkId;
    @Column
    private String id;
    @Column
    private String parkName;
    //{"park_name":"수리산"}
}
