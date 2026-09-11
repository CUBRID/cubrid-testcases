/**
 *  This test case verifies CBRD-25447 : Support parallel heap scan
 *  In this tc, we check together CBRD-25997, 26011, 26012, 26035, 26100, 26095, 26114.
 */

drop table if exists tbl;
create table tbl (id int, cola varchar(20), colb varchar(20), colc varchar(20),cold varchar(20),cole varchar(20),colf varchar(20));
insert into tbl select rownum,lpad(rownum,20,'0'),lpad(rownum % 5,20,'0'),lpad(rownum,20,'0'),lpad(rownum,20,'0'),lpad(rownum,20,'0'),lpad(rownum,20,'0') 
from db_class a, db_class b, db_class c, db_class d, db_class e limit 4000;

set trace on;

evaluate '1. table full scan (should work) -> row by row';
select count(*) from tbl where colb <2;
show trace;


evaluate '2. NO_PARALLEL_HEAP_SCAN hint (should not work)';
select /*+ NO_PARALLEL_HEAP_SCAN */ count(*) from tbl where colb <2;
show trace;


evaluate '3. INDEX SCAN (should not work)';
create index idx_tbl_cola on tbl (cola);
select /*+ USE_IDX (idx_tbl_cola) */ count(*) from tbl where cola <2;
show trace;
drop index idx_tbl_cola on tbl;


evaluate '4. CTE recursive part(should not work), non recursive part(should work)';
with recursive cte as (
  select cola, colb from tbl where cola < 100
  union all
  select cola + 1, colb + 1 from cte where cola < 100
)
select count(*) from cte;
show trace;


evaluate '5. contains incr/decr() function(should not work)';

select /*+ PARALLEL(2) */ colb, incr(id) from tbl where id = 4000;
show trace;

select /*+ PARALLEL(2) */ colb, decr(id) from tbl where id = 4001;
show trace;


evaluate '6. contains SP in select list (should work) -> row by row (CBRD-26035, CBRD-26100)';
CREATE OR REPLACE FUNCTION sp1(n INTEGER) RETURN INTEGER DETERMINISTIC
IS
BEGIN
    return n + 1;
END;

select /*+ PARALLEL(2) */ sp1(id) from tbl where id = 1;
show trace;

drop function sp1;


evaluate '7. contains UNION, INTERSECTION, DIFFERENCE (should work) (CBRD-26011)';
select cola from tbl where id = 1 UNION select cola from tbl where id = 2;
show trace;

select cola from tbl where id = 1 INTERSECTION select cola from tbl where id = 1;
show trace;

select cola from tbl where id = 1 DIFFERENCE select cola from tbl where id = 2;
show trace;

select cola from tbl where id = 1 UNION ALL select cola from tbl where id = 1;
show trace;


evaluate '8. contains GROUP BY, ORDER BY (should work)';
evaluate '8-1. with hash aggregation -> row by row';
select cola, count(*) from tbl group by cola limit 2;
show trace;

evaluate '8-2. without hash aggregation -> mergeable list';
select /*+ NO_HASH_AGGREGATE*/ cola, count(*) from tbl group by cola limit 2;
show trace;

evaluate '8-3. should work in mergeable list';
select * from (select /*+ NO_MERGE */ cola, colb from tbl order by cola) limit 2;
show trace;


evaluate '9. contains DISTINCT (should work) -> mergeable list';
select distinct cola from tbl limit 2;
show trace;


evaluate '10. contains LIMIT (should work, order is not guaranteed) -> row by row';
select colb from tbl where id = 1 limit 1;
show trace;


evaluate '11. JOIN first table (should work) -> row by row, second table (should not work)';
select count(*) from tbl a join tbl b on a.cola = b.cola where a.id = 1;
show trace;

select /*+ recompile */ count(*) from tbl a, tbl b where a.cola = b.cola and a.id = 1;
show trace;

select /*+ ordered recompile */ count(*) from tbl b, tbl a where a.cola = b.cola and a.id = 1;
show trace;

select /*+ recompile */ count(*) from tbl a left join tbl b on a.cola = b.cola where a.id = 1;
show trace;


evaluate '12. contains uncorrelated SUBQUERY (should work) -> row by row, mergeable list';
select count(cola) from tbl where cola in (select cola from tbl);
show trace;


evaluate '13. contains PARTITION (should work) -> row by row (CBRD-26012, CBRD-26114)';
drop table if exists pl;
create table pl (cola int, colb int, colc int, cold varchar(20), cole numeric(20,10), colf varchar(20), colg varchar(20), colh varchar(20))
PARTITION BY RANGE (colb) (
  PARTITION pa VALUES LESS THAN (5),
  PARTITION pb VALUES LESS THAN (10),
  PARTITION pc VALUES LESS THAN (15),
  PARTITION pd VALUES LESS THAN (20),
  PARTITION pe VALUES LESS THAN MAXVALUE
);

insert into pl
select
  rownum,
  rownum % 20,
  1,
  lpad (to_char (rownum / 100), 20, '0'),
  rownum / 7,
  lpad (to_char (rownum / 10), 20, '0'),
  lpad (to_char (rownum % 100), 20, '0'),
  lpad (to_char (rownum % 10), 20, '0')	
from db_class a, db_class b, db_class c, db_class d
limit 20000;

select /*+ PARALLEL(2) */ count(*) from pl where colc = 1;
show trace;

drop table if exists pl;


evaluate '14. for update (should not work)';
select /*+ PARALLEL(2) */ cola from tbl order by 1 limit 2 for update;
show trace;


evaluate '15. select list contains set (should work) -> mergeable list';
drop table if exists set_tbl;
create table set_tbl (c1 set(int));
insert into set_tbl select {rownum, rownum+1, rownum+2} from db_class a, db_class b, db_class c, db_class d, db_class e limit 8000;

