package com.darknash.AbsensiApps.dtos;

import com.darknash.AbsensiApps.entities.Employee;
import com.darknash.AbsensiApps.entities.Status;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AttendanceResponse {
    private UUID id;

    private LocalDate attendanceDate;

    private Status status;

    private EmployeeResponse employees;

    private LocalDateTime createdDate;

    private LocalDateTime updatedDate;
}
