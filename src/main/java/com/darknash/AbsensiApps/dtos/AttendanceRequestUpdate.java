package com.darknash.AbsensiApps.dtos;

import com.darknash.AbsensiApps.entities.Status;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AttendanceRequestUpdate {

    @NotNull(message = "Attendance date must be fill")
    private LocalDate attendanceDate;

    @NotNull(message = "Attendance date must be fill")
    private Status status;
}
