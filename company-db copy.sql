/*
  Zoe Rochelle
  Assignment 2 - DDL
  Database Systems
  Dr. J
  11/05/2025
*/


/* Solutions to questions */

    -- Q4 Part c.
        SELECT Fname, Minit, Lname
        FROM EMPLOYEE
        WHERE SALARY >= (
            SELECT Salary
            FROM EMPLOYEE
            ORDER BY Salary ASC
            LIMIT 1
        ) + 10000;


    -- Q5 Part e.
        -- Determine the Projects that cost more than $25,000 per year to fund
          -- Assume that cost is only determined by Employee salaries
          -- Assume that Hours in WORKS_ON are in weeks

        -- 3.) This SELECT will Group each project, and SUM the annual costs per project
        SELECT Pname, SUM(Emp_salary_per_project) as proj_cost
        FROM (
            -- 2.) This SELECT will give us the Employee's ANNUAL salary dedicated to each project
            SELECT
                Pno, (Hours * Salary_per_wk) AS Emp_salary_per_project
            FROM (
                -- 1.) This SELECT will give us the WEEKLY Employee salary, for each project that they work on.
                SELECT Pno, Hours,
                CASE
                    WHEN Salary Then CAST(Salary/52 AS DECIMAL(10,2)) -- 52 weeks in a year
                END AS Salary_per_wk
                From EMPLOYEE E
                JOIN WORKS_ON WO
                ON E.Ssn=WO.Essn
                Order by Pno
            ) AS T1
        ) AS T2
        JOIN PROJECT P
        ON T2.Pno = P.Pnumber
        GROUP BY Pno
        HAVING proj_cost > 25000
        ORDER BY proj_cost DESC;


/***********************/
/* Create the Database */
/***********************/

/* create all of our necessary tables */
CREATE TABLE EMPLOYEE( 
    Fname VARCHAR(255),
    Minit CHAR(1),
    Lname VARCHAR(255),
    Ssn CHAR(9) NOT NULL,
    Bdate DATE,
    Address VARCHAR(255),
    Sex CHAR(1),
    Salary DECIMAL(10, 2),
    Super_ssn CHAR(9) NULL,
    Dno INT NOT NULL
); 

CREATE TABLE DEPARTMENT( 
    Dname VARCHAR(255),
    Dnumber INT NOT NULL,
    Mgr_ssn CHAR(9) NULL,
    Mgr_start_date DATE
); 

CREATE TABLE DEPT_LOCATIONS( 
    Dnumber INT NOT NULL,
    Dlocation VARCHAR(255) NOT NULL
); 

CREATE TABLE PROJECT( 
    Pname VARCHAR(255),
    Pnumber INT NOT NULL,
    Plocation VARCHAR(255),
    Dnum INT
); 

CREATE TABLE WORKS_ON( 
    Essn CHAR(9) NOT NULL,
    Pno INT NOT NULL,
    Hours DECIMAL(10, 2) -- (digits, precision)
); 

CREATE TABLE DEPENDENT( 
    Essn CHAR(9) NOT NULL,
    Dependent_name VARCHAR(255) NOT NULL,
    Sex CHAR(1),
    Bdate DATE,
    Relationship VARCHAR(255)
);

/* alter each tables schema */
ALTER TABLE EMPLOYEE
  ADD PRIMARY KEY (Ssn);
ALTER TABLE EMPLOYEE
  ADD CONSTRAINT fk_employee_employee_super_ssn
    FOREIGN KEY (Super_ssn) REFERENCES EMPLOYEE(Ssn)
      ON UPDATE RESTRICT ON DELETE SET NULL;

ALTER TABLE DEPARTMENT
  ADD PRIMARY KEY (Dnumber),
  ADD CONSTRAINT fk_department_employee_mgr_ssn
    FOREIGN KEY (Mgr_ssn) REFERENCES EMPLOYEE(Ssn)
      ON UPDATE RESTRICT ON DELETE SET NULL;

