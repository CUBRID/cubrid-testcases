--+ holdcas on;
set names utf8;
CREATE TABLE test_kh ( 
  id     int    NOT NULL, 
  name      CHAR(20) collate utf8_km_exp);
  
insert into test_kh values (1,'កខណតថ');
insert into test_kh values (2,'កខណតស'); 
insert into test_kh values (3,'ហឡកឮ');
insert into test_kh values (103,'ហឡកឮ');
insert into test_kh values (203,'ហឡកឯ');
insert into test_kh values (303,'ហឡកឯ.ហឡឡតឰឿហថ');
insert into test_kh values (403,'ហឡកឮ ឯៀៀតឰឰហថ');
insert into test_kh values (4,'ហឡ៏ខ');
insert into test_kh values (104,'ឯឡ៏ខ');
insert into test_kh values (5,'ហឡឡតឰឿហថ'); 
insert into test_kh values (105,'ឯ័័តឰឰហថ');
insert into test_kh values (205,'ឯកកតឰឰហថ'); 
insert into test_kh values (6,'៝ខ០ស៩ថ');
insert into test_kh values (106,'%៝ខ០ស៩ថ'); 
insert into test_kh values (7,'៝ខ០ស៩ថ');
insert into test_kh values (107,'_៝ខ០ស៩ថ');
insert into test_kh values (8,'ឯឡ៏ខ');
insert into test_kh values (9,'ហណ៰៩ថ');
insert into test_kh values (109,'?ហណ៰៩ថ');
insert into test_kh values (10,'ហឡក៹');
insert into test_kh values (110,'*ហឡក៹');

select id,name from test_kh where name = 'ហឡកឮ' order by 1;

select id,name from test_kh where name = '៝ខ០ស៩ថ ' order by 1;

select id,name from test_kh where name != '*ហឡក៹ ' order by 1;

select id,name from test_kh where name <> 'ហឡឡតឰឿហថ ' order by 1;

drop table test_kh;
set names iso88591;
commit;
--+ holdcas off;