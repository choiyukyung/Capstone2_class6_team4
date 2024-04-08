package com.example.sGreenTime.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@ToString
public class UsageStatsDTO {
    private int usageStatsId; //pk
    private String id;
    private String firstTimeStamp;
    private String lastTimeStamp;
    private String lastTimeUsed;
    private String packageName;
    private String totalTimeInForeground;
}
