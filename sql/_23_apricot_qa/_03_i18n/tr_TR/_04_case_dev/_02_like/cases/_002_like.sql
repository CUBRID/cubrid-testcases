--+ holdcas on;
set names utf8;
CREATE TABLE t_like ( 
  id     int    NOT NULL, 
  name      VARchar(20) collate utf8_tr_cs_uca);

insert into t_like values (1,'Gülen');
insert into t_like values (2,'Güler'); 
insert into t_like values (3,'İzgi');
insert into t_like values (103,'Izgi');
insert into t_like values (203,'İzgı');
insert into t_like values (303,'İzgı.İzzettin');
insert into t_like values (403,'İzgi İzzettin');
insert into t_like values (4,'İzgü');
insert into t_like values (5,'İzzettin'); 
insert into t_like values (6,'Sevinç');
insert into t_like values (106,'%Sevinç'); 
insert into t_like values (7,'Şükran');
insert into t_like values (107,'_Şükran');
insert into t_like values (8,'İlhan');
insert into t_like values (108,'!İlhan');
insert into t_like values (9,'İlhan');
insert into t_like values (109,'?İlhan');
insert into t_like values (10,'İlhan');
insert into t_like values (110,'*İlhan');

select * from t_like where name like 'Güle%' order by 1;
select * from t_like where name like 'İzg_' order by 1;
select * from t_like where name like 'Izg_' order by 1;
select * from t_like where name like 'İzgi%' order by 1;
select * from t_like where name like '_z%' order by 1;
select * from t_like where name like '%an' order by 1;
select * from t_like where name like 'İz%' order by 1;
select * from t_like where name like 'Güle_' order by 1;
select * from t_like where name like 'Gül__' order by 1;
select * from t_like where name like 'Gül%' order by 1;

select * from t_like where name like 'ı%Sevinç' escape 'ı'  order by 1;
select * from t_like where name like 'ı%Sevin_' escape 'ı'  order by 1;

select * from t_like where name like '\%Sevinç' escape '\'  order by 1;
select * from t_like where name like '\%Sev_n_' escape '\'  order by 1;
select * from t_like where name like '\_%' escape '\' order by 1;

select * from t_like where name like '!%'  order by 1;
select * from t_like where name like '?%'  order by 1;
select * from t_like where name like '*%'  order by 1;

drop class t_like;
set names iso88591;
commit;
--+ holdcas off;
