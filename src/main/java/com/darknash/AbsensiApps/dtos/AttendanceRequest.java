package com.darknash.AbsensiApps.dtos;

import com.darknash.AbsensiApps.entities.Status;
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

    private Set<UUID> employeeId;

    private LocalDate attendanceDate;

    private Status status;

}
