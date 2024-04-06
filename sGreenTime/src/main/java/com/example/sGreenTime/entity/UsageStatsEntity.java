package com.example.sGreenTime.entity;

import com.example.sGreenTime.dto.UsageStatsDTO;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Setter
@Getter
@Table(name = "usage_stats_table")
public class UsageStatsEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="usage_stats_id")
    private int usageStatsId; //pk
    @Column
    private String firstTimeStamp;
    @Column
    private String lastTimeStamp;
    @Column
    private String lastTimeUsed;
    @Column
    private String packageName;
    @Column
    private String totalTimeInForeground;

    public static UsageStatsEntity toUsageStatsEntity(UsageStatsDTO usageStatsDTO){
        UsageStatsEntity usageStatsEntity = new UsageStatsEntity();
        usageStatsEntity.setUsageStatsId(usageStatsDTO.getUsageStatsId());
        usageStatsEntity.setFirstTimeStamp(usageStatsDTO.getFirstTimeStamp());
        usageStatsEntity.setLastTimeStamp(usageStatsDTO.getLastTimeStamp());
        usageStatsEntity.setLastTimeUsed(usageStatsDTO.getLastTimeUsed());
        usageStatsEntity.setPackageName(usageStatsDTO.getPackageName());
        usageStatsEntity.setTotalTimeInForeground(usageStatsDTO.getTotalTimeInForeground());
        return usageStatsEntity;
    }
}
