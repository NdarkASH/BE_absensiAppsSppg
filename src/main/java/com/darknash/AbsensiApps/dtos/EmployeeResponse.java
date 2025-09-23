package com.darknash.AbsensiApps.dtos;

import com.darknash.AbsensiApps.entities.Role;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Builder
public class EmployeeResponse {

    private UUID id;
    private String username;
    private String firstName;
    private String lastName;
    private Role role;
    private LocalDateTime createdDate;
    private LocalDateTime updatedDate;
}
