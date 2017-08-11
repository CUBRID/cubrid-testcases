--+ holdcas on;
set names utf8;
CREATE TABLE t ( 
  col1     int    NOT NULL, 
  col2      VARCHAR(20) collate utf8_km_exp);
  
insert into t values (1,'កខណតថ');
insert into t values (2,'កខណតស'); 
insert into t values (3,'ហឡកឮ');
insert into t values (103,'ហឡកឮ');
insert into t values (203,'ហឡកឯ');
insert into t values (303,'ហឡកឯ.ហឡឡតឰឿហថ');
insert into t values (403,'ហឡកឮ ឯៀៀតឰឰហថ');
insert into t values (4,'ហឡ៏ខ');
insert into t values (104,'ឯឡ៏ខ');
insert into t values (5,'ហឡឡតឰឿហថ'); 
insert into t values (105,'ឯ័័តឰឰហថ');
insert into t values (205,'ឯកកតឰឰហថ'); 
insert into t values (6,'៝ខ០ស៩ថ');
insert into t values (106,'%៝ខ០ស៩ថ'); 
insert into t values (7,'៝ខ០ស៩ថ');
insert into t values (107,'_៝ខ០ស៩ថ');
insert into t values (8,'ឯឡ៏ខ');
insert into t values (9,'ហណ៰៩ថ');
insert into t values (109,'?ហណ៰៩ថ');
insert into t values (10,'ហឡក៹');
insert into t values (110,'*ហឡក៹');

--test
select * from t order by col2, col1;
--test
select * from t order by col2 desc, col1;

drop table t;
set names iso88591;
commit;
--+ holdcas off;
