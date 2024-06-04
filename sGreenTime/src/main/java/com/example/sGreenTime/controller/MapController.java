package com.example.sGreenTime.controller;

import com.example.sGreenTime.entity.MyPlaceEntity;
import com.example.sGreenTime.service.MapService;
import com.example.sGreenTime.service.MyPlaceService;
import com.example.sGreenTime.service.VisitedService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
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
    private final VisitedService visitedService;
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

        //visitedTrailLnkNamList MapController로 가져오기
        List<String> visitedTrailLnkNamList = visitedService.getVisitedTrailLnkNam(id);
        modelAndView.addObject("visitedTrailLnkNamList", visitedTrailLnkNamList);

        //visitedHikingMntnNmList
        List<String> visitedHikingMntnNmList = visitedService.getVisitedHikingMntnNm(id);
        modelAndView.addObject("visitedHikingMntnNmList", visitedHikingMntnNmList);

        //visitedParkNameList
        List<String> visitedParkNameList = visitedService.getVisitedParkName(id);
        modelAndView.addObject("visitedParkNameList", visitedParkNameList);

        String trailApiUrl1;
        String hikingApiUrl1;
        String park1ApiUrl1;
        String park2ApiUrl1;
        String park3ApiUrl1;

        //124,34,132,43
        trailApiUrl1 = "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_L_TRKROAD&key=D24E3DA9-245A-3E4A-A680-6A704EA8A93A&size=1000&geomfilter=BOX(125,37,128,40)";
        hikingApiUrl1 = "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_L_FRSTCLIMB&key=D24E3DA9-245A-3E4A-A680-6A704EA8A93A&size=1000&geomfilter=BOX(126.8,37.4,127.1,37.6)";
        park1ApiUrl1 = "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_C_WGISNPGUG&key=D24E3DA9-245A-3E4A-A680-6A704EA8A93A&size=1000&geomfilter=BOX(125,37,128,40)";
        park2ApiUrl1 = "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_C_WGISNPGUN&key=D24E3DA9-245A-3E4A-A680-6A704EA8A93A&size=1000&geomfilter=BOX(125,37,128,40)";
        park3ApiUrl1 = "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_C_WGISNPDO&key=D24E3DA9-245A-3E4A-A680-6A704EA8A93A&size=1000&geomfilter=BOX(125,37,128,40)";


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

        JSONObject jsonObject = new JSONObject(responseData);
        JSONObject response = jsonObject.getJSONObject("response");
        JSONObject result = response.getJSONObject("result");
        JSONObject featureCollection = result.getJSONObject("featureCollection");
        JSONArray features = featureCollection.getJSONArray("features");

        //modelAndView.addObject("trailData" + j, features);
        modelAndView.addObject("trailData", features);



        //등산로 처리
        responseData = mapService.getDataFromExternalAPI(hikingApiUrl1);

        jsonObject = new JSONObject(responseData);
        response = jsonObject.getJSONObject("response");
        result = response.getJSONObject("result");
        featureCollection = result.getJSONObject("featureCollection");
        features = featureCollection.getJSONArray("features");

        modelAndView.addObject("hikingData", features);



        //공원1 처리
        responseData = mapService.getDataFromExternalAPI(park1ApiUrl1);

        jsonObject = new JSONObject(responseData);
        response = jsonObject.getJSONObject("response");
        result = response.getJSONObject("result");
        featureCollection = result.getJSONObject("featureCollection");
        features = featureCollection.getJSONArray("features");

        modelAndView.addObject("park1Data", features);



        //공원2 처리
        responseData = mapService.getDataFromExternalAPI(park2ApiUrl1);

        jsonObject = new JSONObject(responseData);
        response = jsonObject.getJSONObject("response");
        result = response.getJSONObject("result");
        featureCollection = result.getJSONObject("featureCollection");
        features = featureCollection.getJSONArray("features");

        modelAndView.addObject("park2Data", features);



        //공원3 처리
        responseData = mapService.getDataFromExternalAPI(park3ApiUrl1);
        jsonObject = new JSONObject(responseData);
        response = jsonObject.getJSONObject("response");
        result = response.getJSONObject("result");
        featureCollection = result.getJSONObject("featureCollection");
        features = featureCollection.getJSONArray("features");

        modelAndView.addObject("park3Data", features);



        return modelAndView;
    }

}
