package com.example.login.service;

import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.DocumentReference;
import com.google.firebase.cloud.FirestoreClient;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class UserDataService {

    public void createUserDocument(String uid, String email) {
        Firestore db = FirestoreClient.getFirestore();
        DocumentReference userDoc = db.collection("users").document(uid);

        Map<String, Object> data = new HashMap<>();
        data.put("email", email);
        data.put("createdAt", System.currentTimeMillis());

        userDoc.set(data); // 사용자 문서 생성
    }
}
