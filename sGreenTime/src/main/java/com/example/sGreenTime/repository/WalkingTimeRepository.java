package com.example.sGreenTime.repository;

import com.example.sGreenTime.entity.WalkingTimeEntity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class WalkingTimeRepository {
    @PersistenceContext
    private final EntityManager em;

    public void save(WalkingTimeEntity walkingTimeEntity) {
        em.persist(walkingTimeEntity);
    }

    public List<WalkingTimeEntity> findAll() {
        String jpql = "SELECT w FROM WalkingTimeEntity w";
        TypedQuery<WalkingTimeEntity> query = em.createQuery(jpql, WalkingTimeEntity.class);
        return query.getResultList();
    }
}
