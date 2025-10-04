CREATE TABLE attendance
(
    id              UUID      NOT NULL,
    created_at      TIMESTAMP NOT NULL,
    updated_at      TIMESTAMP NOT NULL,
    employee_id     UUID,
    attendance_date date,
    status          VARCHAR(255),
    CONSTRAINT pk_attendance PRIMARY KEY (id)
);

CREATE TABLE employee
(
    id         UUID      NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    user_name  VARCHAR(255),
    first_name VARCHAR(255),
    last_name  VARCHAR(255),
    role       VARCHAR(255),
    CONSTRAINT pk_employee PRIMARY KEY (id)
);

ALTER TABLE attendance
    ADD CONSTRAINT FK_ATTENDANCE_ON_EMPLOYEE FOREIGN KEY (employee_id) REFERENCES employee (id);