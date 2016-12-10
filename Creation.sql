DROP DATABASE IF EXISTS CMS;
CREATE DATABASE CMS;
USE CMS;
-- Student table
CREATE TABLE Students (
  s_id          INT         NOT NULL AUTO_INCREMENT PRIMARY KEY,
  dep_name      VARCHAR(50) NOT NULL,
  full_name     VARCHAR(50),
  date_of_birth DATE,
  phone         VARCHAR(20),
  email         VARCHAR(50),
  gpa           FLOAT
);

-- Departments table
CREATE TABLE Departments (
  dep_name  VARCHAR(40) NOT NULL PRIMARY KEY,
  headed_by INT         NOT NULL
);

-- Alter Departments table to add department FK
ALTER TABLE Students
  ADD FOREIGN KEY (dep_name) REFERENCES Departments (dep_name)
  ON UPDATE CASCADE
  ON DELETE RESTRICT;

-- Instructors table
CREATE TABLE Instructors (
  ins_id    INT         NOT NULL AUTO_INCREMENT PRIMARY KEY,
  dep_name  VARCHAR(50) NOT NULL,
  full_name VARCHAR(50),
  phone     VARCHAR(20),
  email     VARCHAR(50),
  FOREIGN KEY (dep_name) REFERENCES Departments (dep_name)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

-- Alter Departments table to add headed_by FK
ALTER TABLE Departments
  ADD FOREIGN KEY (headed_by) REFERENCES Instructors (ins_id)
  ON UPDATE CASCADE
  ON DELETE RESTRICT;

-- Course table
CREATE TABLE Courses (
  c_id         VARCHAR(10) NOT NULL PRIMARY KEY,
  dep_name     VARCHAR(50) NOT NULL,
  name         VARCHAR(50) NOT NULL,
  credit_hours INT         NOT NULL,
  FOREIGN KEY (dep_name) REFERENCES Departments (dep_name)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

-- Courses offerings table
CREATE TABLE CourseOfferings (
  c_id    VARCHAR(10) NOT NULL,
  semster VARCHAR(10) NOT NULL,
  PRIMARY KEY (c_id, semster),
  FOREIGN KEY (c_id) REFERENCES Courses (c_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

-- Courses offerings hours table
-- I think we need unique index on day,start_time,c_id,semseter in order not to have two lectures for the same course running at the same time.
CREATE TABLE Hours (
  c_id       VARCHAR(10) NOT NULL,
  semster    VARCHAR(10) NOT NULL,
  room       VARCHAR(10) NOT NULL,
  day        ENUM('saturday','sunday','monday','tuesday','wednesday','thursday','friday')         NOT NULL, #This represents day of week
  start_time TIME        NOT NULL,
  end_time   TIME        NOT NULL,
  PRIMARY KEY (semster, room, day, start_time), # removed c_id from PK, as it's not needed also to prevent adding unique index on the rest of the componenets to provide having 2 courses in the same room at the same time
  FOREIGN KEY (c_id, semster) REFERENCES CourseOfferings (c_id, semster)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

-- Enrolls table, a table to indicate which student enrolled at which course offering
CREATE TABLE Enrolls (
  s_id    INT         NOT NULL,
  c_id    VARCHAR(10) NOT NULL,
  semster VARCHAR(10) NOT NULL,
  grade int ,
  PRIMARY KEY (semster, c_id, s_id),
  FOREIGN KEY (c_id, semster) REFERENCES CourseOfferings (c_id, semster)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  FOREIGN KEY (s_id) REFERENCES Students (s_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT

);

-- Teaches table, a table to indicate which instructor teaches which course offering
CREATE TABLE Teaches (
  ins_id    INT         NOT NULL,
  c_id    VARCHAR(10) NOT NULL,
  semster VARCHAR(10) NOT NULL,
  PRIMARY KEY (semster, c_id, ins_id),
  FOREIGN KEY (c_id, semster) REFERENCES CourseOfferings (c_id, semster)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  FOREIGN KEY (ins_id) REFERENCES Instructors(ins_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT

)

