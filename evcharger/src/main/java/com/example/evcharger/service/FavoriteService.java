package com.example.evcharger.service;

import com.example.evcharger.model.ApiResponse;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.Firestore;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;


@Service
public class FavoriteService {

    @Autowired
    private Firestore firestore;

    public ApiResponse addFavorite(String userId, Map<String, Object> stationData) {
        try {
            CollectionReference ref = firestore
                .collection("users")
                .document(userId)
                .collection("favorites");

            ApiFuture<DocumentReference> future = ref.add(stationData);
            DocumentReference docRef = future.get(); // 동기 방식
            return new ApiResponse("success", docRef.getId());

        } catch (Exception e) {
            return new ApiResponse("error", e.getMessage());
        }
    }
}