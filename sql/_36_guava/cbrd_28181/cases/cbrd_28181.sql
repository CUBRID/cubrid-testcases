-- CBRD-28181: GROUP BY blocks whose group order cannot reach the result, and a sort GROUP BY's COUNT DISTINCT
-- Case 1-5: COUNT DISTINCT of integer and date-time columns kept in memory per group, beside the types that keep the list
-- Case 6-9: the query of IN, NOT IN, =ANY, <>ALL, EXISTS and an ORDER BY that has every GROUP BY key
-- Case 10-13: the blocks whose group order reaches the result (no ORDER BY, part of the keys, LIMIT, a CAST of a key)
-- Case 14: a serial in the select list, which numbers the groups as they come out
drop table if exists t28181;
create table t28181 (id int primary key, k int, v int, b bigint, d date, dt datetime, s varchar(10) collate utf8_en_ci, c char(4));
insert into t28181
  select id, mod(id, 97),
         case when mod(id, 11) = 0 then null else mod(id, 13) end,
         mod(id, 29) * 10000000000,
         date'2024-01-01' + mod(id, 70),
         datetime'2024-01-01 00:00:00' + mod(id, 5) * 1000,
         case mod(id, 3) when 0 then 'ab' when 1 then 'AB' else 'cd' end,
         case mod(id, 2) when 0 then 'x' else 'x  ' end
  from (select rownum as id from db_class a, db_class b, db_class c limit 20000) x;
insert into t28181 values (900001, 1000, null, null, null, null, null, null), (900002, 1000, null, null, null, null, null, null);
update statistics on t28181;

-- Case 1: COUNT DISTINCT per group, a few values each and NULLs left out (the k = 1000 group counts 0)
select k, count(distinct v), count(distinct b), count(*) from t28181 group by k order by k;

-- Case 2: more distinct values in a group than memory keeps (the list takes them)
select mod(k, 3) m, count(distinct d), count(distinct id), count(distinct v) from t28181 where k < 1000 group by mod(k, 3) order by 1;

-- Case 3: date and datetime, with COUNT DISTINCT of a string and a char column and SUM, AVG DISTINCT in the same block
select mod(k, 10) m, count(distinct d), count(distinct dt), count(distinct s), count(distinct c), sum(distinct v), avg(distinct v) from t28181 group by mod(k, 10) order by 1;

-- Case 4: a group whose values are all NULL, and an empty input
select k, count(distinct v), count(distinct d) from t28181 where k = 1000 group by k;
select k, count(distinct v) from t28181 where k = -1 group by k;

-- Case 5: COUNT DISTINCT with HAVING over it
select k, count(distinct v) cv from t28181 group by k having count(distinct v) < 13 order by k;

-- Case 6: IN, NOT IN
select count(*), sum(id) from t28181 where k in (select k from t28181 group by k having sum(v) > 1130);
select count(*) from t28181 where k not in (select k from t28181 group by k having count(*) > 206);

-- Case 7: =ANY, <>ALL, EXISTS
select count(*) from t28181 where k = any (select k from t28181 group by k having max(d) = date'2024-03-10' and min(v) = 0);
select count(*) from t28181 where k <> all (select k from t28181 group by k having avg(v) > 6);
select count(*) from t28181 a where a.id < 300 and exists (select 1 from t28181 b where b.k = a.k group by b.k having count(*) > 206);

-- Case 8: an ORDER BY that has every GROUP BY key, in another order
select k, count(*) c, sum(v) sv from t28181 group by k order by c desc, sv, k;
select mod(k, 7) a, mod(k, 5) b, count(*) c from t28181 group by mod(k, 7), mod(k, 5) order by c, b desc, a;

-- Case 9: the query of IN with an ORDER BY and with a row number, which still reads the groups in their order
select count(*) from t28181 where k in (select k from t28181 group by k order by k);
select count(*) from t28181 where k in (select k from t28181 where rownum < 5000 group by k);

-- Case 10: no ORDER BY, the groups come in the GROUP BY's order
select k, count(*) from t28181 where k < 20 group by k;

-- Case 11: an ORDER BY with part of the keys: the ties keep the GROUP BY's order
select k, count(*) c from t28181 group by k order by c;

-- Case 12: LIMIT in the query of IN, and GROUPBY_NUM
select count(*), sum(id) from t28181 where k in (select k from t28181 group by k having sum(v) > 1100 limit 10);
select k, groupby_num () from t28181 group by k having groupby_num () < 5;

-- Case 13: an ORDER BY on a CAST of the key that narrows it: the five dt groups tie on the date and keep the GROUP BY's order
select cast(dt as date) c, count(*) n, sum(v) sv from t28181 where id < 20000 group by dt order by 1 desc;
select cast(dt as date) c, count(*) n from t28181 where id < 20000 group by dt order by 1, 2 desc;

-- Case 14: a serial in the select list numbers the groups in the GROUP BY's order, under an ORDER BY with every key and under DISTINCT
create table t28181s (k int);
insert into t28181s values (3), (1), (2), (2), (5), (4), (4), (7), (6), (9), (8), (8);
create serial s28181;
select k, count(*) c, s28181.next_value sv from t28181s group by k order by c, k;
drop serial s28181;
create serial s28181;
select distinct k, s28181.next_value sv from t28181s group by k;
drop serial s28181;
drop table t28181s;

drop table t28181;
