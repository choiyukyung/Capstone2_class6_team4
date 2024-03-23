package com.example.sGreenTime.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@ToString
public class MemberDTO {
    private int userId; //pk
    private String id;
    private String password;
    private String name;
    private String birthdate;
}
