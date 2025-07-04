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

    public List<Map<String, Object>> getUpdatedFavorites(String userId) throws Exception {
        List<Map<String, Object>> updatedFavorites = new ArrayList<>();

        // 1. Firestore 즐겨찾기 문서 가져오기
        var collection = firestore.collection("users").document(userId).collection("favorites");
        var docs = collection.get().get().getDocuments();

        for (var doc : docs) {
            Map<String, Object> favoriteData = doc.getData() != null ? new HashMap<>(doc.getData()) : new HashMap<>();
            String statId = doc.getId(); // 문서 ID = statId

            favoriteData.put("statId", statId);

            // 2. 좌표 기반으로 주변 충전소 검색
            Object latObj = favoriteData.get("lat");
            Object lngObj = favoriteData.get("lng");

            if (latObj == null || lngObj == null) {
                favoriteData.put("stat", -1); // 좌표 없음
                updatedFavorites.add(favoriteData);
                continue;
            }

            double lat = Double.parseDouble(latObj.toString());
            double lng = Double.parseDouble(lngObj.toString());

            List<Map<String, Object>> nearby = findEvChargerService.getChargersBySidoCode(
                    getSidoCodeFromFirestore(favoriteData),
                    lat, lng
            );

            // 3. statId 일치하는 충전소 찾기
            Optional<Map<String, Object>> matched = nearby.stream()
                    .filter(c -> statId.equals(c.get("statId")))
                    .findFirst();

            if (matched.isPresent()) {
                Map<String, Object> charger = matched.get();
                favoriteData.put("stat", charger.get("stat"));
                favoriteData.put("name", charger.get("name"));
                favoriteData.put("addr", charger.get("addr"));
                favoriteData.put("distance", charger.get("distance"));
            } else {
                favoriteData.put("stat", -1); // 못 찾으면 -1
            }

            updatedFavorites.add(favoriteData);
        }

        return updatedFavorites;
    }

    // Firestore에 저장된 sidoCode가 없다면 기본값 반환
    private String getSidoCodeFromFirestore(Map<String, Object> favoriteData) {
        Object sidoCode = favoriteData.get("sidoCode");
        return sidoCode != null ? sidoCode.toString() : "11"; // default: 서울
    }
}
