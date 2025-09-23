package com.darknash.AbsensiApps.controllers;

import com.darknash.AbsensiApps.dtos.AppResponse;
import com.darknash.AbsensiApps.dtos.AttendanceRequest;
import com.darknash.AbsensiApps.dtos.AttendanceResponse;
import com.darknash.AbsensiApps.dtos.PageResponse;
import com.darknash.AbsensiApps.services.AttendanceService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(path = "/attendance")
@RequiredArgsConstructor
public class AttendanceController {

    private final AttendanceService attendanceService;


    @PostMapping
    public AppResponse<List<AttendanceResponse>> createAttendance(@RequestBody AttendanceRequest attendanceRequest) {
        List<AttendanceResponse> attendanceResponse = attendanceService.createAttendance(attendanceRequest);

        return AppResponse.<List<AttendanceResponse>>builder()
                .status(HttpStatus.CREATED.getReasonPhrase())
                .message("Created Attendance")
                .data(attendanceResponse)
                .build();
    }

    @GetMapping
    public AppResponse<PageResponse<List<AttendanceResponse>>> readAttendance(
            @RequestParam(defaultValue = "0" ) int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        PageRequest pageRequest = PageRequest.of(page, size);

        Page<AttendanceResponse> attendanceResponses = attendanceService.getAttendances(pageRequest);

        PageResponse<List<AttendanceResponse>> attendanceResponsePageResponse = PageResponse.<List<AttendanceResponse>>builder()
                .page(attendanceResponses.getTotalPages())
                .size(attendanceResponses.getSize())
                .total(attendanceResponses.getTotalPages())
                .data(attendanceResponses.getContent())
                .build();

        return AppResponse.<PageResponse<List<AttendanceResponse>>>builder()
                .status(HttpStatus.OK.getReasonPhrase())
                .message("Successfully read Attendance")
                .data(attendanceResponsePageResponse)
                .build();
    }
}
