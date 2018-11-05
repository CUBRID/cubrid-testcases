-- create class on all type and create reverse index on bit type and insert/update/delete/select data


create class t1(
col1 int, 
col2 string, 
col3 char(10), 
col4 varchar(10), 
col5 FLOAT,
col6 SMALLINT,
col7 DOUBLE,
col8 DATE,
col9 TIME,
col10 TIMESTAMP,
col11 SET,
col12 MULTISET,
col13 SEQUENCE,
col14 bit(20) );

create reverse index t1_index on t1(col14) with online;

SELECT * FROM db_index WHERE class_name='t1' order by 1,2;

INSERT INTO t1 VALUES (1,'string1','a','aaa',10,10,10, '05/26/2008', '14:24:00', '14:24:00 05/26/2008',{'a'},{'a'},{'a'},B'1');
INSERT INTO t1 VALUES (null,'string1','a','aaa',10,10,10, '05/26/2008', '14:24:00', '14:24:00 05/26/2008',{'a'},{'a'},{'a'},null);
INSERT INTO t1 VALUES (2,'string1','a','aaa',10,10,10, '05/26/2008', '14:24:00', '14:24:00 05/26/2008',{'a'},{'a'},{'a'},B'0010101');
INSERT INTO t1 VALUES (1,'string1','a','aaa',10,10,10, '05/26/2008', '14:24:00', '14:24:00 05/26/2008',{'a'},{'a'},{'a'},B'010101');
INSERT INTO t1 VALUES (3,'string1','a','aaa',10,10,10, '05/26/2008', '14:24:00', '14:24:00 05/26/2008',{'a'},{'a'},{'a'},B'0101');

UPDATE t1 SET col14=B'0011' WHERE col1=3;

DELETE  FROM t1 WHERE col1=2;

SELECT * FROM t1 USING INDEX t1_index order by 1,2,3,4,5,6,7,8,9,10,11,12,13,14;

drop class t1;
rollback;
rollback;
rollback;
