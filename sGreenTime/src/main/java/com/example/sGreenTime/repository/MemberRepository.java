package com.example.sGreenTime.repository;

import com.example.sGreenTime.entity.MemberEntity;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;


@Repository
@RequiredArgsConstructor
public class MemberRepository {
    //entity 매니저 주입받기
    //@PersistenceContext
    private final EntityManager em;

    //영속성 컨텍스트에 member 넣음
    public void save(MemberEntity memberEntity){
        em.persist(memberEntity);
    }

}
