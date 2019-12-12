--Test join with common class

CREATE class departments
(
 depID  integer,
 depName VARCHAR(20),
 delFlag integer
);

CREATE class employees
(
 empID  integer,
 empName VARCHAR(20),
 depID  integer,
 delFlag integer
);
INSERT INTO departments VALUES(1,'Finacle',0);
INSERT INTO departments VALUES(2,'Marketing',0);
INSERT INTO departments VALUES(3,'HR',1);
INSERT INTO departments VALUES(4,'IT',0);
INSERT INTO employees VALUES(1,'wbq',1,0);
INSERT INTO employees VALUES(2,'czh',2,0);
INSERT INTO employees VALUES(3,'chh',1,0);
INSERT INTO employees VALUES(4,'wal',2,0);
INSERT INTO employees VALUES(5,'ddd',3,0);

SELECT d.depID,d.depName,e.empName
 FROM departments d
 LEFT OUTER JOIN employees e
   ON d.depID = e.depID
 WHERE d.depID =3
 ORDER BY d.depID;
 
 
 drop class departments;
 drop class employees;



