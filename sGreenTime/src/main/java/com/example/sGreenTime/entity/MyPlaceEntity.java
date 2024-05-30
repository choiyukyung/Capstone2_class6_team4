package com.example.sGreenTime.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Setter
@Getter
@Table(name = "my_place_table")
public class MyPlaceEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "my_place_id")
    private int myPlaceId; //pk
    @Column
    private String id;
    @Column
    private String lnk_nam;
    @Column
    private String cos_nam;
    @Column
    private String cos_num;
    @Column
    private String comment;
    @Column
    private String len_tim;
    @Column
    private String leng_lnk;
    @Column
    private String cos_lvl;
    @Column
    private String cat_nam;
    //{"lnk_nam":"애국의숲길","cos_nam":"관악산둘레길","cos_num":"1코스","comment":"","len_tim":"←2시간30분 6.2Km→",
    // "leng_lnk":"6729.79251047","cos_lvl":"","cat_nam":"둘레길링크"}
    @Column
    private String coordinates;
}
