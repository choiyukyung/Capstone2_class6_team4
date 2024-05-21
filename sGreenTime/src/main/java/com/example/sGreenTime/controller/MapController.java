package com.example.sGreenTime.controller;

import com.example.sGreenTime.service.MapService;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

@RestController
public class MapController {

    private final MapService mapService;

    @Autowired
    public MapController(MapService mapService) {
        this.mapService = mapService;
    }


    @PostMapping("/coordinates")
    public String receiveGPS(@RequestBody String json, Model model) {
        JSONObject jsonObject = new JSONObject(json);
        String nowLatitude = jsonObject.getString("nowLatitude");
        String nowLongitude = jsonObject.getString("nowLongitude");
        model.addAttribute("nowLatitude", nowLatitude);
        model.addAttribute("nowLongitude", nowLongitude);
        return "hello";
    }

    @CrossOrigin
    @PostMapping("getMapSwNe")
    public ModelAndView mapCoordinates(@RequestParam("swLatLng") String swLatLng,
                                            @RequestParam("neLatLng") String neLatLng) {
        System.out.println("received: " + swLatLng + ", " + neLatLng);
        ModelAndView modelAndView = vworldData(swLatLng, neLatLng);
        System.out.println("********************************");
        return modelAndView;
    }

    @GetMapping("vworldData")
    public ModelAndView vworldData(@RequestParam(required = false) String swLatLng,
                                   @RequestParam(required = false) String neLatLng) throws JSONException {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("hello");

        String trailApiUrl1;
        String hikingApiUrl1;
        String park1ApiUrl1;
        String park2ApiUrl1;
        String park3ApiUrl1;

        trailApiUrl1 = "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_L_TRKROAD&key=D24E3DA9-245A-3E4A-A680-6A704EA8A93A&geomfilter=BOX(124,34,132,43)";
        hikingApiUrl1 = "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_L_FRSTCLIMB&key=D24E3DA9-245A-3E4A-A680-6A704EA8A93A&geomfilter=BOX(126.9,37.45,127,37.55)";
        park1ApiUrl1 = "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_C_WGISNPGUG&key=D24E3DA9-245A-3E4A-A680-6A704EA8A93A&geomfilter=BOX(124,34,132,43)";
        park2ApiUrl1 = "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_C_WGISNPGUN&key=D24E3DA9-245A-3E4A-A680-6A704EA8A93A&geomfilter=BOX(124,34,132,43)";
        park3ApiUrl1 = "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_C_WGISNPDO&key=D24E3DA9-245A-3E4A-A680-6A704EA8A93A&geomfilter=BOX(124,34,132,43)";

        //산책로 처리
        String responseData1 = mapService.getDataFromExternalAPI(trailApiUrl1);
        //System.out.println(responseData);
        JSONObject jsonObject1 = new JSONObject(responseData1);

        //페이지 수 가져오기
        JSONObject pageObject1 = jsonObject1.getJSONObject("response").getJSONObject("page");
        Integer trailTotalPagesNum = Integer.parseInt(pageObject1.getString("total"));
        System.out.println("Total Pages: " + trailTotalPagesNum);
        modelAndView.addObject("trailTotalPagesNum", trailTotalPagesNum);

        JSONObject response1 = jsonObject1.getJSONObject("response");
        JSONObject result1 = response1.getJSONObject("result");
        JSONObject featureCollection1 = result1.getJSONObject("featureCollection");
        //System.out.println(featureCollection);

        JSONArray features1 = featureCollection1.getJSONArray("features");

        for (int i = 0; i < features1.length(); i++) {
            JSONObject geometry = features1.getJSONObject(i).getJSONObject("geometry");
            //System.out.println(geometry);
        }
        modelAndView.addObject("trailData1", features1);

        String trailApiBaseUrl1 = "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_L_TRKROAD&page=";
        String trailApiBaseUrl2 = "&key=D24E3DA9-245A-3E4A-A680-6A704EA8A93A&geomfilter=BOX(124,34,132,43)";

        //반복문 통해 모든 산책로 불러오기
        for (int j = 2; j <= trailTotalPagesNum; j++) {
            String trailApiUrl = trailApiBaseUrl1 + j + trailApiBaseUrl2;
            String responseData = mapService.getDataFromExternalAPI(trailApiUrl);
            //System.out.println(j+"th"+responseData);
            JSONObject jsonObject = new JSONObject(responseData);
            JSONObject response = jsonObject.getJSONObject("response");
            JSONObject result = response.getJSONObject("result");
            JSONObject featureCollection = result.getJSONObject("featureCollection");

            JSONArray features = featureCollection.getJSONArray("features");

            for (int i = 0; i < features.length(); i++) {
                JSONObject geometry = features.getJSONObject(i).getJSONObject("geometry");
                //System.out.println(geometry);
            }
            modelAndView.addObject("trailData" + j, features);
        }

        //등산로 처리
        String hikingResponseData1 = mapService.getDataFromExternalAPI(hikingApiUrl1);
        //System.out.println(hikingResponseData1);
        JSONObject hikingJsonObject1 = new JSONObject(hikingResponseData1);

        //페이지 수 가져오기
        JSONObject hikingPageObject1 = hikingJsonObject1.getJSONObject("response").getJSONObject("page");
        Integer hikingTotalPagesNum = Integer.parseInt(hikingPageObject1.getString("total"));
        System.out.println("Total Pages: " + hikingTotalPagesNum);
        modelAndView.addObject("hikingTotalPagesNum", hikingTotalPagesNum);

        JSONObject hikingResponse1 = hikingJsonObject1.getJSONObject("response");
        JSONObject hikingResult1 = hikingResponse1.getJSONObject("result");
        JSONObject hikingFeatureCollection1 = hikingResult1.getJSONObject("featureCollection");
        //System.out.println("hiking"+hikingFeatureCollection1);

        JSONArray hikingFeatures1 = hikingFeatureCollection1.getJSONArray("features");

        for (int i = 0; i < hikingFeatures1.length(); i++) {
            JSONObject hikingGeometry1 = hikingFeatures1.getJSONObject(i).getJSONObject("geometry");
            //System.out.println(hikingGeometry1);
        }
        modelAndView.addObject("hikingData1", hikingFeatures1);

        String hikingApiBaseUrl1 = "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_L_FRSTCLIMB&page=";
        String hikingApiBaseUrl2 = "&key=D24E3DA9-245A-3E4A-A680-6A704EA8A93A&geomfilter=BOX(126.9,37.45,127,37.55)";

        //반복문 통해 모든 등산로 불러오기
        for (int j = 2; j <= hikingTotalPagesNum; j++) {
            String hikingApiUrl = hikingApiBaseUrl1 + j + hikingApiBaseUrl2;
            String responseData = mapService.getDataFromExternalAPI(hikingApiUrl);
            //System.out.println(j+"th"+responseData);
            JSONObject jsonObject = new JSONObject(responseData);
            JSONObject response = jsonObject.getJSONObject("response");
            JSONObject result = response.getJSONObject("result");
            JSONObject featureCollection = result.getJSONObject("featureCollection");

            JSONArray features = featureCollection.getJSONArray("features");

            for (int i = 0; i < features.length(); i++) {
                JSONObject geometry = features.getJSONObject(i).getJSONObject("geometry");
                //System.out.println(geometry);
            }
            modelAndView.addObject("hikingData" + j, features);
        }



        //공원1 처리
        String park1ResponseData1 = mapService.getDataFromExternalAPI(park1ApiUrl1);
        JSONObject park1JsonObject1 = new JSONObject(park1ResponseData1);

        //페이지 수 가져오기
        JSONObject park1PageObject1 = park1JsonObject1.getJSONObject("response").getJSONObject("page");
        Integer park1TotalPagesNum = Integer.parseInt(park1PageObject1.getString("total"));
        System.out.println("Total Pages: " + park1TotalPagesNum);
        modelAndView.addObject("park1TotalPagesNum", park1TotalPagesNum);

        JSONObject park1Response1 = park1JsonObject1.getJSONObject("response");
        JSONObject park1Result1 = park1Response1.getJSONObject("result");
        JSONObject park1FeatureCollection1 = park1Result1.getJSONObject("featureCollection");
        //System.out.println("park1"+park1FeatureCollection1);

        JSONArray park1Features1 = park1FeatureCollection1.getJSONArray("features");

        for (int i = 0; i < park1Features1.length(); i++) {
            JSONObject park1Geometry1 = park1Features1.getJSONObject(i).getJSONObject("geometry");
            //System.out.println(park1Geometry1);
        }
        modelAndView.addObject("park1Data1", park1Features1);

        String park1ApiBaseUrl1 = "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_C_WGISNPGUG&page=";
        String park1ApiBaseUrl2 = "&key=D24E3DA9-245A-3E4A-A680-6A704EA8A93A&geomfilter=BOX(124,34,132,43)";

        //반복문 통해 모든 공원1 불러오기
        for (int j = 2; j <= park1TotalPagesNum; j++) {
            String park1ApiUrl = park1ApiBaseUrl1 + j + park1ApiBaseUrl2;
            String responseData = mapService.getDataFromExternalAPI(park1ApiUrl);
            //System.out.println(j+"th"+responseData);
            JSONObject jsonObject = new JSONObject(responseData);
            JSONObject response = jsonObject.getJSONObject("response");
            JSONObject result = response.getJSONObject("result");
            JSONObject featureCollection = result.getJSONObject("featureCollection");

            JSONArray features = featureCollection.getJSONArray("features");

            for (int i = 0; i < features.length(); i++) {
                JSONObject geometry = features.getJSONObject(i).getJSONObject("geometry");
                //System.out.println(geometry);
            }
            modelAndView.addObject("park1Data" + j, features);
        }

        //공원2 처리
        String park2ResponseData1 = mapService.getDataFromExternalAPI(park2ApiUrl1);
        JSONObject park2JsonObject1 = new JSONObject(park2ResponseData1);

        //페이지 수 가져오기
        JSONObject park2PageObject1 = park2JsonObject1.getJSONObject("response").getJSONObject("page");
        Integer park2TotalPagesNum = Integer.parseInt(park2PageObject1.getString("total"));
        System.out.println("Total Pages: " + park2TotalPagesNum);
        modelAndView.addObject("park2TotalPagesNum", park2TotalPagesNum);

        JSONObject park2Response1 = park2JsonObject1.getJSONObject("response");
        JSONObject park2Result1 = park2Response1.getJSONObject("result");
        JSONObject park2FeatureCollection1 = park2Result1.getJSONObject("featureCollection");
        //System.out.println("park"+parkFeature2Collection1);

        JSONArray park2Features1 = park2FeatureCollection1.getJSONArray("features");

        for (int i = 0; i < park2Features1.length(); i++) {
            JSONObject park2Geometry1 = park2Features1.getJSONObject(i).getJSONObject("geometry");
            //System.out.println(park2Geometry1);
        }
        modelAndView.addObject("park2Data1", park2Features1);

        String park2ApiBaseUrl1 = "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_C_WGISNPGUN&page=";
        String park2ApiBaseUrl2 = "&key=D24E3DA9-245A-3E4A-A680-6A704EA8A93A&geomfilter=BOX(124,34,132,43)";

        //반복문 통해 모든 공원2 불러오기
        for (int j = 2; j <= park2TotalPagesNum; j++) {
            String park2ApiUrl = park2ApiBaseUrl1 + j + park2ApiBaseUrl2;
            String responseData = mapService.getDataFromExternalAPI(park2ApiUrl);
            //System.out.println(j+"th"+responseData);
            JSONObject jsonObject = new JSONObject(responseData);
            JSONObject response = jsonObject.getJSONObject("response");
            JSONObject result = response.getJSONObject("result");
            JSONObject featureCollection = result.getJSONObject("featureCollection");

            JSONArray features = featureCollection.getJSONArray("features");

            for (int i = 0; i < features.length(); i++) {
                JSONObject geometry = features.getJSONObject(i).getJSONObject("geometry");
                //System.out.println(geometry);
            }
            modelAndView.addObject("park2Data" + j, features);
        }


        //공원3 처리
        String park3ResponseData1 = mapService.getDataFromExternalAPI(park3ApiUrl1);
        JSONObject park3JsonObject1 = new JSONObject(park3ResponseData1);

        //페이지 수 가져오기
        JSONObject park3PageObject1 = park3JsonObject1.getJSONObject("response").getJSONObject("page");
        Integer park3TotalPagesNum = Integer.parseInt(park3PageObject1.getString("total"));
        System.out.println("Total Pages: " + park3TotalPagesNum);
        modelAndView.addObject("park3TotalPagesNum", park3TotalPagesNum);

        JSONObject park3Response1 = park3JsonObject1.getJSONObject("response");
        JSONObject park3Result1 = park3Response1.getJSONObject("result");
        JSONObject park3FeatureCollection1 = park3Result1.getJSONObject("featureCollection");
        //System.out.println("park"+parkFeatureCollection3);

        JSONArray park3Features1 = park3FeatureCollection1.getJSONArray("features");

        for (int i = 0; i < park3Features1.length(); i++) {
            JSONObject parkGeometry3 = park3Features1.getJSONObject(i).getJSONObject("geometry");
            //System.out.println(parkGeometry3);
        }
        modelAndView.addObject("park3Data1", park3Features1);

        String park3ApiBaseUrl1 = "https://api.vworld.kr/req/data?service=data&request=GetFeature&data=LT_C_WGISNPDO&page=";
        String park3ApiBaseUrl2 = "&key=D24E3DA9-245A-3E4A-A680-6A704EA8A93A&geomfilter=BOX(124,34,132,43)";

        //반복문 통해 모든 공원2 불러오기
        for (int j = 2; j <= park3TotalPagesNum; j++) {
            String park3ApiUrl = park3ApiBaseUrl1 + j + park3ApiBaseUrl2;
            String responseData = mapService.getDataFromExternalAPI(park3ApiUrl);
            //System.out.println(j+"th"+responseData);
            JSONObject jsonObject = new JSONObject(responseData);
            JSONObject response = jsonObject.getJSONObject("response");
            JSONObject result = response.getJSONObject("result");
            JSONObject featureCollection = result.getJSONObject("featureCollection");

            JSONArray features = featureCollection.getJSONArray("features");

            for (int i = 0; i < features.length(); i++) {
                JSONObject geometry = features.getJSONObject(i).getJSONObject("geometry");
                //System.out.println(geometry);
            }
            modelAndView.addObject("park3Data" + j, features);
        }



        return modelAndView;
    }

}
