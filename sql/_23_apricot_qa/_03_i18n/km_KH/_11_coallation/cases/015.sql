--+ holdcas on;
set names utf8;
create class t1(
col1 string collate binary, 
col2 char(10) collate utf8_km_exp, 
col3 varchar(10) collate utf8_km_exp, 
col4 DATE,
col5 TIME,
col6 TIMESTAMP,
col7 SET,
col8 MULTISET,
col9 SEQUENCE );
INSERT INTO t1 VALUES ('ហឡឡតឰឿហថ','ហឡឡតឰឿហថ','ហឡឡតឰឿហថ','2011-01-02', '17:10:32', ' 2011-01-02 17:10:32',{'ហឡឡតឰឿហថ'},{'ហឡឡតឰឿហថ'},{'ហឡឡតឰឿហថ'});
INSERT INTO t1 VALUES ('ឯៀៀតឰឰហថ',null,'ឯៀៀតឰឰហថ','2011-12-20', '7:07:32', '2011-12-20, 7:07',{'ឯៀៀតឰឰហថ'},{'ឯៀៀតឰឰហថ'},{'ឯៀៀតឰឰហថ'});
INSERT INTO t1 VALUES ('ហឡកឮ','ហឡកឮ','ហឡកឮ','2011-01-02', '14:23:00', '2011-11-20 17:07:32',{'ហឡកឮ'},{'ហឡកឮ'},{'ហឡកឮ'});
INSERT INTO t1 VALUES (null,'ឯកកតឰឰហថ','ឯកកតឰឰហថ','2011-11-20', '14:25:00', ' 2011-01-02 17:10:32',null,{'ឯកកតឰឰហថ'},null);
INSERT INTO t1 VALUES ('ឯកកតឰឰហថ',null,null,'2011-12-20', '14:24:01', '2011-12-20, 7:07',{'ឯកកតឰឰហថ'},null,{'ឯកកតឰឰហថ'});

create index t1_index on t1(col8);
--test
SELECT /*+ recompile */* FROM t1 order by 1,2;
--test
SELECT /*+ recompile */col8 FROM t1 order by col8;

UPDATE t1 SET col8={'ហឡឡតឰឿហថ_aa'} WHERE col1='ហឡឡតឰឿហថ';

DELETE  FROM t1 WHERE col1='ហឡឡតឰឿហថ';
--test
SELECT /*+ recompile */* FROM db_index WHERE class_name='t1' order by 1,2;
--test
SELECT /*+ recompile */col8 FROM t1 order by col8;

drop class t1;
set names iso88591;
commit;
--+ holdcas off;

