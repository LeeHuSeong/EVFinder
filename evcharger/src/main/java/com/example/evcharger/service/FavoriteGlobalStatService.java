package com.example.evcharger.service;

import com.google.cloud.firestore.Firestore;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class FavoriteGlobalStatService {

    @Autowired
    private Firestore firestore;

    @Autowired
    private FindEvChargerService findEvChargerService;

    public List<Map<String, Object>> getUpdatedFavorites(String userId, double userLat, double userLng) throws Exception {
    List<Map<String, Object>> updatedFavorites = new ArrayList<>();

    var collection = firestore.collection("users").document(userId).collection("favorites");
    var docs = collection.get().get().getDocuments();

    for (var doc : docs) {
        Map<String, Object> favoriteData = doc.getData() != null ? new HashMap<>(doc.getData()) : new HashMap<>();
        String statId = doc.getId();
        favoriteData.put("statId", statId);

        Object latObj = favoriteData.get("lat");
        Object lngObj = favoriteData.get("lng");

        if (latObj == null || lngObj == null) {
            favoriteData.put("stat", -1);
            updatedFavorites.add(favoriteData);
            continue;
        }

        double chargerLat = Double.parseDouble(latObj.toString());
        double chargerLng = Double.parseDouble(lngObj.toString());

        // 👉 여기서 사용자의 위치를 기준으로 거리 계산
        double distance = calculateDistance(userLat, userLng, chargerLat, chargerLng);
        favoriteData.put("distance", distance);

        // 📌 기존대로 상태 및 주소도 갱신
        List<Map<String, Object>> nearby = findEvChargerService.getChargersBySidoCode(
            getSidoCodeFromFirestore(favoriteData),
            chargerLat, chargerLng
        );

        Optional<Map<String, Object>> matched = nearby.stream()
            .filter(c -> statId.equals(c.get("statId")))
            .findFirst();

        if (matched.isPresent()) {
            Map<String, Object> charger = matched.get();
            favoriteData.put("stat", charger.get("stat"));
            favoriteData.put("name", charger.get("name"));
            favoriteData.put("addr", charger.get("addr"));
        } else {
            favoriteData.put("stat", -1);
        }

        updatedFavorites.add(favoriteData);
    }

    return updatedFavorites.stream()
            .sorted(Comparator.comparingDouble(f -> (Double) f.get("distance")))
            .limit(30)
            .toList();
}

    // Firestore에 저장된 sidoCode가 없다면 기본값 반환
    private String getSidoCodeFromFirestore(Map<String, Object> favoriteData) {
        Object sidoCode = favoriteData.get("sidoCode");
        return sidoCode != null ? sidoCode.toString() : "11"; // default: 서울
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
