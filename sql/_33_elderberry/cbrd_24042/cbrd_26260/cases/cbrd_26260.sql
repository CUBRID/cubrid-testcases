-- Verification for CBRD-26260 : LEFT JOIN View-Merge Optimization

drop table if exists tbl_a;
drop table if exists tbl_b;
drop table if exists tbl_c;

create table tbl_a(cola int, colb int, CONSTRAINT [pk] PRIMARY KEY  (cola,colb));
insert into tbl_a values (1,1),(2,2),(3,3),(4,4);

create table tbl_b(colb int primary key, x int);
-- partially matches with tbl_a
insert into tbl_b values (1,10),(2,20),(4,40);

create table tbl_c(colc int primary key, y int);
-- partially matches with tbl_a
insert into tbl_c values (2,200),(3,300);

create or replace view view_b as select colb, x from tbl_b where x >= 10;
create or replace view view_c as select colc, y from tbl_c where y >= 200;

evaluate '1. Single table LEFT JOIN (inline view, mergable)';
select /*+ recompile */ count(*) from tbl_a a left outer join (select cola,colb from tbl_a where cola = 1) b on a.colb = b.colb;

evaluate '2. Single table LEFT JOIN (Oracle compatible, mergable)';
select /*+ recompile */ count(*) from tbl_a a, (select cola,colb from tbl_a where cola = 1) b 
where a.colb = b.colb(+);

evaluate '3. view LEFT JOIN table (mergable)';
create or replace view view_a as select cola,colb from tbl_a where cola = 1;
select /*+ recompile */ count(*) from tbl_a a left outer join view_a b on a.colb = b.colb;

evaluate '4. view LEFT JOIN table (Oracle compatible, mergable)';
select /*+ recompile */ count(*) from tbl_a a, view_a b where a.colb = b.colb(+);

evaluate '5. A LEFT JOIN (single-table inline view B) + INNER JOIN C (mergable)';
select /*+ recompile */ count(*)
from tbl_a a
left join (select colb, x from tbl_b where x >= 10) b on a.colb = b.colb
join tbl_c c on c.colc = a.cola;

evaluate '6. A LEFT JOIN (view view_b) + INNER JOIN C (mergable)';
select /*+ recompile */ count(*)
from tbl_a a
left join view_b b on a.colb = b.colb
join tbl_c c on c.colc = a.cola;

evaluate '7. Oracle compatible (+) A and B are outer + inner join C (mergable)';
select /*+ recompile */ count(*)
from tbl_a a, (select colb, x from tbl_b where x >= 10) b, tbl_c c
where a.colb = b.colb(+)
  and c.colc = a.cola;

evaluate '8. LEFT JOIN converted to INNER JOIN (mergable)';
select /*+ recompile */ count(*)
from tbl_a a
left join (select colb, x from tbl_b where x >= 10) b on a.colb = b.colb
where b.x > 15;

evaluate '9. Mixed LEFT JOIN + RIGHT JOIN (no mergable)';
select /*+ recompile */ count(*)
from (tbl_a a
      left join (select colb, x from tbl_b where x >= 10) b on a.colb = b.colb)
right join (select colc, y from tbl_c where y >= 200) d on a.cola = d.colc;

evaluate '10. LEFT JOIN + RIGHT JOIN using views (no mergable)';
select /*+ recompile */ count(*)
from (tbl_a a left join view_b b on a.colb = b.colb)
right join view_c d on a.cola = d.colc;

evaluate '11. View with key-only filter (mergable)';
create or replace view view_b_key as select colb, x from tbl_b where colb in (1,2);
select /*+ recompile */ count(*) as cnt
from tbl_a a left join view_b_key b on a.colb = b.colb;

evaluate '12. Chained LEFT JOIN (A LEFT JOIN view_b LEFT JOIN view_c, mergable)';
select /*+ recompile */ count(*) as cnt
from tbl_a a
left join view_b b on a.colb = b.colb
left join view_c c on a.cola = c.colc;

evaluate '13. View with DISTINCT (no mergable)';
create or replace view view_b_distinct as select distinct colb, x from tbl_b where x >= 10;
select /*+ recompile */ count(*) as cnt
from tbl_a a left join view_b_distinct b on a.colb = b.colb;

evaluate '14. Prepared statement: LEFT JOIN with inline view (mergable)';
prepare sc from '
  SELECT /*+ recompile */ COUNT(*) AS cnt
  FROM tbl_a a
  LEFT JOIN (SELECT colb, x FROM tbl_b WHERE x >= ?) b
  ON a.colb = b.colb
  WHERE a.cola BETWEEN ? AND ?';
--@queryplan
execute sc using 10, 1, 4;
deallocate prepare sc;

evaluate '15. Prepared statement: LEFT JOIN with view_b (mergable)';
prepare sc from '
  SELECT /*+ recompile */ COUNT(*) AS cnt
  FROM tbl_a a
  LEFT JOIN view_b b
  ON a.colb = b.colb
  WHERE b.x >= ? AND a.cola BETWEEN ? AND ?';
--@queryplan
execute sc using 10, 1, 4;
deallocate prepare sc;

evaluate '16. View on left side of LEFT JOIN (view_a preserved) (mergable)';
select /*+ recompile */ count(*) as cnt
from view_a a
left join tbl_b b on a.colb = b.colb;

evaluate '17. View with GROUP BY (no mergable)';
create or replace view view_b_group as
select colb, sum(x) as sx
from tbl_b
group by colb;
select /*+ recompile */ count(*) as cnt
from tbl_a a
left join view_b_group b on a.colb = b.colb;

evaluate '18. LEFT JOIN + IS NULL filter using view_b (no mergable)';
select /*+ recompile */ count(*) as cnt
from tbl_a a
left join view_b b on a.colb = b.colb
where b.colb is null;

evaluate '19. LEFT JOIN view_b with extra filter on preserved table (mergable)';
select /*+ recompile */ count(*) as cnt
from tbl_a a
left join view_b b on a.colb = b.colb
where a.cola between 2 and 4;

evaluate '20. Prepared statement: LEFT JOIN with parameterized ON clause (mergable)';
prepare sc from '
SELECT /*+ recompile */ COUNT(*) AS cnt
FROM tbl_a a
LEFT JOIN (
SELECT colb, x
FROM tbl_b
WHERE x >= 10
) b
ON a.colb = b.colb
AND b.x >= ?
WHERE a.cola BETWEEN ? AND ?';

--@queryplan
execute sc using 20, 1, 4;
deallocate prepare sc;

drop table if exists tbl_a;
drop table if exists tbl_b;
drop table if exists tbl_c;

