package com.example.evcharger.controller;

import com.google.cloud.firestore.Firestore;

import java.util.ArrayList;
import java.util.List;
import com.example.evcharger.service.FavoriteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.example.evcharger.model.ApiResponse;
import java.util.Map;

//로그
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@RestController
@RequestMapping("/api/favorite")
public class FavoriteController {

    @Autowired
    private FavoriteService favoriteService;

    @Autowired
    private Firestore firestore;

    private static final Logger log = LoggerFactory.getLogger(FavoriteController.class);

    @PostMapping("/add")
    public ApiResponse addFavorite(@RequestBody Map<String, Object> request) {
        String uid = (String) request.get("uid");
        Map<String, Object> station = (Map<String, Object>) request.get("station");

        // 로그 추가
        System.out.println("[즐겨찾기 추가 요청] uid = " + uid + ", station = " + station);

        return favoriteService.addFavorite( uid, station);
    }

    @PostMapping("/updateStat")
    public ApiResponse updateStat(@RequestBody Map<String, Object> request) {
        String uid = (String) request.get("uid");
        String statId = (String) request.get("statId");
        int stat = (int) request.get("stat");
        return favoriteService.updateStat(uid, statId, stat);
    }

    @DeleteMapping("/remove")
    public ResponseEntity<ApiResponse> removeFavorite(
            @RequestParam String uid,
            @RequestParam String statId) {
        log.info("DELETE 요청 수신 - uid: {}, statId: {}", uid, statId);
        ApiResponse result = favoriteService.removeFavorite(uid, statId);
        return ResponseEntity.ok(result);
    }

    @GetMapping("/list")
    public Map<String, Object> getFavorites(@RequestParam String uid) {
        List<Map<String, Object>> favorites = favoriteService.getFavorites(uid);

        // statId가 누락되었을 가능성 대비 → 문서 ID를 statId로 추가
        for (Map<String, Object> fav : favorites) {
            if (!fav.containsKey("statId") && fav.containsKey("id")) {
                fav.put("statId", fav.get("id"));
            }
        }

        return Map.of("favorites", favorites);
    }


    @GetMapping("/test")
    public ResponseEntity<?> testFavorites(@RequestParam String uid) {
        try {
            var collection = firestore.collection("users").document(uid).collection("favorites");
            var docs = collection.get().get().getDocuments();

            List<Map<String, Object>> result = new ArrayList<>();
            for (var doc : docs) {
                result.add(doc.getData());
            }

            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(Map.of("error", e.getMessage()));
        }
    }
}