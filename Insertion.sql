use CMS;
-- Truncate all the tables, a trick to run the script multiple times without complaining about the uniqueness of PKs

DROP PROCEDURE IF EXISTS reset_database;
CREATE  DEFINER=`root`@`localhost`   PROCEDURE `reset_database`(DB_NAME VARCHAR(100))
BEGIN
DECLARE done INT DEFAULT FALSE;
DECLARE tableName VARCHAR(100);
DECLARE cur CURSOR FOR SELECT table_name FROM INFORMATION_SCHEMA.tables WHERE table_schema = DB_NAME AND table_type = 'BASE TABLE';
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

OPEN cur;

SET FOREIGN_KEY_CHECKS = 0;
read_loop: LOOP
FETCH cur INTO tableName;
  IF done THEN LEAVE read_loop; END IF;
  SET @s = CONCAT('truncate table ',tableName);
  PREPARE stmt1 FROM @s;
  EXECUTE stmt1;
  DEALLOCATE PREPARE stmt1;
END LOOP;
SET FOREIGN_KEY_CHECKS = 1;

CLOSE cur;
END;

CALL reset_database('CMS');

-- As there is circular FK dependency between departments and Instructors, we have to disable the FK check
set FOREIGN_KEY_CHECKS =0;
INSERT INTO Instructors (dep_name, full_name, phone, email) VALUES ('Computer Engineering','Shady Atef Badran','01001111212','shady@eng.uni.eg');

INSERT INTO Departments VALUES ('Computer Engineering',LAST_INSERT_ID());

INSERT INTO Instructors (dep_name, full_name, phone, email) VALUES ('Mechanical Engineering','Veronia Bahaa ','01001111256','v.bahaa@eng.uni.eg');

INSERT INTO Departments VALUES ('Mechanical Engineering',LAST_INSERT_ID());


set FOREIGN_KEY_CHECKS  =1;

-- Insert more Instructors

INSERT INTO Instructors (dep_name, full_name, phone, email) VALUES ('Mechanical Engineering','Ahmed Alaa','01001111289','a.alaa@eng.uni.eg');
INSERT INTO Instructors (dep_name, full_name, phone, email) VALUES ('Mechanical Engineering','Mohamed Khaled Bahaa ','01081111256','m.bahaa@eng.uni.eg');

INSERT INTO Instructors (dep_name, full_name, phone, email) VALUES ('Computer Engineering','Abdullah El-Shemey','01001185256','a.shemey@eng.uni.eg');
INSERT INTO Instructors (dep_name, full_name, phone, email) VALUES ('Computer Engineering','Mohammed Mounir ','01801111256','m.mounir@eng.uni.eg');


-- Insert a few students

INSERT INTO Students (dep_name, full_name, date_of_birth, phone, email, gpa) VALUES ('Mechanical Engineering','Shady Atef','1994-10-26','010011223344','s.atef.stud@eng.uni.eg',2);
INSERT INTO Students (dep_name, full_name, date_of_birth, phone, email, gpa) VALUES ('Mechanical Engineering','Ahmed Atef','1994-10-26','010011223345','a.atef.stud@eng.uni.eg',2.5);

INSERT INTO Students (dep_name, full_name, date_of_birth, phone, email, gpa) VALUES ('Computer Engineering','Khaled Atef','1994-10-26','010011223346','k.atef.stud@eng.uni.eg',2.7);
INSERT INTO Students (dep_name, full_name, date_of_birth, phone, email, gpa) VALUES ('Computer Engineering','Ahmed Khaled','1994-10-26','010011223346','a.khaled.stud@eng.uni.eg',2.7);


-- Insert few courses
INSERT INTO Courses (c_id, dep_name, name, credit_hours) VALUES ('CSE450','Computer Engineering','Intro to Databases',3);
INSERT INTO Courses (c_id, dep_name, name, credit_hours) VALUES ('CSE451','Computer Engineering','Computer Vision',3);
INSERT INTO Courses (c_id, dep_name, name, credit_hours) VALUES ('MEC350','Mechanical Engineering','Thermodynamics of fluids',3);


-- Insert few courses offering
INSERT INTO CourseOfferings (c_id, semster) VALUES ('CSE450','2016');
INSERT INTO CourseOfferings (c_id, semster) VALUES ('CSE451','2016');
INSERT INTO CourseOfferings (c_id, semster) VALUES ('MEC350','2016');

-- Insert two hours for each courses offering
INSERT INTO Hours (c_id, semster, room, day, start_time, end_time)  VALUES ('CSE450','2016','319','saturday','08:30','10:00');
INSERT INTO Hours (c_id, semster, room, day, start_time, end_time)  VALUES ('CSE450','2016','319','thursday','10:10','11:40');
INSERT INTO Hours (c_id, semster, room, day, start_time, end_time)  VALUES ('CSE451','2016','344','saturday','14:00','15:30');
INSERT INTO Hours (c_id, semster, room, day, start_time, end_time)  VALUES ('CSE451','2016','319','saturday','10:10','11:40');
INSERT INTO Hours (c_id, semster, room, day, start_time, end_time)  VALUES ('MEC350','2016','260A','sunday','08:30','10:00');
INSERT INTO Hours (c_id, semster, room, day, start_time, end_time)  VALUES ('MEC350','2016','Hall a','monday','10:10','11:40');


-- Insert instructions - courses offering association
INSERT INTO Teaches (ins_id, c_id, semster) VALUES ((SELECT ins_id from Instructors WHERE dep_name ='Mechanical Engineering' ORDER BY RAND() LIMIT  1),'MEC350','2016');
INSERT INTO Teaches (ins_id, c_id, semster) VALUES ((SELECT ins_id from Instructors WHERE dep_name ='Computer Engineering' ORDER BY RAND() LIMIT  1),'CSE450','2016');
INSERT INTO Teaches (ins_id, c_id, semster) VALUES ((SELECT ins_id from Instructors WHERE dep_name ='Computer Engineering' ORDER BY RAND() LIMIT  1),'CSE450','2016');
INSERT INTO Teaches (ins_id, c_id, semster) VALUES ((SELECT ins_id from Instructors WHERE dep_name ='Computer Engineering' ORDER BY RAND() LIMIT  1),'CSE451','2016');

-- Insert student  - enroll
INSERT INTO Enrolls (s_id, c_id, semster) VALUES (1,'MEC350','2016');
INSERT INTO Enrolls (s_id, c_id, semster) VALUES (2,'CSE450','2016');
INSERT INTO Enrolls (s_id, c_id, semster) VALUES (3,'CSE450','2016');
INSERT INTO Enrolls (s_id, c_id, semster) VALUES (2,'CSE451','2016');
