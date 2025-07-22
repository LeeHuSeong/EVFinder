package com.example.evcharger.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.*;

@Service
public class FindEvChargerService {

    @Value("${evcharger.api-key}")
    private String apiKey;

    public List<Map<String, Object>> getChargersBySidoCode(String sidoCode, double myLat, double myLng) throws Exception {
        String urlStr = "https://apis.data.go.kr/B552584/EvCharger/getChargerInfo?" +
                "serviceKey=" + apiKey +
                "&pageNo=1&numOfRows=100&zcode=" + sidoCode +
                "&dataType=JSON";

        HttpURLConnection conn = (HttpURLConnection) new URL(urlStr).openConnection();
        conn.setRequestMethod("GET");

        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            sb.append(line);
        }
        br.close();

        ObjectMapper mapper = new ObjectMapper();
        Map<String, Object> fullJson = mapper.readValue(sb.toString(), Map.class);
        Map<String, Object> response = (Map<String, Object>) fullJson.get("items");

        List<Map<String, Object>> items = (List<Map<String, Object>>) response.get("item");
        List<Map<String, Object>> filtered = new ArrayList<>();

        for (Map<String, Object> item : items) {
            try {
                double lat = Double.parseDouble((String) item.get("lat"));
                double lng = Double.parseDouble((String) item.get("lng"));
                double distance = calculateDistance(myLat, myLng, lat, lng);

                Map<String, Object> data = new HashMap<>();
                data.put("addr", item.get("addr"));
                data.put("busiNm", item.get("busiNm"));
                data.put("chgerType", item.get("chgerType"));
                data.put("lat", lat);
                data.put("lng", lng);
                data.put("method", item.get("method"));
                data.put("name", item.get("statNm"));
                data.put("output", item.get("output"));
                data.put("statId", item.get("statId"));
                data.put("useTime", item.get("useTime"));
                data.put("stat", item.get("stat"));
                data.put("distance", distance);

                filtered.add(data);
            } catch (Exception ignored) {}
        }

        return filtered.stream()
                .sorted(Comparator.comparingDouble(c -> (Double) c.get("distance")))
                .limit(30)
                .toList();

}
 
    public int getStatByStatId(String statId) {
    try {
        // 기본 서울 기준, 전역 탐색 안 하도록 일부 반경 내만 조회
        String defaultSidoCode = "11";
        double defaultLat = 37.5665;
        double defaultLng = 126.9780;

        List<Map<String, Object>> chargers = getChargersBySidoCode(defaultSidoCode, defaultLat, defaultLng);

        for (Map<String, Object> charger : chargers) {
            Object id = charger.get("statId");
            if (id != null && statId.equals(id.toString())) {
                Object stat = charger.get("stat");
                if (stat instanceof Integer) return (int) stat;
                if (stat instanceof String) return Integer.parseInt((String) stat);
                throw new RuntimeException("알 수 없는 stat 형식: " + stat.getClass());
            }
        }

        throw new RuntimeException("statId에 해당하는 충전소를 찾을 수 없습니다: " + statId);

    } catch (Exception e) {
        System.err.println("[ERROR] getStatByStatId 실패: " + e.getMessage());
        throw new RuntimeException("충전소 상태 조회 실패", e);
    }
}

    private double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
        final int R = 6371;
        double dLat = Math.toRadians(lat2 - lat1);
        double dLng = Math.toRadians(lng2 - lng1);

        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                 + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                 * Math.sin(dLng / 2) * Math.sin(dLng / 2);

        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }
} 
