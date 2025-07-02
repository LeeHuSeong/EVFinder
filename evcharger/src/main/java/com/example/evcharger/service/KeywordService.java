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
public class KeywordService {

    @Value("${kakao.api-key}")
    private String kapikey;

    public Map<String, Object> getCoordinatesByKeyword(String query) throws Exception {
        String apiUrl = "https://dapi.kakao.com/v2/local/search/keyword.json?query="
                + URLEncoder.encode(query, "UTF-8");

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
            result.put("place_name", first.get("place_name"));
            result.put("address_name", first.get("address_name"));
            result.put("road_address_name", first.get("road_address_name"));
            result.put("x", first.get("x"));
            result.put("y", first.get("y"));
            return result;
        } else {
            throw new Exception("위치 정보를 찾을 수 없습니다.");
        }
    }
    public List<Map<String, Object>> getPlaceListByKeyword(String query) throws Exception {
        String apiUrl = "https://dapi.kakao.com/v2/local/search/keyword.json?query="
                + URLEncoder.encode(query, "UTF-8");

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
            List<Map<String, Object>> results = new ArrayList<>();
            int limit = Math.min(10, documents.size()); // 그 키워드에 해당하는 장소가 10개가 미만이라면 전부 출력해주면 되니까

            for (int i = 0; i < limit; i++) {
                Map<String, Object> doc = documents.get(i);
                Map<String, Object> place = new HashMap<>();
                place.put("place_name", doc.get("place_name"));
                place.put("address_name", doc.get("address_name"));
                place.put("road_address_name", doc.get("road_address_name"));
                place.put("x", doc.get("x"));
                place.put("y", doc.get("y"));
                results.add(place);
            }

            return results;
        } else {
            throw new Exception("위치 정보를 찾을 수 없습니다.");
        }
    }

}
