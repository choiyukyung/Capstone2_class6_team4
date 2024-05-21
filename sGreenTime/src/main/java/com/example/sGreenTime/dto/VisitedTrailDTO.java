package com.example.sGreenTime.dto;


import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.Column;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@ToString
public class VisitedTrailDTO {

    private int trailId;
    private String id;
    @JsonProperty("lnk_nam")
    private String lnkNam;
    @JsonProperty("cos_nam")
    private String cosNam;
    @JsonProperty("cos_num")
    private String cosNum;
    private String comment;
    @JsonProperty("len_tim")
    private String lenTim;
    @JsonProperty("leng_lnk")
    private String lengLnk;
    @JsonProperty("cos_lvl")
    private String cosLvl;
    @JsonProperty("cat_nam")
    private String catNam;
    private LocalDateTime visitTime;
}
