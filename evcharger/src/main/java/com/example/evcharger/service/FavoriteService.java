package com.example.evcharger.service;

import com.example.evcharger.model.ApiResponse;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.cloud.firestore.QuerySnapshot;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import com.google.cloud.firestore.SetOptions;


@Service
public class FavoriteService {

    @Autowired
    private Firestore firestore;

    public ApiResponse addFavorite(String userId, Map<String, Object> stationData) {
        try {
            String statId = (String) stationData.get("statId");

            if (statId == null) {
                return new ApiResponse("error", "Missing statId");
            }

            DocumentReference docRef = firestore
                    .collection("users")
                    .document(userId)
                    .collection("favorites")
                    .document(statId);

            docRef.set(stationData, SetOptions.merge()).get();
            return new ApiResponse("success", "Added/Updated " + statId);
        }
        catch (Exception e) {
            return new ApiResponse("error", e.getMessage());
        }
    }

    //삭제시 로그 추가
    public ApiResponse removeFavorite(String userId, String statId) {
        try {
            DocumentReference docRef = firestore
                    .collection("users")
                    .document(userId)
                    .collection("favorites")
                    .document(statId);
            
            System.out.println("[삭제 시도] userId = " + userId + ", statId = " + statId);
            System.out.println("[Firestore 경로] " + docRef.getPath());

            docRef.delete().get();  // 동기

            return new ApiResponse("success", "Deleted " + statId);
        } catch (Exception e) {
            System.err.println("[삭제 오류] " + e.getMessage());
            return new ApiResponse("error", e.getMessage());
        }
    }

    public List<Map<String, Object>> getFavorites(String userId) {
        try {
            CollectionReference ref = firestore
                    .collection("users")
                    .document(userId)
                    .collection("favorites");

            ApiFuture<QuerySnapshot> future = ref.get();
            List<QueryDocumentSnapshot> documents = future.get().getDocuments();

            List<Map<String, Object>> result = new ArrayList<>();
            for (QueryDocumentSnapshot doc : documents) {
                result.add(doc.getData());
            }

            return result;
        } 
        catch (Exception e) {
            return Collections.emptyList();
        }
    }

    //stat업데이트 해주기.
    public ApiResponse updateStat(String userId, String statId, int stat) {
    try {
        DocumentReference docRef = firestore
            .collection("users")
            .document(userId)
            .collection("favorites")
            .document(statId);

        docRef.update("stat", stat).get(); // stat 필드만 갱신
        return new ApiResponse("success", "Updated stat for " + statId);
    } catch (Exception e) {
        return new ApiResponse("error", e.getMessage());
    }
}
}