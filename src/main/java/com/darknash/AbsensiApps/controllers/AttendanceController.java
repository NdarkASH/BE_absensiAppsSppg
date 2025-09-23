package com.darknash.AbsensiApps.controllers;

import com.darknash.AbsensiApps.dtos.AppResponse;
import com.darknash.AbsensiApps.dtos.AttendanceRequest;
import com.darknash.AbsensiApps.dtos.AttendanceResponse;
import com.darknash.AbsensiApps.services.AttendanceService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping(path = "/attendance")
@RequiredArgsConstructor
public class AttendanceController {

    private final AttendanceService attendanceService;


    @PostMapping
    public AppResponse<List<AttendanceResponse>> createAttendance(AttendanceRequest attendanceRequest) {
        List<AttendanceResponse> attendanceResponse = attendanceService.createAttendance(attendanceRequest);

        return AppResponse.<List<AttendanceResponse>>builder()
                .status(HttpStatus.CREATED.getReasonPhrase())
                .message("Created Attendance")
                .data(attendanceResponse)
                .build();
    }
}
