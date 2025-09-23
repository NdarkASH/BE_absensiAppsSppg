package com.darknash.AbsensiApps.services.impl;

import com.darknash.AbsensiApps.dtos.AttendanceRequest;
import com.darknash.AbsensiApps.dtos.AttendanceResponse;
import com.darknash.AbsensiApps.entities.Attendance;
import com.darknash.AbsensiApps.repositories.AttendanceRepository;
import com.darknash.AbsensiApps.services.AttendanceService;
import com.darknash.AbsensiApps.services.EmployeeService;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;


import java.util.List;
import java.util.UUID;


@Service
@Transactional
@RequiredArgsConstructor
public class AttendanceServiceImpl implements AttendanceService {
    private final AttendanceRepository attendanceRepository;
    private final EmployeeService employeeService;

    @Override
    public List<AttendanceResponse> createAttendance(AttendanceRequest attendanceRequest) {

        List<Attendance> attendances = attendanceRequest.getEmployeeId()
                .stream()
                .map(employeeService::getEmployeeEntity)
                .map(employee -> {
                    Attendance attendance = new Attendance();
                    attendance.setAttendanceDate(attendanceRequest.getAttendanceDate());
                    attendance.setStatus(attendanceRequest.getStatus());
                    attendance.setEmployees(employee);
                    return attendance;
                }).toList();
        attendanceRepository.saveAllAndFlush(attendances);

        return attendances.stream()
                .map(this::toAttendanceResponse)
                .toList();
    }

    @Override
    public AttendanceResponse updateAttendance(UUID id, AttendanceRequest attendanceRequest) {
        Attendance attendance = getAttendanceEntity(id);
        attendance.setAttendanceDate(attendanceRequest.getAttendanceDate());
        attendance.setStatus(attendanceRequest.getStatus());
        attendanceRepository.saveAndFlush(attendance);

        return toAttendanceResponse(attendance);
    }

    @Override
    public void deleteAttendance(UUID id) {
        attendanceRepository.deleteById(id);
    }

    @Override
    public AttendanceResponse getAttendance(UUID id) {
        Attendance attendance = getAttendanceEntity(id);
        return toAttendanceResponse(attendance);
    }

    @Override
    public Page<AttendanceResponse> getAttendances(PageRequest pageRequest) {
        Page<Attendance> attendances = attendanceRepository.findAll(pageRequest);

        return attendances.map(this::toAttendanceResponse);
    }


    private Attendance getAttendanceEntity(UUID id) {
        return attendanceRepository.findById(id)
                .orElseThrow(()-> new EntityNotFoundException("Attendance with id " + id + " not found"));
    }
    private AttendanceResponse toAttendanceResponse(Attendance attendance) {
        return AttendanceResponse.builder()
                .id(attendance.getId())
                .attendanceDate(attendance.getAttendanceDate())
                .status(attendance.getStatus())
                .updatedDate(attendance.getUpdatedDate())
                .employees(employeeService.getEmployee(attendance.getEmployees().getId()))
                .createdDate(attendance.getCreatedDate())
                .build();
    }
}
