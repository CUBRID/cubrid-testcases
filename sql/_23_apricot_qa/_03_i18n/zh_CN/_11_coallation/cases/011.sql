--+ holdcas on;
set names utf8;
create class t1(
col1 STRING collate utf8_gen, 
col2 CHAR(10) collate utf8_gen, 
col3 VARCHAR(10) collate utf8_gen, 
col4 DATE,
col5 TIME,
col6 TIMESTAMP


);
INSERT INTO t1 VALUES ('喝水shū果91','喝水shū果91','喝水shū果91','2008-05-26', '14:24:00', '2008-05-26 14:24:00');
INSERT INTO t1 VALUES ('uū喝呵水果91',null,'uū喝呵水果91','2008-06-26', '10:24:00', '2008-06-26 10:25:00');
INSERT INTO t1 VALUES ('shū喝水果91','shū喝水果91','shū喝水果91','2008-05-26', '14:23:00', '2008-06-26 14:24:00');
INSERT INTO t1 VALUES (null,'ū喝水sh果91','ū喝水sh果91','2009-05-26', '14:25:00', '2008-05-26 14:24:00');
INSERT INTO t1 VALUES ('ū喝水sh果91',null,null,'2008-05-28', '14:24:01', '14:24:01 2008-05-26');

create index t1_index on t1(col4);
--test
SELECT  * FROM t1 order by 1,2;
--test
SELECT  col4 FROM t1 order by col4;

UPDATE t1 SET col4='2008-05-26' WHERE col4='08年2月26日';

DELETE  FROM t1 WHERE col4='2008-05-26';
--test
SELECT  * FROM db_index WHERE class_name='t1' order by 1,2;
--test
SELECT  col4 FROM t1 order by col4;

drop class t1;
set names iso88591;
 
commit;
--+ holdcas off;


