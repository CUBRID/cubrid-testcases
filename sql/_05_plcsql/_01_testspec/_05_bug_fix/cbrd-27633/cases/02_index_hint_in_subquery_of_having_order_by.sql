-- verified the CBRD-27633
--+ server-message on

evaluate 'index hints in subqueries under HAVING / ORDER BY (aborted at mq_check_using_index () before, even before CBRD-27556 (#8091))';
create table t (c int);
create index idx on t (c);
insert into t select rownum from db_class limit 10;

evaluate 'HAVING with a subquery of USING INDEX idx(+): 10 rows';
select c, count(*) from t group by c having count(*) >= (select count(*) from t where c > 5 using index idx(+)) - 99 order by 1;

evaluate 'HAVING with a subquery of USING INDEX idx(-): 10 rows';
select c, count(*) from t group by c having count(*) >= (select count(*) from t where c > 5 using index idx(-)) - 99 order by 1;

evaluate 'ORDER BY with a subquery of USING INDEX idx(+): 10 rows';
select c as k, count(*) from t group by k order by (select count(*) from t where c > 5 using index idx(+)), 1;

evaluate 'HAVING with a subquery of USING INDEX idx: 5 rows (6 to 10)';
select c, count(*) from t group by c having c in (select c from t where c > 5 using index idx) order by 1;

evaluate 'WHERE with a subquery of USING INDEX idx(+) (no problem before): 5 rows (6 to 10)';
select c, count(*) from t where c in (select c from t where c > 5 using index idx(+)) group by c order by 1;


drop table t;

--+ server-message off
