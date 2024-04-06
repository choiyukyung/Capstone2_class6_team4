package com.example.sGreenTime.repository;

import com.example.sGreenTime.entity.MemberEntity;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.Optional;


@Repository
@RequiredArgsConstructor
public class MemberRepository {
    //entity 매니저 주입받기
    @PersistenceContext
    private final EntityManager em;

    //영속성 컨텍스트에 member 넣음
    public void save(MemberEntity memberEntity){
        em.persist(memberEntity);
    }

    //아이디로 조회
    public Optional<MemberEntity> findByIdString(String id){
        //파라미터 바인딩 id로, 조회 타입
        return em.createQuery("select m from MemberEntity m where m.id = :id", MemberEntity.class)
                .setParameter("id", id)
                .getResultList()
                .stream()
                .findFirst();
    }

}
