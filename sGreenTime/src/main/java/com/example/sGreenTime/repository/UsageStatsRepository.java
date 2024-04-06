package com.example.sGreenTime.repository;

import com.example.sGreenTime.entity.UsageStatsEntity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class UsageStatsRepository {
    @PersistenceContext
    private final EntityManager em;
    public void save(UsageStatsEntity usageStatsEntity){
        em.persist(usageStatsEntity);
    }
}
