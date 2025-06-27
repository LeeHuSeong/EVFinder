package com.example.login.controller;

import com.example.login.JwtUtil;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
public class AuthController {

    @PostMapping("/login")
    public ResponseEntity<?> loginWithFirebase(@RequestHeader("Authorization") String idToken) {
        try {
            if (idToken.startsWith("Bearer ")) {
                idToken = idToken.substring(7);
            }

            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);

            String uid = decodedToken.getUid();
            String email = decodedToken.getEmail();
            String name = decodedToken.getName();
            String picture = decodedToken.getPicture();

            String jwt = JwtUtil.generateToken(uid, email);

            return ResponseEntity.ok().body(new AuthResponse(uid, email, name, picture, jwt));
        } catch (Exception e) {
            return ResponseEntity.status(401).body("Invalid or expired token.");
        }
    }

    record AuthResponse(String uid, String email, String name, String picture, String jwt) {}
}
