package com.example.evcharger.controller;

import com.example.evcharger.model.Favorite;
import com.example.evcharger.service.FavoriteService;
import org.springframework.beans.factory.annotation.Autowired;
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

    @PostMapping("/add")
    public ApiResponse addFavorite(@RequestBody Map<String, Object> request) {
        String userId = (String) request.get("userId");
        Map<String, Object> station = (Map<String, Object>) request.get("station");
        return favoriteService.addFavorite(userId, station);
    }
}
