package com.darknash.AbsensiApps.controllers;

import com.darknash.AbsensiApps.dtos.*;
import com.darknash.AbsensiApps.services.AttendanceService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping(path = "/attendance")
@RequiredArgsConstructor
public class AttendanceController {

    private final AttendanceService attendanceService;


    @PostMapping
    public AppResponse<List<AttendanceResponse>> createAttendance(@RequestBody @Valid AttendanceRequest attendanceRequest) {
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
                .number(attendanceResponses.getNumber() + 1)
                .size(attendanceResponses.getSize())
                .totalPages(attendanceResponses.getTotalPages())
                .hasPrevious(attendanceResponses.hasPrevious())
                .hasNext(attendanceResponses.hasNext())
                .content(attendanceResponses.getContent())
                .build();

        return AppResponse.<PageResponse<List<AttendanceResponse>>>builder()
                .status(HttpStatus.OK.getReasonPhrase())
                .message("Successfully read Attendance")
                .data(attendanceResponsePageResponse)
                .build();
    }

    @PutMapping(path = "/{id}")
    public AppResponse<AttendanceResponse> updateAttendance(@PathVariable UUID id, @RequestBody @Valid AttendanceRequestUpdate attendanceRequest) {
        AttendanceResponse attendanceResponse = attendanceService.updateAttendance(id, attendanceRequest);

        return AppResponse.<AttendanceResponse>builder()
                .status(HttpStatus.OK.getReasonPhrase())
                .message("Successfully updated Attendance")
                .data(attendanceResponse)
                .build();
    }

    @DeleteMapping(path = "/{id}")
    public AppResponse<Void> deleteAttendance(@PathVariable UUID id) {
        attendanceService.deleteAttendance(id);

        return AppResponse.<Void>builder()
                .status(HttpStatus.OK.getReasonPhrase())
                .message("Successfully deleted Attendance")
                .data(null)
                .build();
    }

    @GetMapping(path = "/{id}")
    public AppResponse<AttendanceResponse> readAttendance(@PathVariable UUID id) {
        AttendanceResponse attendanceResponse = attendanceService.getAttendance(id);

        return AppResponse.<AttendanceResponse>builder()
                .status(HttpStatus.OK.getReasonPhrase())
                .message("Successfully read Attendance")
                .data(attendanceResponse)
                .build();
    }

    @GetMapping(path = "/search")
    public AppResponse<PageResponse<List<AttendanceResponse>>> searchAttendanceByAttendanceDate(
            @RequestParam(required = false) LocalDate startDate,
            @RequestParam(required = false) LocalDate endDate,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(required = false) boolean ascending
            ) {
        Pageable pageable = PageRequest.of(
                page,
                size,
                ascending ? Sort.by("attendanceDate").ascending() : Sort.by("attendanceDate").descending()
        );

        Page<AttendanceResponse> searchResponse = attendanceService.searchAttendanceByAttendanceDate(pageable, startDate, endDate);

        PageResponse<List<AttendanceResponse>> pageResponse = PageResponse.<List<AttendanceResponse>>builder()
                .number(searchResponse.getNumber() + 1)
                .size(searchResponse.getSize())
                .totalPages(searchResponse.getTotalElements())
                .hasNext(searchResponse.hasNext())
                .hasPrevious(searchResponse.hasPrevious())
                .content(searchResponse.getContent())
                .build();

        return AppResponse.<PageResponse<List<AttendanceResponse>>>builder()
                .status(HttpStatus.OK.getReasonPhrase())
                .message("Successfully Search Attendance")
                .data(pageResponse)
                .build();

    }


}
