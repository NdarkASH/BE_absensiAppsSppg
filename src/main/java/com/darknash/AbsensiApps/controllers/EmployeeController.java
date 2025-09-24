package com.darknash.AbsensiApps.controllers;

import com.darknash.AbsensiApps.dtos.AppResponse;
import com.darknash.AbsensiApps.dtos.EmployeeRequest;
import com.darknash.AbsensiApps.dtos.EmployeeResponse;
import com.darknash.AbsensiApps.dtos.PageResponse;
import com.darknash.AbsensiApps.services.EmployeeService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping(path = "/employee")
@RequiredArgsConstructor
@Slf4j
public class EmployeeController {

    private final EmployeeService employeeService;


    @PostMapping
    public AppResponse<EmployeeResponse> createEmployee(@RequestBody EmployeeRequest employeeRequest) {

        EmployeeResponse employeeResponse = employeeService.createEmployee(employeeRequest);

        return  AppResponse.<EmployeeResponse>builder()
                .status(HttpStatus.CREATED.getReasonPhrase())
                .message("Employee Created")
                .data(employeeResponse)
                .build();
    }

    @GetMapping
    public AppResponse<PageResponse<List<EmployeeResponse>>> getAllEmployees(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size
    ) {

        PageRequest pageRequest = PageRequest.of(page, size);

        Page<EmployeeResponse> employeeResponses = employeeService.getEmployees(pageRequest);

        PageResponse<List<EmployeeResponse>> pageResponse = PageResponse.<List<EmployeeResponse>>builder()
                .data(employeeResponses.getContent())
                .number(employeeResponses.getNumber() + 1)
                .size(employeeResponses.getSize())
                .totalPages(employeeResponses.getTotalElements())
                .hasPrevious(employeeResponses.hasPrevious())
                .hasNext(employeeResponses.hasNext())
                .build();



        return AppResponse.<PageResponse<List<EmployeeResponse>>>builder()
                .status(HttpStatus.OK.getReasonPhrase())
                .message("Get employee")
                .data(pageResponse)
                .build();
    }

    @PutMapping(path = "/{id}")
    public AppResponse<EmployeeResponse> updateEmployee(@PathVariable UUID id, @RequestBody EmployeeRequest employeeRequest) {
        EmployeeResponse employeeResponse = employeeService.updateEmployee(id, employeeRequest);

        return AppResponse.<EmployeeResponse>builder()
                .status(HttpStatus.OK.getReasonPhrase())
                .message("Employee Updated")
                .data(employeeResponse)
                .build();
    }


    @GetMapping(path = "/{id}")
    public AppResponse<EmployeeResponse> getEmployee(@PathVariable UUID id) {
        EmployeeResponse employeeResponse = employeeService.getEmployee(id);

        return AppResponse.<EmployeeResponse>builder()
                .status(HttpStatus.OK.getReasonPhrase())
                .message("Get employee")
                .data(employeeResponse)
                .build();
    }

    @DeleteMapping(path = "/{id}")
    public AppResponse<Void> deleteEmployee(@PathVariable UUID id) {
        employeeService.deleteEmployee(id);

        return AppResponse.<Void>builder()
                .status(HttpStatus.OK.getReasonPhrase())
                .message("Delete employee")
                .data(null)
                .build();
    }

}
