package com.example.sGreenTime.controller;

import com.example.sGreenTime.dto.MemberDTO;
import com.example.sGreenTime.entity.MyPlaceEntity;
import com.example.sGreenTime.service.MapService;
import com.example.sGreenTime.service.MyPlaceService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
public class MapController {

    private final MapService mapService;
    private final MyPlaceService myPlaceService;
    private final ObjectMapper objectMapper;

    @PostMapping("/coordinates")
    public String receiveGPS(@RequestBody String json, Model model) {
        JSONObject jsonObject = new JSONObject(json);
        String nowLatitude = jsonObject.getString("nowLatitude");
        String nowLongitude = jsonObject.getString("nowLongitude");
        model.addAttribute("nowLatitude", nowLatitude);
        model.addAttribute("nowLongitude", nowLongitude);
        return "hello";
    }

    @GetMapping("/vworldData/{id}")
    public ModelAndView vworldData(@PathVariable("id") String id) throws JSONException, JsonProcessingException {
        List<MyPlaceEntity> myPlaceEntityList = myPlaceService.findMyPlaceById(id);

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("hello");

        modelAndView.addObject("userId", id);

        modelAndView.addObject("myPlaceEntityListSize", myPlaceEntityList.size());
        for (int j = 0; j < myPlaceEntityList.size(); j++) {
            String myPlaceJson = objectMapper.writeValueAsString(myPlaceEntityList.get(j));
            modelAndView.addObject("myPlaceData" + j, myPlaceJson);
        }

        String trailApiUrl1;
        String hikingApiUrl1;
        String park1ApiUrl1;
        String park2ApiUrl1;
        String park3ApiUrl1;

        //124,34,132,43
        trailApiUrl1 = "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_L_TRKROAD&key=D24E3DA9-245A-3E4A-A680-6A704EA8A93A&size=1000&geomfilter=BOX(124,36,128,41)";
        hikingApiUrl1 = "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_L_FRSTCLIMB&key=D24E3DA9-245A-3E4A-A680-6A704EA8A93A&size=1000&geomfilter=BOX(126.9,37.45,127,37.55)";
        park1ApiUrl1 = "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_C_WGISNPGUG&key=D24E3DA9-245A-3E4A-A680-6A704EA8A93A&size=1000&geomfilter=BOX(124,37,132,42)";
        park2ApiUrl1 = "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_C_WGISNPGUN&key=D24E3DA9-245A-3E4A-A680-6A704EA8A93A&size=1000&geomfilter=BOX(124,37,132,42)";
        park3ApiUrl1 = "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_C_WGISNPDO&key=D24E3DA9-245A-3E4A-A680-6A704EA8A93A&size=1000&geomfilter=BOX(124,37,132,42)";


        //산책로 처리
        /*
        String responseData1 = mapService.getDataFromExternalAPI(trailApiUrl1);
        //System.out.println(responseData);
        JSONObject jsonObject1 = new JSONObject(responseData1);
        Integer trailTotalPagesNum=0;

        try {
            //페이지 수 가져오기
            JSONObject pageObject1 = jsonObject1.getJSONObject("response").getJSONObject("page");
            trailTotalPagesNum = Integer.parseInt(pageObject1.getString("total"));
            System.out.println("Total Pages: " + trailTotalPagesNum);
            modelAndView.addObject("trailTotalPagesNum", trailTotalPagesNum);
        }
        catch (JSONException e){
            e.printStackTrace();
        }

        String trailApiBaseUrl1 = "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_L_TRKROAD&size=1000&page=";
        String trailApiBaseUrl2 = "&key=D24E3DA9-245A-3E4A-A680-6A704EA8A93A&geomfilter=BOX(124,36,128,41)";

        //반복문 통해 모든 산책로 불러오기
        for (int j = 1; j <= trailTotalPagesNum; j++) {
            String trailApiUrl = trailApiBaseUrl1 + j + trailApiBaseUrl2;
            String responseData = mapService.getDataFromExternalAPI(trailApiUrl);
         */
        String responseData = mapService.getDataFromExternalAPI(trailApiUrl1);

        //System.out.println(j+"th"+responseData);
        JSONObject jsonObject = new JSONObject(responseData);
        JSONObject response = jsonObject.getJSONObject("response");
        JSONObject result = response.getJSONObject("result");
        JSONObject featureCollection = result.getJSONObject("featureCollection");

        JSONArray features = featureCollection.getJSONArray("features");

        //modelAndView.addObject("trailData" + j, features);
        modelAndView.addObject("trailData", features);




        //등산로 처리
        /*
        String hikingResponseData1 = mapService.getDataFromExternalAPI(hikingApiUrl1);
        //System.out.println(hikingResponseData1);
        JSONObject hikingJsonObject1 = new JSONObject(hikingResponseData1);

        //페이지 수 가져오기
        JSONObject hikingPageObject1 = hikingJsonObject1.getJSONObject("response").getJSONObject("page");
        Integer hikingTotalPagesNum = Integer.parseInt(hikingPageObject1.getString("total"));
        System.out.println("Total Pages: " + hikingTotalPagesNum);
        modelAndView.addObject("hikingTotalPagesNum", hikingTotalPagesNum);


        String hikingApiBaseUrl1 = "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_L_FRSTCLIMB&size=1000&page=";
        String hikingApiBaseUrl2 = "&key=D24E3DA9-245A-3E4A-A680-6A704EA8A93A&geomfilter=BOX(126.9,37.45,127,37.55)";

        //반복문 통해 모든 등산로 불러오기
        for (int j = 1; j <= hikingTotalPagesNum; j++) {
            String hikingApiUrl = hikingApiBaseUrl1 + j + hikingApiBaseUrl2;
        */
        responseData = mapService.getDataFromExternalAPI(hikingApiUrl1);
        //System.out.println(j+"th"+responseData);
        jsonObject = new JSONObject(responseData);
        response = jsonObject.getJSONObject("response");
        result = response.getJSONObject("result");
        featureCollection = result.getJSONObject("featureCollection");

        features = featureCollection.getJSONArray("features");

        modelAndView.addObject("hikingData", features);



        //공원1 처리
        /*
        String park1ResponseData1 = mapService.getDataFromExternalAPI(park1ApiUrl1);
        JSONObject park1JsonObject1 = new JSONObject(park1ResponseData1);

        //페이지 수 가져오기
        JSONObject park1PageObject1 = park1JsonObject1.getJSONObject("response").getJSONObject("page");
        Integer park1TotalPagesNum = Integer.parseInt(park1PageObject1.getString("total"));
        System.out.println("Total Pages: " + park1TotalPagesNum);
        modelAndView.addObject("park1TotalPagesNum", park1TotalPagesNum);


        String park1ApiBaseUrl1 = "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_C_WGISNPGUG&size=1000&page=";
        String park1ApiBaseUrl2 = "&key=D24E3DA9-245A-3E4A-A680-6A704EA8A93A&geomfilter=BOX(124,37,132,42)";

        //반복문 통해 모든 공원1 불러오기
        for (int j = 1; j <= park1TotalPagesNum; j++) {
            String park1ApiUrl = park1ApiBaseUrl1 + j + park1ApiBaseUrl2;
         */
        responseData = mapService.getDataFromExternalAPI(park1ApiUrl1);
        //System.out.println(j+"th"+responseData);
        jsonObject = new JSONObject(responseData);
        response = jsonObject.getJSONObject("response");
        result = response.getJSONObject("result");
        featureCollection = result.getJSONObject("featureCollection");

        features = featureCollection.getJSONArray("features");

        modelAndView.addObject("park1Data", features);


        //공원2 처리
        /*
        String park2ResponseData1 = mapService.getDataFromExternalAPI(park2ApiUrl1);
        JSONObject park2JsonObject1 = new JSONObject(park2ResponseData1);

        //페이지 수 가져오기
        JSONObject park2PageObject1 = park2JsonObject1.getJSONObject("response").getJSONObject("page");
        Integer park2TotalPagesNum = Integer.parseInt(park2PageObject1.getString("total"));
        System.out.println("Total Pages: " + park2TotalPagesNum);
        modelAndView.addObject("park2TotalPagesNum", park2TotalPagesNum);


        String park2ApiBaseUrl1 = "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_C_WGISNPGUN&size=1000&page=";
        String park2ApiBaseUrl2 = "&key=D24E3DA9-245A-3E4A-A680-6A704EA8A93A&geomfilter=BOX(124,37,132,42)";

        //반복문 통해 모든 공원2 불러오기
        for (int j = 1; j <= park2TotalPagesNum; j++) {
            String park2ApiUrl = park2ApiBaseUrl1 + j + park2ApiBaseUrl2;
        */
        responseData = mapService.getDataFromExternalAPI(park2ApiUrl1);
        //System.out.println(j+"th"+responseData);
        jsonObject = new JSONObject(responseData);
        response = jsonObject.getJSONObject("response");
        result = response.getJSONObject("result");
        featureCollection = result.getJSONObject("featureCollection");

        features = featureCollection.getJSONArray("features");

        modelAndView.addObject("park2Data", features);



        //공원3 처리
        /*
        String park3ResponseData1 = mapService.getDataFromExternalAPI(park3ApiUrl1);
        JSONObject park3JsonObject1 = new JSONObject(park3ResponseData1);

        //페이지 수 가져오기
        JSONObject park3PageObject1 = park3JsonObject1.getJSONObject("response").getJSONObject("page");
        Integer park3TotalPagesNum = Integer.parseInt(park3PageObject1.getString("total"));
        System.out.println("Total Pages: " + park3TotalPagesNum);
        modelAndView.addObject("park3TotalPagesNum", park3TotalPagesNum);


        String park3ApiBaseUrl1 = "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_C_WGISNPDO&size=1000&page=";
        String park3ApiBaseUrl2 = "&key=D24E3DA9-245A-3E4A-A680-6A704EA8A93A&geomfilter=BOX(124,37,132,42)";

        //반복문 통해 모든 공원3 불러오기
        for (int j = 1; j <= park3TotalPagesNum; j++) {
            String park3ApiUrl = park3ApiBaseUrl1 + j + park3ApiBaseUrl2;
         */
        responseData = mapService.getDataFromExternalAPI(park3ApiUrl1);
        //System.out.println(j+"th"+responseData);
        jsonObject = new JSONObject(responseData);
        response = jsonObject.getJSONObject("response");
        result = response.getJSONObject("result");
        featureCollection = result.getJSONObject("featureCollection");

        features = featureCollection.getJSONArray("features");

        modelAndView.addObject("park3Data", features);


        return modelAndView;
    }

}
