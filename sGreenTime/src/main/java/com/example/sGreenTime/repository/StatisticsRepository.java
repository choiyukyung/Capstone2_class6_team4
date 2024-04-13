package com.example.sGreenTime.repository;

import com.example.sGreenTime.entity.StatisticsEntity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class StatisticsRepository {
    @PersistenceContext
    private final EntityManager em;

    public void save(StatisticsEntity statisticsEntity){
        em.persist(statisticsEntity);
    }

    public Optional<StatisticsEntity> findById(String id){
        return em.createQuery("select m from StatisticsEntity m where m.id = :id", StatisticsEntity.class)
                .setParameter("id", id)
                .getResultList()
                .stream()
                .findFirst();
    }

    public Optional<StatisticsEntity> findByIdAndDate(String id, LocalDate date){
        return em.createQuery("select m from StatisticsEntity m where m.id = :id and m.date = :date", StatisticsEntity.class)
                .setParameter("id", id)
                .setParameter("date", date)
                .getResultList()
                .stream()
                .findFirst();
    }
}
