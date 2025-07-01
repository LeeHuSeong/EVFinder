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

    // 즐겨찾기 최신화 메서드
    public List<Map<String, Object>> getUpdatedFavorites(String userId) throws Exception {
        // 1. Firestore에서 즐겨찾기 목록(statId) 가져오기
        List<String> favoriteStatIds = getUserFavoriteStatIds(userId);

        // 2. 공공 API 전체 충전소 목록 가져오기
        List<Map<String, Object>> allChargers = findEvChargerService.getAllChargers();

        // 3. statId 기준으로 필터링
        List<Map<String, Object>> matched = new ArrayList<>();
        for (Map<String, Object> charger : allChargers) {
            String statId = (String) charger.get("statId");
            if (favoriteStatIds.contains(statId)) {
                matched.add(charger); // 그대로 추가 (필요시 필드 필터링 가능)
            }
        }

        return matched;
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

