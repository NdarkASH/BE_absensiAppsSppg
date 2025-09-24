package com.darknash.AbsensiApps.services.impl;

import com.darknash.AbsensiApps.entities.User;
import com.darknash.AbsensiApps.repositories.UserRepository;
import com.darknash.AbsensiApps.services.UserService;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public Boolean login(String email, String password) {
        User user = userRepository.findByEmail(email).orElseThrow(()->new EntityNotFoundException("User not found"));

        return passwordEncoder.matches(password, user.getPassword());
    }
}
