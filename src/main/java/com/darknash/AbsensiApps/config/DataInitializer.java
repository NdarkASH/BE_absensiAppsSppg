package com.darknash.AbsensiApps.config;

import com.darknash.AbsensiApps.entities.User;
import com.darknash.AbsensiApps.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final DefaultUserProperties defaultUserProperties;

    @Override
    public void run(String... args) throws Exception {
        String email = defaultUserProperties.getEmail();
        String password = defaultUserProperties.getPassword();

        if (userRepository.findByEmail(email).isEmpty()) {
            User user = new User();
            user.setEmail(email);
            user.setPassword(passwordEncoder.encode(password));
            userRepository.save(user);
            System.out.println(email + "has been saved");

        } else  {
            System.out.println(email + "has already been exist");
        }
    }
}
