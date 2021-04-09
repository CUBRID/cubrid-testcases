--+ holdcas on;
set names utf8;
create class t1(
col1 string collate binary, 
col2 char(10) collate utf8_km_exp, 
col3 varchar(10) collate utf8_km_exp, 
col4 DATE,
col5 TIME,
col6 TIMESTAMP );
INSERT INTO t1 VALUES ('ហឡឡតឰឿហថ','ហឡឡតឰឿហថ','ហឡឡតឰឿហថ','2011-01-02', '17:10:32', '2011-12-20 07:07:32');
INSERT INTO t1 VALUES ('ឯៀៀតឰឰហថ',null,'ឯៀៀតឰឰហថ','2011-12-20', '7:07:32', '2011-12-20, 7:07');
INSERT INTO t1 VALUES ('ហឡកឮ','ហឡកឮ','ហឡកឮ','2011-01-02', '14:23:00', '2011-12-20 07:07:32');
INSERT INTO t1 VALUES (null,'ឯកកតឰឰហថ','ឯកកតឰឰហថ','2011-11-20', '14:25:00', '2011-12-20 07:07:32');
INSERT INTO t1 VALUES ('ឯកកតឰឰហថ',null,null,'2011-12-20', '14:24:01', '2011-01-02 14:24:01');

create index t1_index on t1(col5);
--test
SELECT /*+ recompile */* FROM t1 order by 1,2;
--test
SELECT /*+ recompile */col5 FROM t1 order by col5;

UPDATE t1 SET col5='17:10:32' WHERE col5='17:10:32';

DELETE  FROM t1 WHERE col5='17:10:32';
--test
SELECT /*+ recompile */* FROM db_index WHERE class_name='t1' order by 1,2;
--test
SELECT /*+ recompile */col5 FROM t1 order by col5;

drop class t1;

set names iso88591;
commit;
--+ holdcas off;
