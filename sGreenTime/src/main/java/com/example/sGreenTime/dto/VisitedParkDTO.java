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
public class VisitedParkDTO {
    private int parkId;
    private String id;
    @JsonProperty("park_name")
    private String parkName;
    private LocalDateTime visitTime;
}
