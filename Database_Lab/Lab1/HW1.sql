USE master
IF EXISTS (SELECT*FROM sys.databases WHERE name = 'University')
	DROP DATABASE University;
CREATE DATABASE University;
USE University

create TABLE Departments(
Name varchar(20) NoT Null,
ID char (5) PRIMARY KEY,
Budget numeric (12,2),
category varchar(15) check (category in ('Engineering','Science'))
);

create TABLE Teachers(
FirstName varchar(20) NoT Null,
LastName varchar(30) Not Null,
ID char(7) PRIMARY KEY,
BirthYear int,
DepartmentID char(5),
salary numeric(9,2) Default 10000.00,
FOREIGN KEY (DepartmentID) REFERENCES Departments(ID),
);

create table Student(
FirstName varchar(20) NoT Null,
LastName varchar(30) Not Null,
StudentNumber char(7) PRIMARY KEY,
BirthYear int,
DepartmentID char(5),
AdvisorID char(7),
FOREIGN KEY (DepartmentID) REFERENCES Departments(ID),
FOREIGN KEY (AdvisorID) REFERENCES Teachers(ID),
);

create TABLE Courses(
ID char(7) PRIMARY KEY,
Title varchar(30),
Credits int,
DepartmentID char(5),
FOREIGN KEY (DepartmentID) REFERENCES Departments(ID),
);

create TABLE Available_Courses(
CourseID char(7) PRIMARY KEY,
Semester varchar(10) check (Semester in ('fall','spring')),
year int,
ID char(7) ,
TeacherID char (7),
FOREIGN KEY (TeacherID) REFERENCES Teachers(ID),
FOREIGN KEY (CourseID) REFERENCES Courses(ID)
);

create TABLE Taken_Courses(
StudentID char(7) PRIMARY KEY,   
CourseID char(7),
Semester varchar(10),
year int,
Grade int,
FOREIGN KEY (CourseID) REFERENCES Available_Courses(CourseID),
FOREIGN KEY (StudentID) REFERENCES Student(StudentNumber)
);

create TABLE Prerequisites(
CourseId char(7) PRIMARY KEY,
PrereqID char(7),
FOREIGN KEY (CourseId) REFERENCES Available_Courses(CourseID),
FOREIGN KEY (PrereqID) REFERENCES Courses(ID),
);

AlTER TABLE Student
	ADD Units int;

insert into Departments(Name,ID,Budget,category) Values ('computer Engineering','CE',150000000.00,'Engineering');
insert into Departments(Name,ID,Budget,category) Values ('physics','p',1300000.00,'Science');
insert into Teachers(FirstName,LastName,ID,BirthYear,DepartmentID,salary) Values ('Alireza','Basiri','123456',1360,'CE',150000.00);
insert into Teachers(FirstName,LastName,ID,BirthYear,DepartmentID,salary) Values ('Zeinab','Zali','145632',1365,'CE',180000.00);
insert into Student(FirstName,LastName,StudentNumber,BirthYear,DepartmentID,AdvisorID,Units) Values ('hoori','dahesh','123',1379,'CE','123456',100);
insert into Student(FirstName,LastName,StudentNumber,BirthYear,DepartmentID,AdvisorID,Units) Values ('hoori1','dahesh2','9821444',1380,'CE','145632',120);
insert into Courses(ID,Title,Credits,DepartmentID) Values ('1245789','computer',4,'CE');
insert into Courses(ID,Title,Credits,DepartmentID) Values ('1456897','DataBase',3,'CE');
insert into Available_Courses(CourseID,Semester,year,ID,TeacherID) Values ('1245789','fall',1400,'1','123456');
insert into Available_Courses(CourseID,Semester,year,ID,TeacherID) Values ('1456897','fall',1401,'2','145632');
insert into Taken_Courses(StudentID,CourseID,Semester,year,Grade) Values ('123','1245789','fall',1401,18);
insert into Taken_Courses(StudentID,CourseID,Semester,year,Grade) Values ('9821444','1456897','spring',1399,16);
insert into Prerequisites(CourseId,PrereqID) Values ('1245789','1245789');
--insert into Prerequisites(CourseId,PrereqID) Values ('4443331','1456897');

select Name,ID,Budget,category from Student inner join Departments on ( Student.DepartmentID=Departments.ID) where (Student.StudentNumber='123');
select Grade+1 from Student inner join Taken_Courses on (Student.StudentNumber=Taken_Courses.StudentID);
select FirstName,LastName,StudentNumber,BirthYear,DepartmentID,AdvisorID,Units from Student left join Taken_Courses on (Student.StudentNumber=Taken_Courses.StudentID) where (Taken_Courses.CourseID<>'DB');







