drop if exists t;

create table t (s char(10), i int);

insert into t values ('xxxx', 1);
insert into t values ('yyyy', 2);
insert into t values ('zzzz', 1);
insert into t values ('aaaa', 2);
insert into t values ('bbbb', 2);

create view v as select s s_v, i i_v from t order by s;

select distinct i from t;
select distinct t1.i from (select s, i from t order by s) t1;

select distinct i_v from v;
select distinct v1.i_v from v v1, v v2;

drop v;
drop t;

drop if exists t;

create table t (s char(10), i int);

insert into t values ('xxxx', 1);
insert into t values ('yyyy', 2);
insert into t values ('zzzz', 1);
insert into t values ('aaaa', 2);
insert into t values ('bbbb', 2);

select  count(t1) from t t1, t t2 order by t2.s;

create view v as select s s_v, i i_v from t group by s ;

select distinct i from t;
select distinct t1.i from (select s, i from t order by s) t1;

select distinct t1.i from (select s, i from t order by s) t1 order by t1.i;

select distinct t1.i from (select s, i from t order by s) t1 group by t1.i;

(select distinct t1.i from (select s, i from t order by s) t1 order by t1.i)
union all
(select distinct t1.i from (select s, i from t order by s) t1 group by t1.i);

select distinct * from (
(select distinct t1.i from (select s, i from t order by s) t1 order by t1.i)
union all
(select distinct t1.i from (select s, i from t order by s) t1 group by t1.i));

select distinct 1 from (
(select distinct t1.i from (select s, i from t order by s) t1 order by t1.i)
union all
(select distinct t1.i from (select s, i from t order by s) t1 group by t1.i));

(select distinct t1.i from (select s, i from t order by s) t1 order by t1.i)
union
(select distinct t1.i from (select s, i from t order by s) t1 group by t1.i);

select distinct i_v from v;
select distinct v1.i_v from v v1, v v2;

drop v;
drop t;

select distinct t1.charset_name from db_collation t1, db_collation t2;

select distinct t1.charset_name from db_collation t1, db_collation t2 order by t1.charset_name;

select count(*) from db_collation t1, db_collation t2 order by t2.coll_id;
