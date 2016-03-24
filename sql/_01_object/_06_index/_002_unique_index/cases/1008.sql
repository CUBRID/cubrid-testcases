-- create and  insert/update/delete/select data and using index when select

create class ddl_0001(col1 int, col2 string, col3 char(10), col4 varchar(10));

SELECT * FROM ddl_0001 order by 1;
INSERT INTO ddl_0001 VALUES (1,'a','a','a');

INSERT INTO ddl_0001 VALUES (2,'a','a','a');


UPDATE ddl_0001 set col1=3 WHERE col1=1;

DELETE FROM ddl_0001;

create Unique  index ddl_0001_index on ddl_0001(col1);

SELECT * FROM ddl_0001 USING INDEX ddl_0001_index order by 1;
INSERT INTO ddl_0001 VALUES (null,'a','a','a');

INSERT INTO ddl_0001 VALUES (2,'a','a','a');


UPDATE ddl_0001 set col1=3 WHERE col1=1;
DELETE FROM ddl_0001;

drop class ddl_0001;
rollback;
rollback;
