package com.example.sGreenTime.repository;

import com.example.sGreenTime.entity.WalkingTimeEntity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class WalkingTimeRepository {
    @PersistenceContext
    private final EntityManager em;

    public void save(WalkingTimeEntity walkingTimeEntity) {
        em.persist(walkingTimeEntity);
    }
}
