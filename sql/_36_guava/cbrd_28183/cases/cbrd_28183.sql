-- CBRD-28183: cost-based group-by placement (GROUP BY below joins)
-- A joining, aggregating block may group the table holding the aggregate arguments in a derived table before the
-- join, when the planner finds it cheaper. The results must not change, and NO_PUSH_GROUP_BY keeps a block as it is.

drop table if exists t_ord, t_cust, t_nat;
create table t_nat (n_id int primary key, n_name varchar(20));
create table t_cust (c_id int primary key, c_name varchar(40), c_nat int, foreign key (c_nat) references t_nat (n_id));
create table t_ord (o_id int primary key, o_cust int, o_amount int, o_cmt varchar(40), foreign key (o_cust) references t_cust (c_id));

insert into t_nat select rownum, 'nat' || rownum from db_root connect by level <= 5;
-- 2000 customers, the 500 with c_id over 1500 have no order
insert into t_cust select rownum, 'cust' || rownum, mod(rownum, 5) + 1 from db_root connect by level <= 2000;
-- 60000 orders, 40 per customer 1 to 1500, some amounts NULL, some comments with special requests
insert into t_ord
  select rownum, mod(rownum, 1500) + 1,
         case when mod(rownum, 7) = 0 then null else mod(rownum, 100) end,
         case when mod(rownum, 11) = 0 then 'special requests' else 'normal' end
  from db_root connect by level <= 60000;
-- orders with a NULL customer join no customer
insert into t_ord select 60000 + rownum, null, 1, 'normal' from db_root connect by level <= 10;
update statistics on t_nat, t_cust, t_ord with fullscan;

-- T1: outer join and COUNT (TPC-H Q13 shape): t_ord is grouped in a derived table under the join
--@queryplan
select c_count, count(*) as custdist
from (select c_id, count(o_id) as c_count
      from t_cust left outer join t_ord on c_id = o_cust and o_cmt not like '%special%'
      group by c_id) x
group by c_count order by custdist desc, c_count desc;

-- T1b: the same block run serially: t_ord is grouped in a derived table under the join
--@queryplan
select /*+ PARALLEL(0) */ c_id, count(o_id) as c_count
from t_cust left outer join t_ord on c_id = o_cust and o_cmt not like '%special%'
group by c_id order by 2 desc, 1 limit 5;

-- T2: an equality on the outer key keeps the index join, with no derived table
--@queryplan
select c_id, count(o_id) from t_cust left outer join t_ord on c_id = o_cust where c_id = 5 group by c_id;

-- T3: the aggregates of a customer without order
select c_id, count(o_id), count(*), sum(o_amount), min(o_amount), max(o_amount), avg(o_amount)
from t_cust left outer join t_ord on c_id = o_cust
where c_id in (1, 7, 1501, 2000) group by c_id order by c_id;

-- T4: inner join (TPC-H Q10 shape): the outer GROUP BY is dropped, a customer meeting one row
--@queryplan
select c_id, c_name, sum(o_amount) as rev, n_name
from t_cust, t_ord, t_nat
where c_id = o_cust and c_nat = n_id and o_cmt = 'normal'
group by c_id, c_name, n_name order by rev desc, c_id limit 10;

-- T5: no GROUP BY
select count(o_id), count(*), sum(o_amount), avg(o_amount) from t_cust, t_ord where c_id = o_cust and c_nat = 3;
select count(o_id), count(*), sum(o_amount), avg(o_amount) from t_cust, t_ord where c_id = o_cust and c_nat = 99;

-- T6: blocks left as they are: DISTINCT aggregate, OR, two aggregates in one item, ROLLUP
--@queryplan
select c_nat, count(distinct o_amount) from t_cust, t_ord where c_id = o_cust group by c_nat order by 1;
--@queryplan
select c_nat, sum(o_amount) from t_cust, t_ord where c_id = o_cust and (o_amount > 50 or c_nat = 1) group by c_nat order by 1;
--@queryplan
select c_nat, sum(o_amount) + count(*) from t_cust, t_ord where c_id = o_cust group by c_nat order by 1;
select c_nat, sum(o_amount) from t_cust, t_ord where c_id = o_cust group by c_nat with rollup order by 1;

-- T7: bound values
prepare q1 from 'select c_id, sum(o_amount) from t_cust, t_ord where c_id = o_cust and c_id between ? and ? group by c_id order by c_id';
execute q1 using 1, 3;
execute q1 using 1495, 1505;
deallocate prepare q1;

-- T8: the same blocks with NO_PUSH_GROUP_BY give the same rows (both EXCEPT empty)
select c_id, count(o_id), count(*), sum(o_amount), avg(o_amount)
from t_cust left outer join t_ord on c_id = o_cust group by c_id
except
select /*+ NO_PUSH_GROUP_BY */ c_id, count(o_id), count(*), sum(o_amount), avg(o_amount)
from t_cust left outer join t_ord on c_id = o_cust group by c_id;
select /*+ NO_PUSH_GROUP_BY */ c_id, count(o_id), count(*), sum(o_amount), avg(o_amount)
from t_cust left outer join t_ord on c_id = o_cust group by c_id
except
select c_id, count(o_id), count(*), sum(o_amount), avg(o_amount)
from t_cust left outer join t_ord on c_id = o_cust group by c_id;
select c_nat, max(o_amount), min(o_id), count(o_amount) from t_cust, t_ord where c_id = o_cust group by c_nat
except
select /*+ NO_PUSH_GROUP_BY */ c_nat, max(o_amount), min(o_id), count(o_amount) from t_cust, t_ord where c_id = o_cust group by c_nat;
--@queryplan
select /*+ NO_PUSH_GROUP_BY */ c_count, count(*) as custdist
from (select /*+ NO_PUSH_GROUP_BY */ c_id, count(o_id) as c_count
      from t_cust left outer join t_ord on c_id = o_cust and o_cmt not like '%special%'
      group by c_id) x
group by c_count order by custdist desc, c_count desc;

-- T9: RIGHT OUTER JOIN, and a HAVING over the re-aggregated values
select c_nat, count(o_id), sum(o_amount) from t_ord right outer join t_cust on c_id = o_cust
group by c_nat having count(o_id) > 0 order by 1;
select c_id, sum(o_amount) from t_cust, t_ord where c_id = o_cust group by c_id having sum(o_amount) > 1680 order by 1;

drop table t_ord, t_cust, t_nat;
