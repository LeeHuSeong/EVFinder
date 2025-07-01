package com.example.evcharger.controller;

import com.example.evcharger.service.FavoriteStatusService;
import com.google.cloud.firestore.Firestore;

import java.util.ArrayList;
import java.util.List;
import com.example.evcharger.model.Favorite;
import com.example.evcharger.service.FavoriteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import com.example.evcharger.model.ApiResponse;
import java.util.Map;
import com.example.evcharger.model.ApiResponse;

@RestController
@RequestMapping("/api/favorite")
public class FavoriteController {

    @Autowired
    private FavoriteService favoriteService;

    @Autowired
    private FavoriteStatusService favoriteStatusService;

    //테스트를 위한 추가
    @Autowired
    private Firestore firestore;

    @PostMapping("/add")
    public ApiResponse addFavorite(@RequestBody Map<String, Object> request) {
        String userId = (String) request.get("userId");
        Map<String, Object> station = (Map<String, Object>) request.get("station");
        return favoriteService.addFavorite(userId, station);
    }

    @GetMapping("/listWithStat")
    public List<Map<String, Object>> getFavoritesWithUpdatedStat(
            @RequestParam String userId,
            @RequestParam double lat,
            @RequestParam double lng) {
        return favoriteStatusService.getFavoritesWithUpdatedStat(userId, lat, lng);
    }

    //테스트를 위함
    @GetMapping("/test")
    public ResponseEntity<?> testFavorites(@RequestParam String userId) {
        try {
            var collection = firestore.collection("users").document(userId).collection("favorites");
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
