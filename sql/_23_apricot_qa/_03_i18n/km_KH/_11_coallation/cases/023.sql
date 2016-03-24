--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
set names utf8;
create class t1(
col1 string collate binary, 
col2 char(10) collate utf8_km_exp, 
col3 varchar(10) collate utf8_km_exp, 
col4 DATE,
col5 TIME,
col6 TIMESTAMP);
INSERT INTO t1 VALUES ('ហឡឡតឰឿហថ','ហឡឡតឰឿហថ','ហឡឡតឰឿហថ','2011-01-02', '17:10:32', ' 2011-01-02 17:10:32');
INSERT INTO t1 VALUES ('ឯៀៀតឰឰហថ',null,'ឯៀៀតឰឰហថ','2011-01-02', '17:10:32', ' 2011-01-02 17:10:32');
INSERT INTO t1 VALUES ('ហឡកឮ','ហឡកឮ','ហឡកឮ','2011-01-02', '17:10:32', ' 2011-01-02 17:10:32');
INSERT INTO t1 VALUES (null,'ឯៀៀតឰឰហថ啊你','ឯកកតឰឰហថ','2011-01-02', '17:10:32', ' 2011-01-02 17:10:32');
INSERT INTO t1 VALUES ('ឯកកតឰឰហថ',null,null,'2011-01-02', '17:10:32', ' 2011-01-02 17:10:32');

create Reverse index t1_index on t1(col2) where col1>='ហឡឡតឰឿហថ';
--test
SELECT /*+ recompile */* FROM t1 where col1>='ហឡឡតឰឿហថ' order by 1,2;
--test
SELECT /*+ recompile */col2 FROM t1 where col1>='ហឡឡតឰឿហថ' order by col2;

UPDATE t1 SET col2='ហណ៰៩ថ' WHERE col2='ហឡកឮ';

DELETE  FROM t1 WHERE col2='ឯៀៀតឰឰហថ啊你';
--test
SELECT /*+ recompile */* FROM db_index WHERE class_name='t1'  order by 1,2;
--test
SELECT /*+ recompile */col2 FROM t1 where col1>='ហឡឡតឰឿហថ' order by col2;

drop class t1;
set names iso88591;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;

