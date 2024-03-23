package com.example.sGreenTime.service;

import com.example.sGreenTime.dto.MemberDTO;
import com.example.sGreenTime.entity.MemberEntity;
import com.example.sGreenTime.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class MemberService {
    private final MemberRepository memberRepository;

    //회원가입
    @Transactional
    public void join(MemberDTO memberDTO){
        //validateDuplicateMember(memberEntity);
        MemberEntity memberEntity = MemberEntity.toMemberEntity(memberDTO);
        memberRepository.save(memberEntity);
    }


}
