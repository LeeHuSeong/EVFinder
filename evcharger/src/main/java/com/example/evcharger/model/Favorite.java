package com.example.evcharger.model;

import com.google.cloud.spring.data.firestore.Document;
import org.springframework.data.annotation.Id;

@Document(collectionName = "favorites")
public class Favorite {

    @Id
    private String id;

    private String uid;
    private String stationId;

    public Favorite() {}

    public Favorite(String uid, String stationId) {
        this.uid = uid;
        this.stationId = stationId;
        this.id = uid + "_" + stationId;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getStationId() {
        return stationId;
    }

    public void setStationId(String stationId) {
        this.stationId = stationId;
    }
}
