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

//로그
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@RestController
@RequestMapping("/api/favorite")
public class FavoriteController {

    @Autowired
    private FavoriteService favoriteService;

    @Autowired
    private FavoriteStatusService favoriteStatusService;

    //로그
    private static final Logger log = LoggerFactory.getLogger(FavoriteController.class);


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

    @DeleteMapping("/remove")
    public ResponseEntity<ApiResponse> removeFavorite(
            @RequestParam String userId,
            @RequestParam String statId) {
        log.info("DELETE 요청 수신 - userId: {}, statId: {}", userId, statId);
        ApiResponse result = favoriteService.removeFavorite(userId, statId);
        
        return ResponseEntity.ok(result);
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
