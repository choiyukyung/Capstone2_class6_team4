package com.example.sGreenTime.service;

import com.example.sGreenTime.dto.UsageStatsDTO;
import com.example.sGreenTime.entity.UsageStatsEntity;
import com.example.sGreenTime.repository.UsageStatsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class UsageStatsService {
    private final UsageStatsRepository usageStatsRepository;

    @Transactional
    public void save(UsageStatsDTO usageStatsDTO) {
        UsageStatsEntity entity = UsageStatsEntity.toUsageStatsEntity(usageStatsDTO);
        usageStatsRepository.save(entity);
    }
}
