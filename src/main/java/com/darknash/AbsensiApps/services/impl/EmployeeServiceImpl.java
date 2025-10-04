package com.darknash.AbsensiApps.services.impl;

import com.darknash.AbsensiApps.dtos.EmployeeRequest;
import com.darknash.AbsensiApps.dtos.EmployeeResponse;
import com.darknash.AbsensiApps.entities.Employee;
import com.darknash.AbsensiApps.repositories.EmployeeRepository;
import com.darknash.AbsensiApps.services.EmployeeService;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class EmployeeServiceImpl implements EmployeeService {
    private final EmployeeRepository employeeRepository;


    @Override
    public EmployeeResponse createEmployee(EmployeeRequest request) {

        Employee employee = new Employee();
        employee.setFirstName(request.getFirstName());
        employee.setLastName(request.getLastName());
        employee.setUserName(request.getUsername());
        employee.setRole(request.getRole());
        Employee savedEmployee = employeeRepository.saveAndFlush(employee);

        return toEmployeeResponse(savedEmployee);
    }

    @Override
    public EmployeeResponse updateEmployee(UUID id, EmployeeRequest request) {
        Employee employee = getEmployeeEntity(id);
        employee.setFirstName(request.getFirstName());
        employee.setLastName(request.getLastName());
        employee.setUserName(request.getUsername());
        employee.setRole(request.getRole());
        Employee savedEmployee = employeeRepository.saveAndFlush(employee);

        return toEmployeeResponse(savedEmployee);
    }

    @Override
    public void deleteEmployee(UUID id) {
        employeeRepository.deleteById(id);
    }

    @Override
    public EmployeeResponse getEmployee(UUID id) {
        Employee employee = getEmployeeEntity(id);
        return toEmployeeResponse(employee);
    }

    @Override
    public Page<EmployeeResponse> getEmployees(PageRequest pageRequest) {
        Page<Employee> employees = employeeRepository.findAll(pageRequest);
        return employees.map(this::toEmployeeResponse);
    }


    private EmployeeResponse toEmployeeResponse(Employee employee) {
        return EmployeeResponse.builder()
                .id(employee.getId())
                .firstName(employee.getFirstName())
                .lastName(employee.getLastName())
                .username(employee.getUserName())
                .role(employee.getRole())
                .createdDate(employee.getCreatedDate())
                .updatedDate(employee.getUpdatedDate())
                .build();
    }

    @Override
    public Employee getEmployeeEntity(UUID id) {
        return employeeRepository.findById(id)
                .orElseThrow(()-> new EntityNotFoundException("Employee not found with id: " + id));
    }
}
