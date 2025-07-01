package com.example.login.controller;

import com.example.login.dto.LoginRequest;
import com.example.login.dto.LoginResponse;
import com.example.login.dto.SignupRequest;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.UserRecord;
import com.google.firebase.auth.UserRecord.CreateRequest;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.beans.factory.annotation.Value;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class LoginController {

    @Value("${firebase.api.key}")
    private String firebaseApiKey;

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequest request) {
        String firebaseUrl = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=" + firebaseApiKey;

        RestTemplate restTemplate = new RestTemplate();
        Map<String, Object> payload = new HashMap<>();
        payload.put("email", request.getEmail());
        payload.put("password", request.getPassword());
        payload.put("returnSecureToken", true);

        try {
            Map<?, ?> firebaseResponse = restTemplate.postForObject(firebaseUrl, payload, Map.class);
            return ResponseEntity.ok(new LoginResponse(true, "로그인 성공"));
        } catch (Exception e) {
            e.printStackTrace();
            String rawMessage = e.getMessage();
            String userMessage;

            if (rawMessage.contains("INVALID_PASSWORD")) {
                userMessage = "비밀번호가 올바르지 않습니다.";
            } else if (rawMessage.contains("EMAIL_NOT_FOUND")) {
                userMessage = "등록되지 않은 이메일입니다.";
            } else if (rawMessage.contains("INVALID_LOGIN_CREDENTIALS")) {
                userMessage = "이메일 또는 비밀번호가 올바르지 않습니다.";
            } else if (rawMessage.contains("USER_DISABLED")) {
                userMessage = "이 계정은 비활성화되어 있습니다.";
            } else {
                userMessage = "로그인 실패: 알 수 없는 오류가 발생했습니다.";
            }

            return ResponseEntity.status(401).body(new LoginResponse(false, userMessage));
        }
    }

    @PostMapping("/signup")
    public ResponseEntity<Map<String, Object>> signup(@RequestBody SignupRequest request) {
        Map<String, Object> response = new HashMap<>();

        if (request.getEmail() == null || request.getEmail().isEmpty()) {
            response.put("success", false);
            response.put("message", "이메일을 입력해주세요.");
            return ResponseEntity.badRequest().body(response);
        }

        if (request.getPassword() == null || request.getPassword().length() < 6) {
            response.put("success", false);
            response.put("message", "비밀번호는 6자 이상이어야 합니다.");
            return ResponseEntity.badRequest().body(response);
        }

        try {
            CreateRequest createRequest = new CreateRequest()
                    .setEmail(request.getEmail())
                    .setPassword(request.getPassword());

            UserRecord userRecord = FirebaseAuth.getInstance().createUser(createRequest);

            response.put("success", true);
            response.put("uid", userRecord.getUid());
            response.put("email", userRecord.getEmail());
            return ResponseEntity.ok(response);

        } catch (FirebaseAuthException e) {
            response.put("success", false);
            if (e.getAuthErrorCode() != null &&
                e.getAuthErrorCode().toString().equals("EMAIL_ALREADY_EXISTS")) {
                response.put("message", "이미 가입된 이메일입니다.");
            } else {
                response.put("message", "회원가입 실패: " + e.getMessage());
            }
            return ResponseEntity.badRequest().body(response);
        }
    }
    @PostMapping("/changepw")
    public ResponseEntity<LoginResponse> changepw(@RequestBody LoginRequest request) {
        String firebaseUrl = "https://identitytoolkit.googleapis.com/v1/accounts:update?key=" + firebaseApiKey;

        RestTemplate restTemplate = new RestTemplate();
        Map<String, Object> payload = new HashMap<>();
        payload.put("email", request.getEmail());
        payload.put("password", request.getPassword());
        payload.put("returnSecureToken", true);

        try {
            Map<?, ?> firebaseResponse = restTemplate.postForObject(firebaseUrl, payload, Map.class);
            return ResponseEntity.ok(new LoginResponse(true, "로그인 성공"));
        } catch (Exception e) {
            e.printStackTrace();
            String rawMessage = e.getMessage();
            String userMessage;

            if (rawMessage.contains("INVALID_PASSWORD")) {
                userMessage = "비밀번호가 올바르지 않습니다.";
            } else if (rawMessage.contains("EMAIL_NOT_FOUND")) {
                userMessage = "등록되지 않은 이메일입니다.";
            } else if (rawMessage.contains("INVALID_LOGIN_CREDENTIALS")) {
                userMessage = "이메일 또는 비밀번호가 올바르지 않습니다.";
            } else if (rawMessage.contains("USER_DISABLED")) {
                userMessage = "이 계정은 비활성화되어 있습니다.";
            } else {
                userMessage = "로그인 실패: 알 수 없는 오류가 발생했습니다.";
            }

            return ResponseEntity.status(401).body(new LoginResponse(false, userMessage));
        }
    }
}
