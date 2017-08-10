--+ holdcas on;
set names utf8;
CREATE TABLE test_tr ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_km_exp);
  
insert into test_tr values (1,'អា');
insert into test_tr values (2,'ច'); 
insert into test_tr values (3,'ច');
insert into test_tr values (103,'ច');
insert into test_tr values (203,'ច');
insert into test_tr values (303,'ច.អ');
insert into test_tr values (403,'ច ពុ');
insert into test_tr values (4,'ពុ');
insert into test_tr values (104,'ព្រ');
insert into test_tr values (5,'អ'); 
insert into test_tr values (105,'សុ');
insert into test_tr values (205,'សុ'); 
insert into test_tr values (6,'មករា');
insert into test_tr values (106,'%មករា'); 
insert into test_tr values (7,'កុម្ភៈ');
insert into test_tr values (107,'_កុម្ភៈ');
insert into test_tr values (8,'ព្រ');
insert into test_tr values (9,'មិនា');
insert into test_tr values (109,'?មិនា');
insert into test_tr values (10,'មេសា');
insert into test_tr values (110,'*មេសា');

select id, name, field ('ច',name) from test_tr order by 1;

select id, name, field (name,'ព្រ') from test_tr order by 1;


drop table test_tr;

SELECT FIELD('៥ពុ', '៥ពុ','៥ពុ');

SELECT FIELD('៥ពុ', '៥ពុ','៥ពុ');

SELECT FIELD('កក្កដា', 'កក្កដា៨','កក្កដា៨');
set names iso88591;
commit;
--+ holdcas off;

