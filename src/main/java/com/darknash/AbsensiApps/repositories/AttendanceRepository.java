package com.darknash.AbsensiApps.repositories;

import com.darknash.AbsensiApps.entities.Attendance;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.UUID;

@Repository
public interface AttendanceRepository extends JpaRepository<Attendance, UUID> {


    @Query("""
        SELECT a FROM Attendance a
        WHERE (:startDate IS NULL OR a.attendanceDate >= :startDate)
        AND (:endDate IS NULL OR a.attendanceDate <= :endDate)
""")
    Page<Attendance> searchAttendanceByAttendanceDate(
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate,
            Pageable pageable
    );

}
