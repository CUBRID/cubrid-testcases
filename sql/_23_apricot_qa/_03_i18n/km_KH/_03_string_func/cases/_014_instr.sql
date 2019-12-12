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

select id, name, instr (name,'មិ',1) from test_kh order by 1;

select id, name, instr (name,'កុ',1) from test_kh order by 1;

select id, name, instr (name,'ប្រាំ.ក',2) from test_kh order by 1;

select id, name, instr (name,'មេសា') from test_kh order by 1;

drop table test_kh;


select instr ('អា','៨',1);

select instr ('អា','៨',2);

select instr ('អា','៨',3);

select instr ('ច.អ','ប្រាំ.ក',1);

select instr ('ច.អ','ប្រាំ.ក',2);

select instr ('ច.អ','ប្រាំ.ក',3);

select instr ('ច.អ','ប្រាំ.ក',4);

select instr ('អា','ម',-1);

select instr ('អា','ម',-4);

select instr ('អា','ម',-5);

select instr ('ច.អ','ប្រាំ.ក',-1);

select instr ('ច.អ','ប្រាំ.ក',-8);

select instr ('ច.អ','ប្រាំ.ក',-9);

set names iso88591;
commit;
--+ holdcas off;