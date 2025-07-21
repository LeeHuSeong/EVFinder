package com.example.evcharger.controller;

import com.example.evcharger.service.FavoriteGlobalStatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/favorite/global")
public class FavoriteGlobalStatController {

    @Autowired
    private FavoriteGlobalStatService favoriteGlobalStatService;

    @GetMapping("/listWithStat")
    public ResponseEntity<?> getFavoritesWithStatGlobal(
        @RequestParam String userId,
        @RequestParam double lat,
        @RequestParam double lng
    ) 
    {
        try {
            var result = favoriteGlobalStatService.getUpdatedFavorites(userId, lat, lng);
            return ResponseEntity.ok(Map.of("favorites", result));
        }
        catch (Exception e) {
            return ResponseEntity.status(500).body(Map.of("error", e.getMessage()));
        }
    }
}
