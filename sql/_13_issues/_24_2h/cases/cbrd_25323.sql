-- This test case verifies CBRD-25323 issue.
-- Also, this test case is an extension of CBRD-25277.
-- The 'Eliminate INNER JOIN' optimization is performed for the first table, and the join type for the second table is removed. 
-- If the join type for the second table is OUTER JOIN, the 'Eliminate INNER JOIN' optimization is not performed for the first table.

drop table if exists tb_child;
drop table if exists ta_parent;
drop table if exists tc_dummy;

evaluate 'test data';
create table ta_parent (p_ca int primary key, p_cb int);
create table tb_child (c_ca int primary key, c_cb int);
alter table tb_child add c_parent_ca int not null references ta_parent (p_ca);
create table tc_dummy (d_ca int primary key, d_cb int);

insert into ta_parent values (1, 1);
insert into tb_child values (2, 2, 1);
insert into tb_child values (3, 3, 1);
insert into tc_dummy values (2, 20);
insert into tc_dummy values (4, 40);

update statistics on ta_parent with fullscan;
update statistics on tb_child with fullscan;
update statistics on tc_dummy with fullscan;


--Eliminate INNER JOIN optimization is not performed.
-- The join type of the second table is LEFT OUTER JOIN
-- With ANSI JOIN syntax' 
evaluate 'test case 7';
select /*+ recompile ordered */
  c.c_cb, d.d_cb
from
  ta_parent p
  left outer join tc_dummy d /* With ANSI JOIN syntax */
    on d.d_ca = 2
  inner join tb_child c on c.c_parent_ca = p.p_ca;


---Eliminate INNER JOIN optimization is performed.
--The join type of the second table is LEFT OUTER JOIN
--With ORACLE JOIN syntax
evaluate 'test case 8';
select /*+ recompile ordered */
  c.c_cb, d.d_cb
from
  ta_parent p,
  tc_dummy d, /* With ORACLE JOIN syntax */
  tb_child c
where
  d.d_ca(+) = 2
  and c.c_parent_ca = p.p_ca;


---Eliminate INNER JOIN optimization is not performed.
--The join type of the second table is LEFT OUTER JOIN
--With ORACLE JOIN syntax
evaluate 'test case 9';
select /*+ recompile ordered */
  c.c_cb, d.d_cb
from
  ta_parent p,
  tc_dummy d, /* With ORACLE JOIN syntax */
  tb_child c
where
  d.d_ca(+) = c.c_ca
  and c.c_parent_ca = p.p_ca;


---Eliminate INNER JOIN optimization is not performed.
--The join type of the second table is NATURAL JOIN
--With ANSI JOIN syntax
evaluate 'test case 10';
select /*+ recompile ordered */
  c.c_cb, t_p.p_cb
from
  ta_parent p
  natural join ta_parent t_p /* With ANSI JOIN syntax */
  inner join tb_child c on c.c_parent_ca = p.p_ca;


---Eliminate INNER JOIN optimization is performed.
--The join type of the second table is NATURAL JOIN
--With ANSI JOIN syntax
evaluate 'test case 11';
select /*+ recompile ordered */
  c.c_cb, t_c.c_cb
from
  ta_parent p
  natural join tb_child t_c /* With ANSI JOIN syntax */
  inner join tb_child c on c.c_parent_ca = p.p_ca;


---Eliminate INNER JOIN optimization is not performed.
--The join type of the second table is RIGHT OUTER JOIN
--With ANSI JOIN syntax
evaluate 'test case 12';
select /*+ recompile ordered */
  c.c_cb, d.d_cb
from
  ta_parent p
  right outer join tc_dummy d /* With ANSI JOIN syntax */
    on d.d_ca = 2
  inner join tb_child c on c.c_parent_ca = p.p_ca;


---Eliminate INNER JOIN optimization is performed.
--The join type of the second table is RIGHT OUTER JOIN
--With ORACLE JOIN syntax
evaluate 'test case 13';
select /*+ recompile ordered */
  c.c_cb, d.d_cb
from
  ta_parent p,
  tc_dummy d, /* With ORACLE JOIN syntax */
  tb_child c
where
  d.d_ca = c.c_ca(+)
  and c.c_parent_ca = p.p_ca;


---Eliminate INNER JOIN optimization is performed.
--The join type of the second table is CROSS JOIN
--With ANSI JOIN syntax
evaluate 'test case 14';
select /*+ recompile ordered */
  c.c_cb, d.d_cb
from
  ta_parent p
  cross join tc_dummy d /* With ANSI JOIN syntax */
  inner join tb_child c on c.c_parent_ca = p.p_ca;
	

---Eliminate INNER JOIN optimization is performed.
--The join type of the second table is CROSS JOIN
--With ORACLE JOIN syntax
evaluate 'test case 15';
select /*+ recompile ordered */
  c.c_cb, d.d_cb
from
  ta_parent p,
  tc_dummy d, /* With ORACLE JOIN syntax */
  tb_child c
where
  c.c_parent_ca = p.p_ca;


drop table if exists tb_child;
drop table if exists ta_parent;
drop table if exists tc_dummy;
