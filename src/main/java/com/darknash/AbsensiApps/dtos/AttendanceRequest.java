package com.darknash.AbsensiApps.dtos;

import com.darknash.AbsensiApps.entities.Status;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.Set;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AttendanceRequest {

    @NotBlank(message = "employee id must be fill")
    private Set<UUID> employeeId;

    @NotBlank(message = "Attendance date must be fill")
    private LocalDate attendanceDate;

    @NotNull(message = "Attendance date must be fill")
    private Status status;

}
