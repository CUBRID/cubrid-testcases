drop table if exists t3;

create table t3(i1 int);

insert into t3 values(1),(2),(3);

alter table t3 add s1 varchar default 'aaaaaa';

alter table t3 add s2 varchar default 'b'+'b';

alter table t3 add s3 varchar default concat('abc',123);

alter table t3 add s4 varchar default to_char(123.4567,'99999.999');

-- filled with current time
alter table t3 add s5 varchar default to_char(systimestamp,'HH:MI:SS AM MM/DD/YYYY');

alter table t3 add s6 varchar default to_char('06:07:44 PM 05/09/2017','HH:MI:SS AM MM/DD/YYYY');

-- filled with current time
alter table t3 add s7 datetime not null default sysdatetime;  

alter table t3 add s8 varchar;

-- null
alter table t3 alter column s8 set default 'cccc';

select i1,s1,s2,s3,s4,if(s5 is not null,'ok','nok'),s6,if(s7 is not null,'ok','nok'),s8 from t3 order by 1;

insert into t3(i1) values(4);

select i1,s1,s2,s3,s4,if(s5 is not null,'ok','nok'),s6,if(s7 is not null,'ok','nok'),s8 from t3 order by 1;

drop t3;
