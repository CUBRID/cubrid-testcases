--+ holdcas on;
set names utf8;
drop table if exists test_tr;
CREATE TABLE test_tr ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_tr_cs_uca);
  
insert into test_tr values (1,'Gülen');
insert into test_tr values (2,'Ğüler'); 
insert into test_tr values (3,'İzgi');
insert into test_tr values (103,'Izgi');
insert into test_tr values (203,'İzgı');
insert into test_tr values (303,'İzgı.iZZETtin');
insert into test_tr values (403,'İzgi İxxettin');
insert into test_tr values (4,'İzgü');
insert into test_tr values (104,'İzğü');
insert into test_tr values (5,'İzzettin'); 
insert into test_tr values (105,'İwwettin');
insert into test_tr values (205,'İqqettin'); 
insert into test_tr values (6,'SevINÇ');
insert into test_tr values (106,'%Sevinç'); 
insert into test_tr values (7,'Şükran');
insert into test_tr values (107,'_şÜKran');
insert into test_tr values (8,'İzğü');
insert into test_tr values (9,'İlhan');
insert into test_tr values (109,'?İlhan');
insert into test_tr values (10,'İzgÖ');
insert into test_tr values (110,'*İzgö');
--Test
select id, name, field ('İzgi',name) from test_tr order by 1;
--Test
select id, name, field (null,name) from test_tr order by 1;
--Test
select id, name, field (name,'İzğü') from test_tr order by 1;
--Test
select id, name, field (name,'İzğü',null) from test_tr order by 1;

drop table test_tr;
--Test
SELECT FIELD('çğıİöşü', 'çğıIöşü','çğıIöşü');
--Test
SELECT FIELD('çğıIöşü', 'çğıIöşü','çğıIöşü');
--Test
SELECT FIELD('çğıIIöş', 'çIğıIöşü','çğıIIöşü');
--Test
SELECT FIELD('çğıIIöş', 'çIğıIöşü','çğıIIöşü',null);
--Test
SELECT FIELD(123, '123çIğıIöşü','çğıIIöşü','123',123);
set names iso88591;
commit;
--+ holdcas off;
