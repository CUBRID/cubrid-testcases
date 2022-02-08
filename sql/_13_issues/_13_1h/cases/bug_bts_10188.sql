drop if exists t1; 

create table t1 (a varchar(10) collate iso88591_en_ci,b int);
insert into t1 values ('A',4), ('a',-1), ('AA',2), ('aa',3), ('Aa',122), ('aA',321);
create view v1 as select * from t1 where (a like 'a%' collate iso88591_en_cs);

--note: result is good
select * from v1 order by 2;

--test: result is not good
select * from v1 where (a='aa') collate iso88591_en_ci  order by 2;;

select * from v1 where (a like 'a%') collate iso88591_en_ci  order by 2;;

select * from v1 where (a like 'A%') collate iso88591_en_ci  order by 2;;

select * from v1 where (a like 'A%') collate iso88591_en_ci union select * from v1 where (a like 'A%') collate iso88591_en_ci  order by 2 desc ;

(select * from v1 where (a like 'A%') collate iso88591_en_ci) union  ALL (select * from v1 where (a like 'A%') collate iso88591_en_ci) order by 2 desc ;

(select * from v1 where (a like 'A%') collate iso88591_en_ci) union  ALL (select * from v1 where (a like 'A%') collate iso88591_en_ci) order by 2 desc ;

(select * from v1 where (a like 'A%') collate iso88591_en_ci) DIFFERENCE  (select * from v1 where (a like 'A%') collate iso88591_en_ci) order by 2 desc ;

select * from (select * from v1 where (a like 'A%') collate iso88591_en_ci)  order by 2;

select * from t1 order by 2;

select * from v1 order by 2;

select * from v1 where (a like 'A%') collate iso88591_en_ci order by 2; 

select * from v1 where (a='aa' and 0<>0) order by 2; 

select * from v1 where (a='aa' and 1<>0) order by 2; 

drop v1;

insert into t1 values ('B',2), ('b',3), ('BB',8), ('',-1), ('null',0), (null,-2);

create view v1 as select * from t1 where (a like 'B%' collate iso88591_en_cs);

select * from v1 where (a='aa') collate iso88591_en_ci order by 2; 

select * from v1 where (a='B') collate iso88591_en_ci order by 2; 

select * from v1 where (a like '%') collate iso88591_en_ci order by 2; 

drop v1;

create view v1 as select * from t1 where (a is NULL);

select * from v1 where (a like '%') collate iso88591_en_ci order by 2; 

select * from v1 order by 2; 

drop v1;
drop t1; 
