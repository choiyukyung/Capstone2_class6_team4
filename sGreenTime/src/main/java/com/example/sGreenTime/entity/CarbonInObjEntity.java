package com.example.sGreenTime.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Entity
@Getter
@Setter
@Table(name = "carbon_in_obj_table")
public class CarbonInObjEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="carbon_in_obj_id")
    private int carbonInObjId; //pk
    @Column
    private float totalCarbonUsage; //statistics 연관
    @Column @JsonIgnore
    private LocalDate date;
    @Column
    private String id;
    @Column
    private float tree;
    @Column
    private float car;

}
