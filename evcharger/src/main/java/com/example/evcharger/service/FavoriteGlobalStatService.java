package com.example.evcharger.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.cloud.firestore.Firestore;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
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

        // 2. 공공 API 전체 충전소 목록 (stat 갱신용)
        List<Map<String, Object>> allChargers = findEvChargerService.getAllChargers();

        // 3. 문서 순회
        for (var doc : docs) {
            Map<String, Object> favoriteData = doc.getData(); // Firestore 저장된 정보
            String statId = (String) favoriteData.get("statId");

            // 4. 공공 API에서 동일 statId 찾아 stat 값만 갱신
            Optional<Map<String, Object>> matchedCharger = allChargers.stream()
                .filter(ch -> statId.equals(ch.get("statId")))
                .findFirst();

            if (matchedCharger.isPresent()) {
                Object newStat = matchedCharger.get().get("stat");
                favoriteData.put("stat", newStat); // 기존 데이터에 최신 stat 덮어쓰기
            } else {
                favoriteData.put("stat", -1); // 못 찾았을 경우 -1 (또는 null)
            }

            updatedFavorites.add(favoriteData);
        }

        return updatedFavorites;
    }

    // Firestore에서 사용자 즐겨찾기 statId 목록 가져오기
    private List<String> getUserFavoriteStatIds(String userId) throws Exception {
        List<String> statIds = new ArrayList<>();
        var collection = firestore.collection("users").document(userId).collection("favorites");
        var docs = collection.get().get().getDocuments();

        //디버깅용
        System.out.println("즐겨찾기 문서 수: " + docs.size());

        for (var doc : docs) {
            System.out.println("즐겨찾기 statId: " + doc.getId());
            statIds.add(doc.getId()); // 문서 ID가 statId임
        }

        return statIds;
    }
}

