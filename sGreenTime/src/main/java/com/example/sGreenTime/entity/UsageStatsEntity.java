package com.example.sGreenTime.entity;

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
    private String id;
    @Column
    private String lastTimeUsed;
    @Column
    private String packageName;
    @Column
    private String totalTimeInForeground;
    @Column
    private String nowTimeStamp;

    public static UsageStatsEntity toUsageStatsEntity(int usageStatsId, String id, String lastTimeUsed, String packageName, String totalTimeInForeground, String nowTimeStamp){
        UsageStatsEntity usageStatsEntity = new UsageStatsEntity();
        usageStatsEntity.setUsageStatsId(usageStatsId);
        usageStatsEntity.setId(id);
        usageStatsEntity.setLastTimeUsed(lastTimeUsed);
        usageStatsEntity.setPackageName(packageName);
        usageStatsEntity.setTotalTimeInForeground(totalTimeInForeground);
        usageStatsEntity.setNowTimeStamp(nowTimeStamp);
        return usageStatsEntity;
    }
}
