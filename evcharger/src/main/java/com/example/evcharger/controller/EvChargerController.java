package com.example.evcharger.controller;

import com.example.evcharger.service.EvChargerService;
import com.example.evcharger.service.FindEvChargerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/ev")
public class EvChargerController {

    @Autowired
    private EvChargerService evChargerService;
    
    private FindEvChargerService chargerService;

    @Autowired
    private FindEvChargerService findEvChargerService;

    @GetMapping("/geocode")
    public ResponseEntity<?> getCoordsWithSidoCode(@RequestParam String query) {
        try {
            Map<String, Object> coords = evChargerService.getCoordinates(query);
            double lat = Double.parseDouble((String) coords.get("y"));
            double lng = Double.parseDouble((String) coords.get("x"));
            String sidoCode = evChargerService.getSidoCodeFromCoordinates(lat, lng);

            Map<String, Object> result = new HashMap<>(coords);
            result.put("sidoCode", sidoCode);

            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/sido-code")
    public ResponseEntity<?> getSidoCode(@RequestParam double lat, @RequestParam double lng) {
        try {
            String sidoCode = evChargerService.getSidoCodeFromCoordinates(lat, lng);
            return ResponseEntity.ok(Map.of("sidoCode", sidoCode));
        } catch (Exception e) {
            return ResponseEntity.status(500).body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/findevc")
    public ResponseEntity<?> autoFindEvChargers(@RequestParam String query) {
        try {
            Map<String, Object> coords = evChargerService.getCoordinates(query);
            double lat = Double.parseDouble((String) coords.get("y"));
            double lng = Double.parseDouble((String) coords.get("x"));
            String sidoCode = evChargerService.getSidoCodeFromCoordinates(lat, lng);

            List<Map<String, Object>> chargers = findEvChargerService.getChargersBySidoCode(sidoCode, lat, lng);

            return ResponseEntity.ok(Map.of(
                "roadAddress", coords.get("roadAddress"),
                "sidoCode", sidoCode,
                "chargers", chargers
            ));
        } catch (Exception e) {
            return ResponseEntity.status(500).body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/stat")
    public ResponseEntity<?> getStatByStatId(@RequestParam String statId) {
        try {
            int stat = findEvChargerService.getStatByStatId(statId);
            return ResponseEntity.ok(Map.of("stat", stat));  // ← 여기를 Map으로 감싸기
        } catch (Exception e) {
            return ResponseEntity.status(404).body(Map.of("error", "Stat not found for statId: " + statId));
        }
    }
}
