package com.example.evcharger.model;

import com.google.cloud.spring.data.firestore.Document;
import org.springframework.data.annotation.Id;

@Document(collectionName = "favorites")
public class Favorite {

    @Id
    private String id;

    private String userId;
    private String stationId;

    public Favorite() {}

    public Favorite(String userId, String stationId) {
        this.userId = userId;
        this.stationId = stationId;
        this.id = userId + "_" + stationId;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getStationId() {
        return stationId;
    }

    public void setStationId(String stationId) {
        this.stationId = stationId;
    }
}
