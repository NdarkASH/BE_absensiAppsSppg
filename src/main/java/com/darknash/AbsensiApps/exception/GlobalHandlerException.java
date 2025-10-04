package com.darknash.AbsensiApps.exception;


import com.darknash.AbsensiApps.dtos.AppResponse;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalHandlerException {


    @ExceptionHandler(EntityNotFoundException.class)
    public ResponseEntity<AppResponse<String>> handleEntityNotFoundException(EntityNotFoundException e) {

        AppResponse<String> appResponse = new AppResponse<>();
        appResponse.setMessage(e.getCause().getMessage());
        appResponse.setStatus(HttpStatus.NOT_FOUND.getReasonPhrase());
        appResponse.setData(e.getMessage());

        return new ResponseEntity<>(appResponse, HttpStatus.NOT_FOUND);
    }
}
