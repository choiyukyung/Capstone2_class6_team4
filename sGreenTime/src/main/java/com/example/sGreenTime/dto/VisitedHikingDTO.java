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
public class VisitedHikingDTO {

    private int hikingId;
    private String id;
    @JsonProperty("up_min")
    private String upMin;
    @JsonProperty("down_min")
    private String downMin;
    @JsonProperty("mntn_nm")
    private String mntnNm;
    @JsonProperty("sec_len")
    private String secLen;
    @JsonProperty("cat_nam")
    private String catNam;
    private LocalDateTime visitTime;
}
