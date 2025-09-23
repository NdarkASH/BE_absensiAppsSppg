package com.darknash.AbsensiApps.dtos;

import com.darknash.AbsensiApps.entities.Status;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AttendanceRequest {


    private LocalDateTime attendanceDate;

    private Status status;

    private List<UUID> employeeId;
}
