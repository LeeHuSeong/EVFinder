package com.example.evcharger.repository;

import com.example.evcharger.model.Favorite;
import com.google.cloud.spring.data.firestore.FirestoreReactiveRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;

@Repository
public interface FavoriteRepository extends FirestoreReactiveRepository<Favorite> {
    Flux<Favorite> findByUserId(String userId);
}
