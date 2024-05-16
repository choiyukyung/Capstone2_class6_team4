package com.example.sGreenTime.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
@Slf4j
public class MapService {
    private final RestTemplate restTemplate;

    @Autowired
    public MapService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    public String getDataFromExternalAPI(String apiUrl) {
        return restTemplate.getForObject(apiUrl, String.class);
    }
}
