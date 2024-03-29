package com.example.sGreenTime.controller;

import com.example.sGreenTime.dto.MemberDTO;
import com.example.sGreenTime.service.MemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
public class MemberController {

    private final MemberService memberService;

    @PostMapping("/member/join")
    public MemberDTO join(@RequestBody MemberDTO memberDTO){
        memberService.join(memberDTO);
        return memberDTO;
    }

    @PostMapping("/member/login")
    public String login(@RequestBody MemberDTO memberDTO){
        String loginResult = memberService.login(memberDTO);
        if(loginResult != null){
            return "{\"message\" : \"success\"}";
        }
        else {
            return "{\"message\" : \"fail\"}";
        }
    }
}
