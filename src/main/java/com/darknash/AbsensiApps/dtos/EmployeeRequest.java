package com.darknash.AbsensiApps.dtos;

import com.darknash.AbsensiApps.entities.Role;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class EmployeeRequest {

    @NotBlank(message = "Username must be fill")
    private String username;
    @NotBlank(message = "Firstname must be fill")
    private String firstName;
    @NotBlank(message = "Lastname must be fill")
    private String lastName;
    @NotNull(message = "Role must be fill")
    private Role role;

}