select c1 from set_tbl order by 1 limit 5;
show trace;

drop table if exists set_tbl;


evaluate '16. select list contains arithmetic operation (should work) -> mergeable list';
select * from (select /*+ NO_MERGE */ cola + 1 from tbl) order by 1 limit 2;
show trace;


evaluate '17. select list contains function (should work) -> mergeable list';
select * from (select /*+ NO_MERGE */ abs(cola) from tbl) order by 1 limit 2;
show trace;

select * from (select /*+ NO_MERGE */ to_char(id) from tbl) order by 1 limit 2;
show trace;

select * from (select /*+ NO_MERGE */ decode(sysdate, sysdate, cola, colb) col from tbl) order by 1 limit 2;
show trace;


evaluate '18. count(*) (buildvalue proc, result is single tuple) (should work) -> row by row';
select count(*) from tbl where id = 1;
show trace;


evaluate '19. no select list from table, no predicate from table (should work)';
select /*+ PARALLEL(2) */ count(*) from tbl;
show trace;

select /*+ PARALLEL(2) */ null from tbl limit 2;
show trace;


evaluate '20. when rownum in select list (should work) -> row by row, no order guaranteed';
select count(*) from (select /*+ NO_MERGE */ rownum, cola from tbl);
show trace;


evaluate '21. when query contains interpolation (should work) -> mergeable list';
select median(cola) from tbl group by colb;
show trace;


evaluate '22. when query contains analytic function (should work) -> mergeable list';
select * from (select /*+ NO_MERGE */ cola, lag(cola,1) over (order by cola) from tbl) order by 1 limit 2;
show trace;


evaluate '23. connect by clause (should not work)';
drop table if exists tree;
create table tree(id int, mgrid int, name varchar(32), birthyear int, dumy char(2048));
insert into tree select rownum,decode(rownum,3,1,4,1,5,2,6,2,7,6, null),'abc',2025,'' from db_class a, db_class b, db_class c, db_class d limit 200;

select id, mgrid, name from tree where id < 10
connect by prior id = mgrid order by id;
show trace;

drop table if exists tree;


evaluate '24. contains correlated SUBQUERY (should work) -> count (CBRD-26465)';
select /*+ PARALLEL(2) */ count(id) from tbl a where a.cola like '%1' and exists (select /*+ PARALLEL(2) */ 1 from tbl b where b.id=a.id);
show trace;


drop table if exists new_tbl;
create table new_tbl (id int, cola varchar(20), colb varchar(20), colc varchar(20),cold varchar(20),cole varchar(20),colf varchar(20));

evaluate '25. insert ... select statement (should work) -> mergeable list (CBRD-26095)';
insert into new_tbl select * from tbl order by id;
show trace;


evaluate '26. update statement (should not work)';
update new_tbl set cola = 'update' where colb <2;
show trace;


evaluate '27. delete statement (should not work)';
delete from new_tbl where colb <2;
show trace;


evaluate '28. Table scan with large BLOB/CLOB columns (should work) -> row by row';
drop table if exists large_tbl;
create table large_tbl (id int, data_blob BLOB, data_clob CLOB, dumy char(2048));
insert into large_tbl select rownum, X'0102030405060708090A' || repeat('FF', 1024), repeat('A', 10240),'' from db_class a, db_class b limit 300;

select count(*) from large_tbl where id > 0;
show trace;

drop table if exists large_tbl;


evaluate '29. Complex WHERE clause with AND/OR (should work) -> row by row';
select count(*) from tbl where (cola like '0%' AND colb = '00000000000000000000') OR (colc like '1%' AND cold = '00000000000000000001');
show trace;


evaluate '30. UPDATE statement with subquery in WHERE clause. subquery SELECT part (should work) -> mergeable list';
update new_tbl set cola = 'updated' where id in (select /*+ PARALLEL(2) */ id from tbl where cola like '000%');
show trace;


evaluate '31. DELETE statement with subquery in WHERE clause. subquery SELECT part (should work) -> mergeable list';
delete from new_tbl where id in (select /*+ PARALLEL(2) */ id from tbl where colb like '000%');
show trace;


evaluate '32. Parallel heap scan under different isolation levels (REPEATABLE READ) (should work) -> row by row';
set transaction isolation level repeatable read;
select count(*) from tbl where colb < 2;
show trace;


evaluate '33. Parallel heap scan under different isolation levels (SERIALIZABLE) (should work) -> row by row';
set transaction isolation level serializable;
select count(*) from tbl where colb < 2;
show trace;

set transaction isolation level read committed;


set trace off;

drop table if exists up_tbl;
create table up_tbl (id int primary key, cola varchar(20), colb varchar(20), colc varchar(20),cold varchar(20),cole varchar(20),colf varchar(20));
insert into up_tbl select rownum,lpad(rownum,20,'0'),lpad(rownum % 5,20,'0'),lpad(rownum,20,'0'),lpad(rownum,20,'0'),lpad(rownum,20,'0'),lpad(rownum,20,'0') 
from db_class a, db_class b, db_class c, db_class d, db_class e limit 4000;

set trace on;
evaluate '34. merge into, replace into statement (should not work)';
merge into up_tbl tt using tbl st on tt.id = st.id
when matched then update set cola = 'merge'
when not matched then insert values (st.id, st.cola, st.colb, st.colc, st.cold, st.cole, st.colf);
show trace;

replace into up_tbl values(1, 'replace', 'replace', 'replace', 'replace', 'replace', 'replace');
show trace;


set trace off;
drop table if exists up_tbl;
drop table if exists new_tbl;
drop table if exists tbl;
