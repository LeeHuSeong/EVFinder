package com.example.login.service;

import com.example.login.dto.LoginRequest;
import com.example.login.dto.LoginResponse;
import com.example.login.dto.SignupRequest;
import com.google.firebase.auth.UserRecord.CreateRequest;
import com.example.login.util.JwtUtil;
import com.google.firebase.auth.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.google.firebase.auth.UserRecord.UpdateRequest;

@Service
public class AuthService {

    @Autowired
    private JwtUtil jwtUtil;

    // 이메일/비밀번호 회원가입
    public LoginResponse signup(SignupRequest request) {
        try {
            CreateRequest createRequest = new CreateRequest()
                    .setEmail(request.getEmail())
                    .setPassword(request.getPassword());

            UserRecord userRecord = FirebaseAuth.getInstance().createUser(createRequest);

            String token = jwtUtil.generateToken(userRecord.getUid(), userRecord.getEmail());

            return new LoginResponse(true, "회원가입 성공", token);

        } catch (FirebaseAuthException e) {
            return new LoginResponse(false, "회원가입 실패: " + e.getMessage(), null);
        }
    }

    // 이메일/비밀번호 로그인
    public LoginResponse login(LoginRequest request) {
        // 이 부분은 Firebase 자체에서는 서버에서 직접 비밀번호 인증이 불가능하므로
        // 클라이언트에서 idToken을 받아와 검증하는 구조를 사용해야 함
        return new LoginResponse(false, "이메일/비밀번호 로그인은 클라이언트에서 Firebase 로그인 후 idToken을 보내야 합니다.", null);
    }

    // Firebase ID 토큰으로 로그인 (구글 로그인 포함)
    public LoginResponse loginWithIdToken(String idToken) {
        try {
            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);
            String uid = decodedToken.getUid();
            String email = decodedToken.getEmail();

            String jwt = jwtUtil.generateToken(uid, email);
            return new LoginResponse(true, "로그인 성공", jwt);

        } catch (FirebaseAuthException e) {
            return new LoginResponse(false, "토큰 검증 실패: " + e.getMessage(), null);
        }
    }

    // 비밀번호 재설정 이메일 전송
    public LoginResponse resetPw(String idToken, String newPassword) {
        try {
            FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);
            String uid = decodedToken.getUid();

            UpdateRequest updateRequest = new UpdateRequest(uid)
                    .setPassword(newPassword);

            FirebaseAuth.getInstance().updateUser(updateRequest);

            return new LoginResponse(true, "비밀번호가 성공적으로 변경되었습니다.");
        } catch (FirebaseAuthException e) {
            return new LoginResponse(false, "비밀번호 변경 실패: " + e.getMessage());
        }
    }

    // 회원탈퇴
    public LoginResponse deleteUser(String uid) {
        try {
            FirebaseAuth.getInstance().deleteUser(uid);
            return new LoginResponse(true, "회원탈퇴 완료");
        } catch (FirebaseAuthException e) {
            return new LoginResponse(false, "회원탈퇴 실패: " + e.getMessage());
        }
    }

    // uid에서 jwt얻기(파싱)
    public String getUidFromJwt(String jwt) {
        return jwtUtil.getUidFromToken(jwt);
    }
}
