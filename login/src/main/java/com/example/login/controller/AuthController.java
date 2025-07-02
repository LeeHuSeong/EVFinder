package com.example.login.controller;

import com.example.login.dto.LoginRequest;
import com.example.login.dto.LoginResponse;
import com.example.login.dto.SignupRequest;
import com.example.login.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private AuthService authService;

    // 회원가입 (이메일/비밀번호)
    @PostMapping("/signup")
    public ResponseEntity<LoginResponse> signup(@RequestBody SignupRequest request) {
        return ResponseEntity.ok(authService.signup(request));
    }

    // 구글 로그인 (또는 Firebase ID 토큰으로 로그인)
    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@RequestBody LoginRequest request) {
        return ResponseEntity.ok(authService.loginWithIdToken(request.getIdToken()));
    }

    // 비밀번호 재설정 이메일 전송
    @PostMapping("/changepw")
    public ResponseEntity<LoginResponse> changepw(@RequestBody LoginRequest request) {
        String email = request.getEmail();

        if (email == null || email.isEmpty()) {
            return ResponseEntity.badRequest().body(new LoginResponse(false, "이메일을 입력해주세요."));
        }

        return ResponseEntity.ok(authService.sendPasswordResetEmail(email));
    }

    // 회원 탈퇴
    @DeleteMapping("/delete")
    public ResponseEntity<LoginResponse> delete(@RequestHeader("Authorization") String token) {
        String jwt = token.replace("Bearer ", "");
        String uid = authService.getUidFromJwt(jwt);
        return ResponseEntity.ok(authService.deleteUser(uid));
    }
}
