-- CBRD-26659: OOS placement of VARCHAR values whose stored size is decided after string compression.
-- The seed is 9600 characters of md5 hex text, which barely compresses.
-- Row 1 (20000 repeated characters) compresses below the OOS threshold and must stay inline.
-- Row 2 (the seed) must move out of row. The UPDATEs swap the two shapes.
-- Values and the actual HAS_OOS record flag (SELECT_RECORD_INFO) are checked after each step.
drop table if exists t_oos_str;
drop table if exists t_oos_seed;
create table t_oos_seed (s varchar);
insert into t_oos_seed with recursive r (n, s) as (select 1, cast(md5('s1') as varchar) union all select n + 1, concat(s, md5(concat('s', n + 1))) from r where n < 300) select s from r where n = 300;
create table t_oos_str (id int primary key, s varchar);
insert into t_oos_str values (1, repeat('a', 20000));
insert into t_oos_str select 2, s from t_oos_seed;
select /*+ SELECT_RECORD_INFO */ id, char_length(s) as len, case when id = 1 and s = repeat('a', 20000) then 1 when id = 2 and s = (select s from t_oos_seed) then 1 else 0 end as value_ok, case when mod(t_flags, 16) >= 8 then 1 else 0 end as has_oos from t_oos_str order by id;
update t_oos_str set s = (select s from t_oos_seed) where id = 1;
update t_oos_str set s = repeat('b', 20000) where id = 2;
select /*+ SELECT_RECORD_INFO */ id, char_length(s) as len, case when id = 1 and s = (select s from t_oos_seed) then 1 when id = 2 and s = repeat('b', 20000) then 1 else 0 end as value_ok, case when mod(t_flags, 16) >= 8 then 1 else 0 end as has_oos from t_oos_str order by id;
drop table t_oos_str;
drop table t_oos_seed;
