package com.darknash.AbsensiApps.services.impl;

import com.darknash.AbsensiApps.dtos.AttendanceRequest;
import com.darknash.AbsensiApps.dtos.AttendanceResponse;
import com.darknash.AbsensiApps.entities.Attendance;
import com.darknash.AbsensiApps.entities.Employee;
import com.darknash.AbsensiApps.repositories.AttendanceRepository;
import com.darknash.AbsensiApps.services.AttendanceService;
import com.darknash.AbsensiApps.services.EmployeeService;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;


import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@Transactional
@RequiredArgsConstructor
public class AttendanceServiceImpl implements AttendanceService {
    private final AttendanceRepository attendanceRepository;
    private final EmployeeService employeeService;

    @Override
    public AttendanceResponse createAttendance(AttendanceRequest attendanceRequest) {

        Set<Employee> employees = attendanceRequest.getEmployeeId()
                .stream()
                .map(employeeService::getEmployeeEntity)
                .collect(Collectors.toSet());

        Attendance attendance = new Attendance();
        attendance.setId(UUID.randomUUID());
        attendance.setAttendanceDate(attendanceRequest.getAttendanceDate());
        attendance.setStatus(attendanceRequest.getStatus());
        attendance.setEmployees(employees);
        attendanceRepository.save(attendance);

        return toAttendanceResponse(attendance);
    }

    @Override
    public AttendanceResponse updateAttendance(UUID id, AttendanceRequest attendanceRequest) {
        return null;
    }

    @Override
    public void deleteAttendance(UUID id) {

    }

    @Override
    public AttendanceResponse getAttendance(UUID id) {
        return null;
    }

    @Override
    public Page<AttendanceResponse> getAttendances(PageRequest pageRequest) {
        return null;
    }

    private AttendanceResponse toAttendanceResponse(Attendance attendance) {
        return AttendanceResponse.builder()
                .id(UUID.randomUUID())
                .attendanceDate(attendance.getAttendanceDate())
                .status(attendance.getStatus())
                .updatedDate(attendance.getUpdatedDate())
                .createdDate(attendance.getCreatedDate())
                .build();
    }
}
