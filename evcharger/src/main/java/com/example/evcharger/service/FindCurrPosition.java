package com.example.evcharger.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class FindCurrPosition {

    @Value("${kakao.api-key}")
    private String kapikey;

    public Map<String, Object> getAddr(double lat, double lng) throws Exception {
        String apiUrl = "https://dapi.kakao.com/v2/local/geo/coord2address.json?"
        +"x="+lng+"&"
        +"y="+lat+"&"
        +"input_coord=WGS84";

        HttpURLConnection conn = (HttpURLConnection) new URL(apiUrl).openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Authorization", "KakaoAK " + kapikey);
        conn.setRequestProperty("Accept", "application/json");

        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        StringBuilder response = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            response.append(line);
        }
        br.close();

        ObjectMapper mapper = new ObjectMapper();
        Map<String, Object> fullJson = mapper.readValue(response.toString(), Map.class);

        List<Map<String, Object>> documents = (List<Map<String, Object>>) fullJson.get("documents");

        if (documents != null && !documents.isEmpty()) {
            Map<String, Object> first = documents.get(0);

            Map<String, Object> result = new HashMap<>();

            result.put("address_name", first.get("address"));

            return result;
        } else {
            throw new Exception("위치 정보를 찾을 수 없습니다.");
        }
    }
}
