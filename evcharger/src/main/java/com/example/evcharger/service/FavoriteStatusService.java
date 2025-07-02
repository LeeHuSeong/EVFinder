package com.example.evcharger.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FavoriteStatusService {
    

    @Autowired
    private FavoriteService favoriteService;

    @Autowired
    private FindEvChargerService chargerService;

    public List<Map<String, Object>> getFavoritesWithUpdatedStat(String userId, double myLat, double myLng) {
        List<Map<String, Object>> favorites = favoriteService.getFavorites(userId);
        List<Map<String, Object>> updatedList = new ArrayList<>();

        try {
            // 1. 즐겨찾기 목록에서 statId만 추출
            Set<String> statIdSet = favorites.stream()
                .map(fav -> (String) fav.get("statId"))
                .collect(Collectors.toSet());

            // 2. FindEvChargerService로부터 전체 최신 충전기 정보 가져오기
            // 예시로 서울시 기준, 위치 기준 정렬
            List<Map<String, Object>> freshData = chargerService.getChargersBySidoCode("11", myLat, myLng);

            // 3. statId 기준으로 매칭된 데이터만 반환
            for (Map<String, Object> charger : freshData) {
                String statId = (String) charger.get("statId");
                if (statIdSet.contains(statId)) {
                    updatedList.add(charger);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();  // 필요시 로깅
        }

        return updatedList;
    }
}