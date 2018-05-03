drop table if exists t1;
create table t1(id int primary key, name varchar(50) default to_char(SYS_TIMESTAMP, 'HH:MI:SS AM MM/DD/YYYY'), answer varchar(100));
insert into t1 values(1, 'xbc', 'xbc');
insert into t1(id, answer) values(2, to_char(SYS_TIMESTAMP, 'HH:MI:SS AM MM/DD/YYYY'));

with cte as
(
   select id, name=answer, default(name)=to_char(SYS_TIMESTAMP, 'HH:MI:SS AM MM/DD/YYYY') as default_name from t1
) select * from cte order by 1, 2, 3;

with cte2 as
(
  select id, name from t1
  union all
  select 1, default(name) as name from t1
  union all 
  select rownum, to_char(SYS_TIMESTAMP, 'HH:MI:SS AM MM/DD/YYYY') as name from t1
) select id, if(name in ('xbc', to_char(SYS_TIMESTAMP, 'HH:MI:SS AM MM/DD/YYYY'), (select answer from t1 where id=2)),'ok','nok') as default_name from cte2 
order by 1,2;


with cte3 as 
(
   select id, name from t1
),
cte4 as (
   select rownum as c4_id, to_char(SYS_TIMESTAMP, 'HH:MI:SS AM MM/DD/YYYY') as name from t1
) select id, c4_id, if(cte3.name in ('xbc', (select answer from t1 where id=2)), 'ok', 'nok') from cte3 join cte4 on id=c4_id
order by 1,2;


drop table if exists t1;
create table t1 (id int, test_data varchar(36)  default to_char(SYS_TIMESTAMP, 'HH:MI:SS AM MM/DD/YYYY'));

insert into t1(id, test_data)
select id, test_data
    from (
with recursive data_generator(id, test_data) as (
                select 1 as id, SYS_GUID() as test_data
                union all
                select id + 1, default(test_data) from t1
            )
        select * from data_generator 
	) as a;

insert into t1(id, test_data)
select id, test_data
    from (
with recursive data_generator(id, test_data) as (
                select 1 as id, SYS_GUID() as test_data
                union all
                select id + 1, default(test_data) from t1
            )
        select * from data_generator
        ) as a;




drop table if exists t1;

drop table if exists tt;
create table tt(c varchar default to_char(systime, 'HH'), c_answer varchar);
insert into tt values (default, to_char(systime, 'HH'));
insert into tt values('abccc', 'abccc');
drop table if exists t22;
create table t22 (cc char(50) default to_char(systimestamp, 'HH:MI:SS AM MM/DD/YYYY TZR'), answer char(50));
insert into t22 values (default, to_char(systimestamp, 'HH:MI:SS AM MM/DD/YYYY TZR'));
insert into t22 values (default(cc), to_char(systimestamp, 'HH:MI:SS AM MM/DD/YYYY TZR'));

with cte(a, b, c1_answer, c2_answer) as (select c, default(c), c_answer, to_char(systime, 'HH') as hour_answer from tt union all select cc, to_char('09:30:17 20140307XEESTXEurope/Bucharest','%h:%i:%s %Y%d%mX%TZD4X%TZR'), answer as cc_answer, to_char('09:30:17 20140307XEESTXEurope/Bucharest','%h:%i:%s %Y%d%mX%TZD4X%TZR') from t22 ) select a=c1_answer, b=c2_answer  from cte;

drop table if exists tt;

drop table if exists tt;
create table tt(c varchar default to_char(systime, 'HH'));
insert into tt values default;
insert into tt values('abccc');
drop table if exists t22;
create table t22 (cc char(50) default to_char(systimestamp, 'HH:MI:SS AM MM/DD/YYYY TZR'));
insert into t22 values default;
insert into t22 values (default(cc));

with cte as 
(
         select c as c, default(c) as d from tt
)
, cte1 as (
         select '1' as cc, '222' as dd union select * from cte)
, cte3 as (
         select 1 as a, 2 as b from db_root join cte1 on 1=1 and cte1.dd <> default(dd) 
) select cc, dd from cte1;
drop table if exists tt;
drop table if exists t22;


