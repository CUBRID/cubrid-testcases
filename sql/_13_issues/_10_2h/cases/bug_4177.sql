CREATE TABLE tree(ID INT, MgrID INT, Name VARCHAR(32));
INSERT INTO tree VALUES (1,NULL,'Kim');
INSERT INTO tree VALUES (2,NULL,'Moy');
INSERT INTO tree VALUES (3,1,'Jonas');
INSERT INTO tree VALUES (4,1,'Smith');
INSERT INTO tree VALUES (5,2,'Verma');
INSERT INTO tree VALUES (6,2,'Foster');
INSERT INTO tree VALUES (7,6,'Brown');

select id,mgrid,name
from (
select id,mgrid,name from tree
) t
where id <>1
start with id =1
connect by prior id=mgrid;

drop table tree;
