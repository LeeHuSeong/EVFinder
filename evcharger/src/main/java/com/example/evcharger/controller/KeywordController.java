package com.example.evcharger.controller;

import com.example.evcharger.service.EvChargerService;
import com.example.evcharger.service.FindEvChargerService;
import com.example.evcharger.service.KeywordService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/keyword")
public class KeywordController {

    @Autowired
    private EvChargerService evChargerService;

    @Autowired
    private FindEvChargerService findEvChargerService;

    @Autowired
    private KeywordService keywordService;

    @GetMapping("/keywordlist")
    public ResponseEntity<?> autoFindEvChargers(@RequestParam String query) { // 사용자 키워드 입력에 따라 해당하는 키워드 장소 주변의 전기차 충전소들을 반환
        try {
            // 1. 처음에 keyword가 주어지면 kakao api로 요청보내서 주소 및 위도 경도를 받아옴.
            // 2. 받아온 위도, 경도를 가지고 네이버 맵 api에 보내서 시도 코드를 받아옴.
            // 3. 받아온 시도 코드와, 위도, 경도를 다시 공공데이터 api로 보내서 충전소 관련 정보를 받아옴.
            // kakao_local_api -> naver map api -> 공공데이터 api 의 흐름을 갖음.

            Map<String, Object> coords = keywordService.getCoordinatesByKeyword(query);

            String road_address_name = (String)coords.get("road_address_name"); // 1
            double lat = Double.parseDouble((String) coords.get("y")); // 1
            double lng = Double.parseDouble((String) coords.get("x")); // 1

            String sidoCode = evChargerService.getSidoCodeFromCoordinates(lat, lng); // 2

            List<Map<String, Object>> chargers = findEvChargerService.getChargersBySidoCode(sidoCode, lat, lng); // 3

            return ResponseEntity.ok(Map.of(
                "roadAddress", road_address_name,
                "sidoCode", sidoCode,
                "chargers", chargers
            ));

        } catch (Exception e) {
            return ResponseEntity.status(500).body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/placelist") // 키워드를 받으면 해당하는 장소에 대한 리스트 반환 api
    public ResponseEntity<?> findByKeyword(@RequestParam String query) {
        try {
            List<Map<String, Object>> places = keywordService.getPlaceListByKeyword(query);
            return ResponseEntity.ok(places); // 전체 장소 리스트 반환
        } catch (Exception e) {
            return ResponseEntity.status(500).body(Map.of("error", e.getMessage()));
        }
    }
}
