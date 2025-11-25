-- Verification for CBRD-26263
-- Test for LEFT OUTER JOIN with view
-- The existing table-elimination optimization did not work
-- when the right-hand side was a view with distributed join conditions.
-- This test checks that the issue is fixed.

drop table if exists tbl;
create table tbl(cola int, colb int, CONSTRAINT [pk] PRIMARY KEY  (cola,colb));
insert into tbl values (1, 10), (1, 20), (2, 10), (2, 30), (3, 30), (3, 40);


-- When using LEFT OUTER JOIN
select *
from tbl a left outer join tbl b on b.cola = 1 and a.colb = b.colb;

-- When using LEFT OUTER JOIN with an inline view
select *
from tbl a left outer join (select cola, colb from tbl where cola = 1) b on a.colb = b.colb;

-- When using a view
create or replace view v as select cola, colb from tbl where cola = 1;
select * from tbl a left outer join v b on a.colb = b.colb;

drop table if exists tbl;
