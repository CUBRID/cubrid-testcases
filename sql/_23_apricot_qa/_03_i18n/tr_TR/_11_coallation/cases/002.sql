--+ holdcas on;
set names utf8;
CREATE TABLE t ( 
  col1     int    NOT NULL, 
  col2      VARCHAR(20)  collate utf8_tr_cs);
  
insert into t values (1,'Gülen');
insert into t values (2,'Ğüler'); 
insert into t values (3,'İzgi');
insert into t values (103,'Izgi');
insert into t values (203,'İzgı');
insert into t values (303,'İzgı.iZZETtin');
insert into t values (403,'İzgi İxxettin');
insert into t values (4,'İzgü');
insert into t values (104,'İzğü');
insert into t values (5,'İzzettin'); 
insert into t values (105,'İwwettin');
insert into t values (205,'İqqettin'); 
insert into t values (6,'SevINÇ');
insert into t values (106,'%Sevinç'); 
insert into t values (7,'Şükran');
insert into t values (107,'_şÜKran');
insert into t values (8,'İzğü');
insert into t values (9,'İlhan');
insert into t values (109,'?İlhan');
insert into t values (10,'İzgÖ');
insert into t values (110,'*İzgö');
insert into t values (111,null);
insert into t values (112,'');
insert into t values (113,' ');

--test
select * from t order by col2;
--test
select * from t order by col2 desc;

drop table t;
set names iso88591;
commit;
--+ holdcas off;