package com.example.sGreenTime.controller;

import com.example.sGreenTime.dto.MemberDTO;
import com.example.sGreenTime.entity.CarbonInObjEntity;
import com.example.sGreenTime.service.CarbonInObjService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
public class CarbonInObjController {
    public final CarbonInObjService carbonInObjService;

    @PostMapping("/carbonInObj")
    public CarbonInObjEntity send(@RequestBody MemberDTO memberDTO){
        return carbonInObjService.find(memberDTO);
    }
}
