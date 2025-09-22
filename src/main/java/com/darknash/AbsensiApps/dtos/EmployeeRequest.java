package com.darknash.AbsensiApps.dtos;

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

    @NotNull(message = "Username must be fill")
    private String username;
    @NotNull(message = "Firstname must be fill")
    private String firstName;
    @NotNull(message = "Lastname must be fill")
    private String lastName;

}
