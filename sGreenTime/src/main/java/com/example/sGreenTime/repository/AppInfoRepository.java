package com.example.sGreenTime.repository;

import com.example.sGreenTime.entity.AppInfoEntity;
import com.example.sGreenTime.entity.UsageStatsEntity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Repository
@RequiredArgsConstructor
public class AppInfoRepository {

    @PersistenceContext
    private final EntityManager em;

    public void save(AppInfoEntity appInfoEntity){
        em.persist(appInfoEntity);
    }

    public List<AppInfoEntity> findById(String id){
        //파라미터 바인딩 name으로, 조회 타입
        return em.createQuery("select m from AppInfoEntity m where m.id = :id", AppInfoEntity.class)
                .setParameter("id", id)
                .getResultList();
    }
/*
    public List<AppInfoEntity> findByIdandStartDate(String id, LocalDateTime startDate) {
        return em.createQuery("select m from AppInfoEntity m where m.id = :id and m.startDate = :startDate", AppInfoEntity.class)
                .setParameter("id", id)
                .setParameter("startDate", startDate)
                .getResultList();
    }
*/
    public List<AppInfoEntity> findByIdandStartDate(String id, LocalDateTime startOfDay, LocalDateTime endOfDay) {

        return em.createQuery("select m from AppInfoEntity m where m.id = :id and m.startDate between :startOfDay and :endOfDay", AppInfoEntity.class)
                .setParameter("id", id)
                .setParameter("startOfDay", startOfDay)
                .setParameter("endOfDay", endOfDay)
                .getResultList();
    }
}
