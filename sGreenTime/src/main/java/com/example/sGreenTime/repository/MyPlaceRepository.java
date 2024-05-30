package com.example.sGreenTime.repository;

import com.example.sGreenTime.entity.MyPlaceEntity;
import com.example.sGreenTime.entity.StatisticsEntity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class MyPlaceRepository {

    @PersistenceContext
    private final EntityManager em;

    public List<MyPlaceEntity> findById(String id){
        return em.createQuery("select m from MyPlaceEntity m where m.id = :id", MyPlaceEntity.class)
                .setParameter("id", id)
                .getResultList();
    }
}
