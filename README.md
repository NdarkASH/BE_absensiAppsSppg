📘 Absensi Apps API Documentation
Info

Title: OpenAPI definition

Version: v0

Server URL: http://localhost:8080

👤 Employee API
Get Employee by ID

GET /employee/{id}

Parameters

id (path, string, uuid, required)

Response

200 OK → AppResponseEmployeeResponse

Update Employee

PUT /employee/{id}

Parameters

id (path, string, uuid, required)

Request Body

{
  "username": "string",
  "firstName": "string",
  "lastName": "string",
  "role": "CUCI | PERSIAPAN | SATPAM | PEMORSIAN | MASAK | AKUNTAN | GIZI | DISTRIBUTOR | ASLAP"
}


Response

200 OK → AppResponseEmployeeResponse

Delete Employee

DELETE /employee/{id}

Parameters

id (path, string, uuid, required)

Response

200 OK → AppResponseVoid

Get All Employees (Paginated)

GET /employee

Parameters

page (query, integer, default=0)

size (query, integer, default=10)

Response

200 OK → AppResponsePageResponseListEmployeeResponse

Create Employee

POST /employee

Request Body

{
  "username": "string",
  "firstName": "string",
  "lastName": "string",
  "role": "CUCI"
}


Response

200 OK → AppResponseEmployeeResponse

🕒 Attendance API
Get Attendance by ID

GET /attendance/{id}

Parameters

id (path, string, uuid, required)

Response

200 OK → AppResponseAttendanceResponse

Update Attendance

PUT /attendance/{id}

Parameters

id (path, string, uuid, required)

Request Body

{
  "employeeId": ["uuid"],
  "attendanceDate": "2024-09-01",
  "status": "ABSEN"
}


Response

200 OK → AppResponseAttendanceResponse

Delete Attendance

DELETE /attendance/{id}

Parameters

id (path, string, uuid, required)

Response

200 OK → AppResponseVoid

Get All Attendance (Paginated)

GET /attendance

Parameters

page (query, integer, default=0)

size (query, integer, default=10)

Response

200 OK → AppResponsePageResponseListAttendanceResponse

Create Attendance

POST /attendance

Request Body

{
  "employeeId": ["uuid"],
  "attendanceDate": "2024-09-01",
  "status": "IZIN"
}


Response

200 OK → AppResponseListAttendanceResponse

Search Attendance by Date Range

GET /attendance/search

Parameters

startDate (query, string, date)

endDate (query, string, date)

size (query, integer, default=10)

page (query, integer, default=0)

ascending (query, boolean)

Response

200 OK → AppResponsePageResponseListAttendanceResponse

📦 Schemas
EmployeeRequest
{
  "username": "string",
  "firstName": "string",
  "lastName": "string",
  "role": "CUCI | PERSIAPAN | SATPAM | PEMORSIAN | MASAK | AKUNTAN | GIZI | DISTRIBUTOR | ASLAP"
}

EmployeeResponse
{
  "id": "uuid",
  "username": "string",
  "firstName": "string",
  "lastName": "string",
  "role": "enum",
  "createdDate": "date-time",
  "updatedDate": "date-time"
}

AttendanceRequest
{
  "employeeId": ["uuid"],
  "attendanceDate": "date",
  "status": "ALFA | IZIN | SAKIT | ABSEN"
}

AttendanceResponse
{
  "id": "uuid",
  "attendanceDate": "date",
  "status": "enum",
  "employees": { ...EmployeeResponse },
  "createdDate": "date-time",
  "updatedDate": "date-time"
}

AppResponseEmployeeResponse
{
  "message": "string",
  "status": "string",
  "data": { ...EmployeeResponse }
}

AppResponseAttendanceResponse
{
  "message": "string",
  "status": "string",
  "data": { ...AttendanceResponse }
}

AppResponseListAttendanceResponse
{
  "message": "string",
  "status": "string",
  "data": [ ...AttendanceResponse ]
}

AppResponsePageResponseListEmployeeResponse
{
  "message": "string",
  "status": "string",
  "data": {
    "data": [ ...EmployeeResponse ],
    "number": 0,
    "size": 10,
    "totalPages": 1,
    "hasNext": true,
    "hasPrevious": false
  }
}

AppResponsePageResponseListAttendanceResponse
{
  "message": "string",
  "status": "string",
  "data": {
    "data": [ ...AttendanceResponse ],
    "number": 0,
    "size": 10,
    "totalPages": 1,
    "hasNext": true,
    "hasPrevious": false
  }
}

AppResponseVoid
{
  "message": "string",
  "status": "string",
  "data": {}
}
