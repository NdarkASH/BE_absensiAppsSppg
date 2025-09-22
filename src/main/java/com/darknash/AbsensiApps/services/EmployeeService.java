package com.darknash.AbsensiApps.services;

import com.darknash.AbsensiApps.dtos.EmployeeRequest;
import com.darknash.AbsensiApps.dtos.EmployeeResponse;
import com.darknash.AbsensiApps.entities.Employee;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;

import java.util.UUID;

public interface EmployeeService {

    EmployeeResponse createEmployee(EmployeeRequest request);
    EmployeeResponse updateEmployee(UUID id, EmployeeRequest request);
    void deleteEmployee(UUID id);
    EmployeeResponse getEmployee(UUID id);
    Page<EmployeeResponse> getEmployees(PageRequest pageRequest);
    Employee getEmployeeEntity(UUID id);

}
