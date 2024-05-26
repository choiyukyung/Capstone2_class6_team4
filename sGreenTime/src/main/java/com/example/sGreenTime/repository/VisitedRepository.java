package com.example.sGreenTime.repository;

import com.example.sGreenTime.entity.UsageStatsEntity;
import com.example.sGreenTime.entity.VisitedHikingEntity;
import com.example.sGreenTime.entity.VisitedParkEntity;
import com.example.sGreenTime.entity.VisitedTrailEntity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
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

    public List<VisitedTrailEntity> findTrailByIdString(String id) {
        return em.createQuery("select v from VisitedTrailEntity v where v.id = :id", VisitedTrailEntity.class)
                .setParameter("id", id)
                .getResultList();
    }
    public List<VisitedHikingEntity> findHikingByIdString(String id) {
        return em.createQuery("select v from VisitedHikingEntity v where v.id = :id", VisitedHikingEntity.class)
                .setParameter("id", id)
                .getResultList();
    }

    public List<VisitedParkEntity> findParkByIdString(String id) {
        return em.createQuery("select v from VisitedParkEntity v where v.id = :id", VisitedParkEntity.class)
                .setParameter("id", id)
                .getResultList();
    }

    public List<VisitedTrailEntity> findTrailByVisitedTime(LocalDateTime startTime, LocalDateTime endTime, String id){
        String jpql = "SELECT v FROM VisitedTrailEntity v WHERE v.visitTime BETWEEN :startTime AND :endTime AND v.id = :id";
        TypedQuery<VisitedTrailEntity> query = em.createQuery(jpql, VisitedTrailEntity.class);
        query.setParameter("startTime", startTime);
        query.setParameter("endTime", endTime);
        query.setParameter("id", id);
        return query.getResultList();
    }

    public List<VisitedHikingEntity> findHikingByVisitedTime(LocalDateTime startTime, LocalDateTime endTime, String id){
        String jpql = "SELECT v FROM VisitedHikingEntity v WHERE v.visitTime BETWEEN :startTime AND :endTime AND v.id = :id";
        TypedQuery<VisitedHikingEntity> query = em.createQuery(jpql, VisitedHikingEntity.class);
        query.setParameter("startTime", startTime);
        query.setParameter("endTime", endTime);
        query.setParameter("id", id);
        return query.getResultList();
    }

    public List<VisitedParkEntity> findParkByVisitedTime(LocalDateTime startTime, LocalDateTime endTime, String id){
        String jpql = "SELECT v FROM VisitedParkEntity v WHERE v.visitTime BETWEEN :startTime AND :endTime AND v.id = :id";
        TypedQuery<VisitedParkEntity> query = em.createQuery(jpql, VisitedParkEntity.class);
        query.setParameter("startTime", startTime);
        query.setParameter("endTime", endTime);
        query.setParameter("id", id);
        return query.getResultList();
    }

    public VisitedTrailEntity findRecentVisitedTrail(String id){
        String jpql = "SELECT v FROM VisitedTrailEntity v WHERE v.id = :id ORDER BY v.visitTime DESC";
        TypedQuery<VisitedTrailEntity> query = em.createQuery(jpql, VisitedTrailEntity.class);
        query.setParameter("id", id);
        query.setMaxResults(1);
        return query.getResultList().stream().findFirst().orElse(null);
    }

    public VisitedHikingEntity findRecentVisitedHiking(String id){
        String jpql = "SELECT v FROM VisitedHikingEntity v WHERE v.id = :id ORDER BY v.visitTime DESC";
        TypedQuery<VisitedHikingEntity> query = em.createQuery(jpql, VisitedHikingEntity.class);
        query.setParameter("id", id);
        query.setMaxResults(1);
        return query.getResultList().stream().findFirst().orElse(null);
    }

    public VisitedParkEntity findRecentVisitedPark(String id){
        String jpql = "SELECT v FROM VisitedParkEntity v WHERE v.id = :id ORDER BY v.visitTime DESC";
        TypedQuery<VisitedParkEntity> query = em.createQuery(jpql, VisitedParkEntity.class);
        query.setParameter("id", id);
        query.setMaxResults(1);
        return query.getResultList().stream().findFirst().orElse(null);
    }

}
