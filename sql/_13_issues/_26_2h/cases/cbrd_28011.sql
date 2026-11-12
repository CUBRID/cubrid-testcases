-- CBRD-28011: SQL trace shows the OOS share of a scan's fetch, ioread and time.
-- Only a scan that reads OOS values shows the oos group; its figures are part of the scan's own.
autocommit off;
set system parameters 'group_concat_max_len=100000';

create table t_oos (id int primary key, s varchar(20), big varchar);
insert into t_oos
  select r, 'small' || r,
         (select group_concat(md5(r * 10000 + x.n) separator '') from (select rownum n from db_class a, db_class b limit 300) x)
  from (select rownum r from db_class limit 20) y;

create table t_plain (id int primary key, s varchar(20), v varchar(100));
insert into t_plain select rownum, 'small' || rownum, md5(rownum) from db_class limit 20;

create table t_part (id int primary key, s varchar(20), big varchar)
  partition by range (id) (partition p1 values less than (11), partition p2 values less than maxvalue);
insert into t_part select id, s, big from t_oos;

update statistics on t_oos, t_plain, t_part with fullscan;

set trace on;

-- reads the OOS column: the heap scan shows an oos group
select count(*), sum(length(big)) from t_oos where s like 'small%';
show trace;

-- same table without the OOS column: no oos group
select count(*), sum(length(s)) from t_oos where s like 'small%';
show trace;

-- a table without OOS values: no oos group
select count(*), sum(length(v)) from t_plain where s like 'small%';
show trace;

-- index lookup reading the OOS column
select id, length(big) from t_oos where id between 3 and 5 order by id;
show trace;

-- each partition shows its own oos group
select count(*), sum(length(big)) from t_part where s like 'small%';
show trace;

set trace on output json;

select count(*), sum(length(big)) from t_oos where s like 'small%';
show trace;

select count(*), sum(length(s)) from t_oos where s like 'small%';
show trace;

set trace off;

drop table t_part;
drop table t_plain;
drop table t_oos;
set system parameters 'group_concat_max_len=1024';
autocommit on;
