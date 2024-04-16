package com.example.sGreenTime.repository;

import com.example.sGreenTime.entity.CarbonInObjEntity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class CarbonInObjRepository {
    @PersistenceContext
    private final EntityManager em;

    public void save(CarbonInObjEntity carbonInObjEntity){
        em.persist(carbonInObjEntity);
    }

    public Optional<CarbonInObjEntity> findByIdAndDate(String id, LocalDate date){
        return em.createQuery("select m from CarbonInObjEntity m where m.id = :id and m.date = :date", CarbonInObjEntity.class)
                .setParameter("id", id)
                .setParameter("date", date)
                .getResultList()
                .stream()
                .findFirst();
    }
}
