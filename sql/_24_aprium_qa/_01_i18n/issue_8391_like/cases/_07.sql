--+ holdcas on;
set names utf8;
drop table if exists t;
create table t (i int, s char(20) collate iso88591_en_ci);

insert into t values (1,'Axx');
insert into t values (2,'aExx');
insert into t values (3,'xAxx');
insert into t values (4,'xaExx');
insert into t values (5,'xA');
insert into t values (6,'xa');
insert into t values (7,'A');
insert into t values (8,'xa%Exx');
insert into t values (9,'xa%Exx');
insert into t values (10,'xÅ%Exx');


select * from t where s like 'a%' order by 1;
select * from t where s like 'A_%' order by 1;

select * from t where s like '_a%' order by 1;
select * from t where s like '_%a%' order by 1;

select * from t where s like '_A_%' order by 1;
select * from t where s like '_A%_' order by 1;

select * from t where s like '_Aa%_' escape 'A' order by 1;

select * from t where s like 'x%Aa%x_%' escape 'A' order by 1;

select * from t where s like 'x%A%%_' escape 'A' order by 1;

drop table t;
set names iso88591;
commit;
--+ holdcas off;