/* run this one after altering the DEPARTMENT table */
ALTER TABLE EMPLOYEE
  ADD CONSTRAINT fk_employee_department_dno
    FOREIGN KEY (Dno) REFERENCES DEPARTMENT(Dnumber)
      ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE DEPT_LOCATIONS
  ADD PRIMARY KEY (Dnumber, Dlocation),
  ADD CONSTRAINT fk_dept_locations_department_dnumber
    FOREIGN KEY (Dnumber) REFERENCES DEPARTMENT(Dnumber)
      ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE PROJECT
  ADD PRIMARY KEY (Pnumber),
  ADD CONSTRAINT fk_project_department_dnumber
    FOREIGN KEY (Dnum) REFERENCES DEPARTMENT(Dnumber)
      ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE WORKS_ON
  ADD PRIMARY KEY (Essn, Pno),
  ADD CONSTRAINT fk_works_on_employee_ssn
    FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn)
      ON UPDATE RESTRICT ON DELETE RESTRICT,
  ADD CONSTRAINT fk_works_on_project_pnumber
    FOREIGN KEY (Pno) REFERENCES PROJECT(Pnumber)
      ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE DEPENDENT
  ADD PRIMARY KEY (Essn, Dependent_name),
  ADD CONSTRAINT fk_dependent_employee_ssn
    FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn)
      ON UPDATE RESTRICT ON DELETE RESTRICT;

/* Insert the test data */
-- there were some dependancy conflicts here
-- so I had to insert the rows in a specific way

-- set the managers to NULL for now
INSERT INTO DEPARTMENT VALUES
('Research', 5, NULL, '1988-05-22'),
('Administration', 4, NULL, '1995-01-01'),
('Headquarters', 1, NULL, '1981-06-19');

-- need to insert the employees in the order of supervisers, bosses go first
INSERT INTO EMPLOYEE VALUES
('James','E','Borg','888665555','1937-11-10','450 Stone, Houston, TX','M', 55000, NULL, 1),
('Franklin','T','Wong','333445555','1955-12-08','638 Voss, Houston, TX','M', 40000,'888665555', 5),
('Jennifer','S','Wallace','987654321','1941-06-20','291 Berry, Bellaire, TX','F', 43000,'888665555', 4);

-- update the department table with the new managers we just added
UPDATE DEPARTMENT
SET Mgr_ssn = '888665555' WHERE Dnumber = 1;
UPDATE DEPARTMENT
SET Mgr_ssn = '333445555' WHERE Dnumber = 5;
UPDATE DEPARTMENT
SET Mgr_ssn = '987654321' WHERE Dnumber = 4;

-- add the rest of the employees
INSERT INTO EMPLOYEE VALUES
('John','B','Smith','123456789','1965-01-09','731 Fondren, Houston, TX','M', 30000,'333445555', 5),
('Alicia','J','Zelaya','999887777','1968-01-19','3321 Castle, Spring, TX','F', 25000,'987654321', 4),
('Ramesh','K','Narayan','666884444','1962-09-15','975 Fire Oak, Humble, TX','M', 38000,'333445555', 5),
('Joyce','A','English','453453453','1972-07-31','5631 Rice, Houston, TX','F', 25000,'333445555', 5),
('Ahmad','V','Jabbar','987987987','1969-03-29','980 Dallas, Houston, TX','M', 25000,'987654321', 4);

-- insert the rest as normal
INSERT INTO DEPT_LOCATIONS VALUES
(1, 'Houston'),
(4, 'Stafford'),
(5, 'Bellaire'),
(5, 'Sugarland'),
(5, 'Houston');

INSERT INTO PROJECT VALUES
('ProductX', 1, 'Bellaire', 5),
('ProductY', 2, 'Sugarland', 5),
('ProductZ', 3, 'Houston', 5),
('Computerization', 10, 'Stafford', 4),
('Reorganization', 20, 'Houston', 1),
('Newbenefits', 30, 'Stafford', 4);

INSERT INTO WORKS_ON VALUES
('123456789', 1, 32.5),
('123456789', 2, 7.5),
('666884444', 3, 40.0),
('453453453', 1, 20.0),
('453453453', 2, 20.0),
('333445555', 2, 10.0),
('333445555', 3, 10.0),
('333445555', 10, 10.0),
('333445555', 20, 10.0),
('999887777', 30, 30.0),
('999887777', 10, 10.0),
('987987987', 10, 35.0),
('987987987', 30, 5.0),
('987654321', 30, 20.0),
('987654321', 20, 15.0),
('888665555', 20, NULL);

INSERT INTO DEPENDENT VALUES
('333445555', 'Alice',     'F', '1986-04-05', 'Daughter'),
('333445555', 'Theodore',  'M', '1983-10-25', 'Son'),
('333445555', 'Joy',       'F', '1958-05-03', 'Spouse'),
('987654321', 'Abner',     'M', '1942-02-28', 'Spouse'),
('123456789', 'Michael',   'M', '1988-01-04', 'Son'),
('123456789', 'Alice',     'F', '1988-12-30', 'Daughter'),
('123456789', 'Elizabeth', 'F', '1967-05-05', 'Spouse');
