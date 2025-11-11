-- Verification for CBRD-26075
-- Issue: Problem with incorrect results being retrieved when comparing columns 
--        in the main query within the HAVING clause.

drop table if exists tbl_a;
drop table if exists tbl_b;

create table tbl_a (id int, col varchar(10));
insert into tbl_a values (1, '10'), (1, '20'), (1, '30'), (1, '15');

create table tbl_b (id int, col varchar(10));
insert into tbl_b values (1, '20'), (1, '30'), (1, '15');

evaluate 'case 1. HAVING compares a.col';
select a.col
from tbl_a a
where exists (
    select 1
      from tbl_b b
     group by b.id
    having max(b.col) = a.col
);

evaluate 'case 2. HAVING + UNION ALL comparing a.col';
select /*+ recompile */ a.col
from tbl_a a
where exists (
    select 1
      from tbl_b b
     where id = 2
    union all
    select 1
      from tbl_b b
     group by b.id
    having max(b.col) = a.col
);

evaluate 'case 3. HAVING uses expression with outer column';
select a.col
from tbl_a a
where exists (
    select 1
      from tbl_b b
     group by b.id
    having max(b.col) = substring(a.col, 1, 2)
);

evaluate 'case 4. Nested subquery HAVING references outer column';
select a.col
from tbl_a a
where exists (
    select 1
      from (
          select id, max(col) as mcol
          from tbl_b
          group by id
          having max(col) = a.col
      ) x
);

evaluate 'case 5. Inner subquery inside HAVING references outer column';
select a.col
from tbl_a a
where exists (
    select 1
      from tbl_b b
     group by b.id
    having (select max(col) from tbl_b where id = b.id) = a.col
);

drop table if exists tbl_c;
drop table if exists tbl_d;

create table tbl_c (id int, num int);
insert into tbl_c values (1, 11), (2, 11);

create table tbl_d (id int, num int);
insert into tbl_d values (1, 1), (1, 10), (1, 5), (2, 1), (2, 100), (2, 5);

evaluate 'case 6. HAVING compares c.num';
select /*+ recompile */ *
from tbl_c c
where exists (
    select 1
      from tbl_d d
     where d.id = c.id
     group by d.id
    having max(d.num) < c.num
);

evaluate 'case 7. HAVING compares with numeric expression';
select /*+ recompile */ *
from tbl_c c
where exists (
    select 1
      from tbl_d d
     where d.id = c.id
     group by d.id
    having max(d.num) + 1 > c.num
);


evaluate 'case 8. Control query for validation (no main column in HAVING)';
select (
    select 1
      from tbl_d d
     where d.id = c.id
     group by d.id
    having max(d.num) < c.num
)
from tbl_c c;

drop table if exists tbl_a;
drop table if exists tbl_b;
drop table if exists tbl_c;
drop table if exists tbl_d;
