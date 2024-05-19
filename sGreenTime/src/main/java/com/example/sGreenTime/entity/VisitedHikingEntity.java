package com.example.sGreenTime.entity;

import com.example.sGreenTime.dto.VisitedHikingDTO;
import com.example.sGreenTime.dto.VisitedTrailDTO;
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
    private String mntnNm;
    @Column
    private String secLen;
    @Column
    private String catNam;
    //{"up_min":"3","down_min":"2","mntn_nm":"배봉산","sec_len":"180","cat_nam":"하"}

    public static VisitedHikingEntity toVisitedHikingEntity(VisitedHikingDTO visitedHikingDTO){
        VisitedHikingEntity visitedHikingEntity = new VisitedHikingEntity();
        visitedHikingEntity.setId(visitedHikingDTO.getId());
        visitedHikingEntity.setUpMin(visitedHikingDTO.getUpMin());
        visitedHikingEntity.setDownMin(visitedHikingDTO.getDownMin());
        visitedHikingEntity.setMntnNm(visitedHikingDTO.getMntnNm());
        visitedHikingEntity.setSecLen(visitedHikingDTO.getSecLen());
        visitedHikingEntity.setCatNam(visitedHikingDTO.getCatNam());
        return visitedHikingEntity;
    }
}