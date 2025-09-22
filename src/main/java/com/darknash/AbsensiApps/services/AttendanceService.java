package com.darknash.AbsensiApps.services;

import com.darknash.AbsensiApps.dtos.AttendanceRequest;
import com.darknash.AbsensiApps.dtos.AttendanceResponse;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;

import java.util.UUID;

public interface AttendanceService {
    AttendanceResponse createAttendance(AttendanceRequest attendanceRequest);
    AttendanceResponse updateAttendance(UUID id, AttendanceRequest attendanceRequest);
    void deleteAttendance(UUID id);
    AttendanceResponse getAttendance(UUID id);
    Page<AttendanceResponse> getAttendances(PageRequest pageRequest);
}
