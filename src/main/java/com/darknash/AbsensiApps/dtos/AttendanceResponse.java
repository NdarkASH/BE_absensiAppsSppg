package com.darknash.AbsensiApps.dtos;

import com.darknash.AbsensiApps.entities.Employee;
import com.darknash.AbsensiApps.entities.Status;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AttendanceResponse {
    private UUID id;

    private Employee employees;

    private LocalDateTime attendanceDate;

    private Status status;

    private LocalDateTime createdDate;

    private LocalDateTime updatedDate;
}
