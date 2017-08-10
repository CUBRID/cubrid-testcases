--+ holdcas on;
set names utf8;
CREATE TABLE test_kh ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_km_exp);
insert into test_kh values (1,'អា');
insert into test_kh values (2,'ច'); 
insert into test_kh values (3,'ច');
insert into test_kh values (103,'ច');
insert into test_kh values (203,'ច');
insert into test_kh values (303,'ច.អ');
insert into test_kh values (403,'ច ពុ');
insert into test_kh values (4,'ពុ');
insert into test_kh values (104,'ព្រ');
insert into test_kh values (5,'អ'); 
insert into test_kh values (105,'សុ');
insert into test_kh values (205,'សុ'); 
insert into test_kh values (6,'មករា');
insert into test_kh values (106,'%មករា'); 
insert into test_kh values (7,'កុម្ភៈ');
insert into test_kh values (107,'_កុម្ភៈ');
insert into test_kh values (8,'ព្រ');
insert into test_kh values (9,'មិនា');
insert into test_kh values (109,'?មិនា');
insert into test_kh values (10,'មេសា');
insert into test_kh values (110,'*មេសា');

select id, name, replace (name,'មករា','ច') from test_kh order by 1;

select id, name, replace (name,'សុ','_កុ_') from test_kh order by 1;

select id, name, replace (name,'អ','') from test_kh order by 1;

select id, name, replace (name,'មេ','កុ') from test_kh order by 1;

drop table test_kh;
set names iso88591;
commit;
--+ holdcas off;

