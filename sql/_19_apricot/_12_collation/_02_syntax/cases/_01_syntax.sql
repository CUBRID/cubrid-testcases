
create table t1 (s1 string collate 'utf8_en_ci');

create table t2 (s1 string collate 'utf8_en_cs');


insert into t1 values ('Ab'),( 'aa');

insert into t2 values ('Ab'),( 'aa');


alter table t1 add d1 date default date '2001-11-12';
alter table t2 add d1 date default date '2001-11-12';


alter table t1 add sd1 varchar(10) collate utf8_en_ci default '2001-11-12';
alter table t2 add sd1 varchar(10) collate utf8_en_cs default '2001-11-12';

alter table t1 add st1 char(10) collate utf8_en_ci default '10:11';
alter table t2 add st1 char(10) collate utf8_en_cs default '10:11';

alter table t1 add nc1 national char(10) collate utf8_en_ci default n'Ab';
alter table t2 add nc1 national char(10) collate utf8_en_cs default n'Ab';

alter table t1 add ns1 national char varying(10) collate utf8_en_ci default n'Ab';
alter table t2 add ns1 national char varying(10) collate utf8_en_cs default n'Ab';


select * from t1 order by 1;
select * from t2 order by 1;

select s1 from t1 order by 1;
select cast (s1 as string collate utf8_en_ci) from t1 order by 1;
select cast (s1 as string collate utf8_en_cs) from t1 order by 1;

drop t1;
drop t2;

