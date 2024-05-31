package com.example.sGreenTime.entity;

import com.example.sGreenTime.dto.VisitedTrailDTO;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Setter
@Getter
@Table(name = "visited_trail_table")
public class VisitedTrailEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="trail_id")
    private int trailId;
    @Column
    private String id;
    @Column
    private String lnkNam;
    @Column
    private String cosNam;
    @Column
    private String cosNum;
    @Column
    private String comment;
    @Column
    private String lenTim;
    @Column
    private String lengLnk;
    @Column
    private String cosLvl;
    @Column
    private String catNam;
    //{"lnk_nam":"애국의숲길","cos_nam":"관악산둘레길","cos_num":"1코스","comment":"","len_tim":"←2시간30분 6.2Km→",
    // "leng_lnk":"6729.79251047","cos_lvl":"","cat_nam":"둘레길링크"}
    @Column @JsonIgnore
    private LocalDateTime visitTime;


    public static VisitedTrailEntity toVisitedTrailEntity(VisitedTrailDTO visitedTrailDTO){
        VisitedTrailEntity visitedTrailEntity = new VisitedTrailEntity();
        visitedTrailEntity.setId(visitedTrailDTO.getId());
        visitedTrailEntity.setLnkNam(visitedTrailDTO.getLnkNam());
        visitedTrailEntity.setCosNam(visitedTrailDTO.getCosNam());
        visitedTrailEntity.setCosNum(visitedTrailDTO.getCosNum());
        visitedTrailEntity.setComment(visitedTrailDTO.getComment());
        visitedTrailEntity.setLenTim(visitedTrailDTO.getLenTim());
        visitedTrailEntity.setLengLnk(visitedTrailDTO.getLengLnk());
        visitedTrailEntity.setCosLvl(visitedTrailDTO.getCosLvl());
        visitedTrailEntity.setCatNam(visitedTrailDTO.getCatNam());
        return visitedTrailEntity;
    }
}
