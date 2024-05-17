package com.example.sGreenTime.repository;

import com.example.sGreenTime.entity.UsageStatsEntity;
import com.example.sGreenTime.entity.VisitedHikingEntity;
import com.example.sGreenTime.entity.VisitedParkEntity;
import com.example.sGreenTime.entity.VisitedTrailEntity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class VisitedRepository {
    @PersistenceContext
    private final EntityManager em;

    public void save(VisitedParkEntity visitedParkEntity) {
        em.persist(visitedParkEntity);
    }
    public void save(VisitedTrailEntity visitedTrailEntity) {
        em.persist(visitedTrailEntity);
    }
    public void save(VisitedHikingEntity visitedHikingEntity) { em.persist(visitedHikingEntity); }

    public List<VisitedTrailEntity> findAllByIdString(String id) {
        return em.createQuery("select v from VisitedTrailEntity v where v.id = :id", VisitedTrailEntity.class)
                .setParameter("id", id)
                .getResultList();
    }

}
