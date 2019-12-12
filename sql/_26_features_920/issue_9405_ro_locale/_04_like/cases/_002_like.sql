--+ holdcas on;
set names utf8;
CREATE TABLE t_like ( 
  id     int    NOT NULL, 
  name      VARchar(20) collate utf8_ro_cs);

insert into t_like values (1,'cunoștință');
insert into t_like values (2,'Cunoștință'); 
insert into t_like values (3,'cunoşt_ințăÎ');
insert into t_like values (103,'cunoştinţăÎ');
insert into t_like values (203,'Încântat');
insert into t_like values (303,'ÎmiÎncântat');
insert into t_like values (403,'ÎncântatĂ**?');
insert into t_like values (4,'?_Încântat');
insert into t_like values (5,'Însănătoșire'); 
insert into t_like values (6,'Însănătoşire');
insert into t_like values (106,'%Însănătoşire%'); 
insert into t_like values (7,'__Însănătoşire%ă');
insert into t_like values (107,'În%cân_tat');
insert into t_like values (8,'sănătate!');
insert into t_like values (108,'!sănătate!  ');
insert into t_like values (9,'%!_sănătate!_');
insert into t_like values (109,'?cunoștință_');
insert into t_like values (10,'_sănă_tate%?');
insert into t_like values (110,'*Încâ%ntat*Ă');

select * from t_like where name like 'cunoș%' order by 1;
select * from t_like where name like 'cunoş%' order by 1;
select * from t_like where name like 'În%' order by 1;
select * from t_like where name like '%În%' order by 1;
select * from t_like where name like '_În%' order by 1;
select * from t_like where name like '%ță' order by 1;
select * from t_like where name like '%ă%' order by 1;
select * from t_like where name like '?____%' order by 1;
select * from t_like where name like 'Î__Î' order by 1;
select * from t_like where name like '%Ă%' order by 1;
select * from t_like where name like '%ă%ă%' order by 1;

select * from t_like where name like 'cunoș%' escape 'ș'  order by 1;
select * from t_like where name like 'ă%ă_ă%' escape 'ă'  order by 1;

select * from t_like where name like '%\%ănă%' escape '\'  order by 1;
select * from t_like where name like '%Ă_%' escape 'Ă'  order by 1;
select * from t_like where name like '\_%?' escape '\' order by 1;
select * from t_like where name like '%\_%\%%' escape '\' order by 1;

set system parameters 'no_backslash_escapes=no';
select * from t_like where name like '\%ănă%' order by 1;
select * from t_like where name like '%\_%' order by 1;
select * from t_like where name like '\_%?' order by 1;
select * from t_like where name like '%\_\%%?' order by 1;
set system parameters 'no_backslash_escapes=yes';

select * from t_like where name like '\%ănă%' order by 1;
select * from t_like where name like '%\_%' order by 1;
select * from t_like where name like '\_%?' order by 1;
select * from t_like where name like '%\_\%%?' order by 1;

select * from t_like where name like '!%'  order by 1;
select * from t_like where name like '?%'  order by 1;
select * from t_like where name like '*%'  order by 1;

drop class t_like;
set names iso88591;
commit;
--+ holdcas off;
