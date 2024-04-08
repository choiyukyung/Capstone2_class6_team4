package com.example.sGreenTime.repository;

import com.example.sGreenTime.entity.MemberEntity;
import com.example.sGreenTime.entity.UsageStatsEntity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class UsageStatsRepository {
    @PersistenceContext
    private final EntityManager em;
    public void save(UsageStatsEntity usageStatsEntity){
        em.persist(usageStatsEntity);
    }

    //특정 사용자의 사용 내역 조회
    //where절?
    public List<UsageStatsEntity> findByUserId(String id){
        //파라미터 바인딩 name으로, 조회 타입
        return em.createQuery("select m from UsageStatsEntity m where m.id = :id", UsageStatsEntity.class)
                .setParameter("id", id)
                .getResultList();
    }
}
