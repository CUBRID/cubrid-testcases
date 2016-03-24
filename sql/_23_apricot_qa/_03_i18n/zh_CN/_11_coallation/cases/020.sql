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
INSERT INTO t1 VALUES ('喝水shū果91','喝水shū果91','喝水shū果91','2008-05-26', '14:24:00', ' 2008-05-26 14:24:00');
INSERT INTO t1 VALUES ('uū喝呵水果91',null,'uū喝呵水果91','2008-05-26', '14:24:00', ' 2008-05-26 14:24:00');
INSERT INTO t1 VALUES ('shū喝水果91','shū喝水果91','shū喝水果91','2008-05-26', '14:24:00', ' 2008-05-26 14:24:00');
INSERT INTO t1 VALUES (null,'ū喝水sh果91','uū喝呵水果91啊你','2008-05-26', '14:24:00', ' 2008-05-26 14:24:00');
INSERT INTO t1 VALUES ('ū喝水sh果91',null,null,'2008-05-26', '14:24:00', ' 2008-05-26 14:24:00');

create Reverse unique index t1_index on t1(col2) where col1>='喝水shū果91';
--test
SELECT  * FROM t1 where col1>='喝水shū果91' order by 1,2;
--test
SELECT  col2 FROM t1 where col1>='喝水shū果91' order by col2;

UPDATE t1 SET col2='uū喝呵水果91啊你' WHERE col2='shū喝水果91';

DELETE  FROM t1 WHERE col2='ū喝水sh果91';
--test
SELECT  * FROM db_index WHERE class_name='t1' where col1>='喝水shū果91' order by 1,2;
--test
SELECT  col2 FROM t1 where col1>='喝水shū果91' order by col2;

drop class t1;
set names iso88591;
 
commit;
--+ holdcas off;

