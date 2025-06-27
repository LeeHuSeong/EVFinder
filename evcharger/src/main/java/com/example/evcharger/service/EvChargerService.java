package com.example.evcharger.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.*;

@Service
public class EvChargerService {

    @Value("${naver.client-id}")
    private String clientId;

    @Value("${naver.client-secret}")
    private String clientSecret;

    public Map<String, Object> getCoordinates(String query) throws Exception {
        String apiUrl = "https://maps.apigw.ntruss.com/map-geocode/v2/geocode?query="
                + URLEncoder.encode(query, "UTF-8");

        HttpURLConnection conn = (HttpURLConnection) new URL(apiUrl).openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("X-NCP-APIGW-API-KEY-ID", clientId);
        conn.setRequestProperty("X-NCP-APIGW-API-KEY", clientSecret);
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
        List<Map<String, Object>> addresses = (List<Map<String, Object>>) fullJson.get("addresses");

        if (addresses != null && !addresses.isEmpty()) {
            Map<String, Object> result = new HashMap<>();
            result.put("x", addresses.get(0).get("x"));
            result.put("y", addresses.get(0).get("y"));
            result.put("roadAddress", addresses.get(0).get("roadAddress"));
            return result;
        } else {
            throw new Exception("위치 정보를 찾을 수 없습니다.");
        }
    }

    public String getSidoCodeFromCoordinates(double lat, double lng) throws Exception {
        String apiUrl = "https://maps.apigw.ntruss.com/map-reversegeocode/v2/gc"
                + "?request=coordsToaddr"
                + "&coords=" + lng + "," + lat
                + "&sourcecrs=epsg:4326"
                + "&orders=admcode"
                + "&output=json";

        HttpURLConnection conn = (HttpURLConnection) new URL(apiUrl).openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("X-NCP-APIGW-API-KEY-ID", clientId);
        conn.setRequestProperty("X-NCP-APIGW-API-KEY", clientSecret);
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
        List<Map<String, Object>> results = (List<Map<String, Object>>) fullJson.get("results");

        if (results != null && !results.isEmpty()) {
            Map<String, Object> codeMap = (Map<String, Object>) results.get(0).get("code");
            if (codeMap != null) {
                String fullCode = (String) codeMap.get("id");
                if (fullCode != null && fullCode.length() >= 2) {
                    return fullCode.substring(0, 2);
                }
            }
        }
        throw new Exception("시도 코드를 찾을 수 없습니다.");
    }
}
