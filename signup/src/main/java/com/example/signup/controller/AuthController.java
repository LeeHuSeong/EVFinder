package com.example.signup.controller;

import com.example.signup.dto.SignupRequest;
import com.google.firebase.auth.*;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @PostMapping("/signup")
    public ResponseEntity<?> signup(@RequestBody SignupRequest request) {
        try {
            CreateRequest createRequest = new CreateRequest()
                    .setEmail(request.getEmail())
                    .setPassword(request.getPassword())
                    .setDisplayName(request.getDisplayName());

            UserRecord userRecord = FirebaseAuth.getInstance().createUser(createRequest);

            return ResponseEntity.ok("회원가입 성공 (UID: " + userRecord.getUid() + ")");
        } catch (FirebaseAuthException e) {
            return ResponseEntity.badRequest().body("회원가입 실패: " + e.getMessage());
        }
    }
}
