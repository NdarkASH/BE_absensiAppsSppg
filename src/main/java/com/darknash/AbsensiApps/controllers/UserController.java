package com.darknash.AbsensiApps.controllers;

import com.darknash.AbsensiApps.dtos.LoginRequest;
import com.darknash.AbsensiApps.services.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/login")
public class UserController {

    private final UserService userService;

    @PostMapping
    public Boolean login(@RequestBody LoginRequest loginRequest) {
        boolean result = userService.login(loginRequest.getEmail(), loginRequest.getPassword());

        if (!result) {
            throw new RuntimeException("Invalid email or password");
        }
        return true;
    }
}
