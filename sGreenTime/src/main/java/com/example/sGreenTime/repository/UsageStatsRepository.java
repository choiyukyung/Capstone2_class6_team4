package com.example.sGreenTime.repository;

import com.example.sGreenTime.entity.UsageStatsEntity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class UsageStatsRepository {
    @PersistenceContext
    private final EntityManager em;

    public void save(UsageStatsEntity usageStatsEntity) {
        em.persist(usageStatsEntity);
    }

    //특정 사용자의 특정 시간 사용 내역 조회
    public List<UsageStatsEntity> findByUserId(String id, String nowTimeStamp) {
        //파라미터 바인딩 name으로, 조회 타입
        return em.createQuery("select m from UsageStatsEntity m where m.id = :id and m.nowTimeStamp = :nowTimeStamp", UsageStatsEntity.class)
                .setParameter("id", id)
                .setParameter("nowTimeStamp", nowTimeStamp)
                .getResultList();
    }
}
