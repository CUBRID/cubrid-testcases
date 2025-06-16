

drop table if exists tbl_a, tbl_b, tbl_c;
create table tbl_a (col_a int primary key, col_b int, col_c int);
create table tbl_b (col_a int primary key, col_b int, col_c int);
create table tbl_c (col_a int primary key, col_b int, col_c int);
insert into tbl_a select rownum, rownum, rownum from db_class a, db_class b, db_class c limit 1000;
insert into tbl_b select rownum, rownum, rownum from db_class a, db_class b, db_class c limit 1000;
insert into tbl_c select rownum, rownum, rownum from db_class a, db_class b, db_class c limit 1000;

update statistics on all classes with fullscan;

set trace on;


-- test case 1
select /*+ recompile */
  count (*)
from
  (
    select /*+ no_merge ordered */
      a.*
    from
      tbl_a as a, tbl_b as b
    where a.col_a = b.col_a
      and a.col_c = 1
      and a.col_c = 9
  );
show trace;


-- test case 2
select /*+ recompile */
  t.col_a
from
  (
    select /*+ no_merge ordered */
      a.*
    from
      tbl_a as a, tbl_b as b
    where a.col_a = b.col_a
      and a.col_b = 1
      and a.col_b = 9
  ) as t
limit 999, 1;
show trace;


-- test case 3
select /*+ recompile */
  count (*)
from
  (
    select /*+ no_merge ordered */
      a.*
    from
      tbl_a as a, tbl_b as b
    where
      a.col_a = b.col_a
      and a.col_c in (1, 2, 3, 4, 5)
      and a.col_c = 9
  );
show trace;


-- test case 4
select /*+ recompile */
  count (*)
from
  (
    select /*+ no_merge ordered */
      a.*
    from
      tbl_a as a, tbl_b as b
    where
      a.col_a = b.col_a
      and a.col_c is null
      and a.col_c = 1
  );
show trace;


-- test case 5
select /*+ recompile */
  count(*)
from
  (
    select /*+ no_merge ordered */
      a.*
    from
      tbl_a as a, tbl_b as b
    where
      a.col_a = b.col_a
      and a.col_c is null
      and a.col_c is not null
  );
show trace;


-- test case 6
select /*+ recompile */
  a.col_a,
  (select /*+ no_merge ordered */ b.col_b from tbl_b as b where b.col_c = 1 and b.col_c = 9 limit 1) as c9
from
  tbl_a as a
limit 999, 1;
show trace;


-- test case 7
select /*+ recompile */
  a.col_a,
  (select /*+ no_merge ordered */ b.col_c from tbl_b as b where a.col_a = b.col_a and b.col_c = 1 and b.col_c = 9) as c9
from
  tbl_a as a
limit 999, 1;
show trace;


-- test case 8
select /*+ recompile */
  count (*)
from
  tbl_a as a
where
  exists (select /*+ no_merge ordered */ 1 from tbl_b as b where a.col_a = b.col_a and b.col_c = 1 and b.col_c = 9);
show trace;


-- test case 9
select /*+ recompile */
  count (*)
from
  tbl_a as a
where
  exists (select /*+ no_merge ordered */ 1 from tbl_b as b, tbl_c as c where a.col_a = b.col_a and b.col_a = c.col_a and c.col_c = 1 and c.col_c = 9);
show trace;


-- test case 10 
select /*+ recompile */
  count (*)
from
  tbl_a as a
where
  a.col_a in (select /*+ no_merge ordered */ b.col_a from tbl_b as b where b.col_c = 1 and b.col_c = 9);
show trace;


-- test case 11 
select /*+ recompile */
  count (*)
from
  tbl_a as a
where
  a.col_b in (select /*+ no_merge ordered */ b.col_b from tbl_b as b where a.col_a = b.col_a and b.col_c = 1 and b.col_c = 9);
show trace;


-- test case 12 
select /*+ recompile */
  count (*)
from
  tbl_a as a
where
  a.col_a in (select /*+ no_merge ordered */ c.col_a from tbl_b as b, tbl_c as c where b.col_a = c.col_a and c.col_c = 1 and c.col_c = 9);
show trace;


-- test case 13 
select /*+ recompile */
  count (*)
from
  tbl_a as a
where
  a.col_a in (select /*+ no_merge ordered */ b.col_b from tbl_b as b where a.col_a = b.col_a and b.col_c = 1 and b.col_c = 9);
show trace;


-- test case 14 
select /*+ recompile */
  count (*)
from
  tbl_a as a
  left outer join (select /*+ no_merge ordered */ bb.col_a, bb.col_b, bb.col_c from tbl_b as bb where bb.col_c = 1 and bb.col_c = 9) b on a.col_a = b.col_a;
show trace;

select /*+ recompile */
  count (*)
from
  tbl_a as a,
  (select /*+ no_merge ordered */ bb.col_a, bb.col_b, bb.col_c from tbl_b as bb where bb.col_c = 1 and bb.col_c = 9) b
where a.col_a = b.col_a (+);
show trace;


-- test case 15 
select /*+ recompile */
  count (*)
from
  tbl_a as a
  left outer join (select /*+ no_merge ordered */ bb.col_a, bb.col_b, bb.col_c from tbl_b as bb where bb.col_b = 1) b on a.col_a = b.col_a and b.col_b = 9;
show trace;

select /*+ recompile */
  count (*)
from
  tbl_a as a,
  (select /*+ no_merge ordered */ bb.col_a, bb.col_b, bb.col_c from tbl_b as bb where bb.col_b = 1) b 
where a.col_a = b.col_a (+)
and b.col_b (+) = 9;
show trace;


-- test case 16 
select /*+ recompile */
  count (*)
from
  tbl_a as a
  left outer join (select /*+ no_merge ordered */ bb.col_a, bb.col_b, bb.col_c from tbl_b as bb where bb.col_c = 1 and bb.col_c = 9) as b on a.col_a = b.col_a
  left outer join (select /*+ no_merge ordered */ cc.col_a, cc.col_b, cc.col_c from tbl_c as cc where cc.col_c = 1) as c on b.col_b = c.col_b;
show trace;

select /*+ recompile */
  count (*)
from
  tbl_a as a,
  (select /*+ no_merge ordered */ bb.col_a, bb.col_b, bb.col_c from tbl_b as bb where bb.col_c = 1 and bb.col_c = 9) as b,
  (select /*+ no_merge ordered */ cc.col_a, cc.col_b, cc.col_c from tbl_c as cc where cc.col_c = 1) as c
where a.col_a = b.col_a (+)
and b.col_b = c.col_b (+);
show trace;


-- test case 17 
with b as
  (
    select /*+ no_merge ordered */ bb.col_a, bb.col_b, bb.col_c from tbl_b as bb where bb.col_c = 1 and bb.col_c = 9
  )
select /*+ recompile */
  count (*)
from
  tbl_a as a
  left outer join b as b on a.col_a = b.col_a;
show trace;

with b as
  (
    select /*+ no_merge ordered */ bb.col_a, bb.col_b, bb.col_c from tbl_b as bb where bb.col_c = 1 and bb.col_c = 9
  )
select /*+ recompile */
  count (*)
from
  tbl_a as a,
  b as b
where a.col_a = b.col_a (+);
show trace;


-- test case 18 
select /*+ recompile */
  count(*)
from
  (
    (select /*+ no_merge ordered */ a.col_a, a.col_b, a.col_c from tbl_a as a)
    union
    (select /*+ no_merge ordered */ b.col_a, b.col_b, b.col_c from tbl_b as b where b.col_c = 1 and b.col_c = 9)
  );
show trace;


-- test case 19 
select /*+ recompile */
  count (*)
from
  (
    select /*+ no_merge ordered */
      a.col_a, a.col_b, a.col_c
    from
      tbl_a as a, tbl_b as b
    where
      a.col_a = b.col_a
    group by
      a.col_a, a.col_b
    having
      a.col_a = 1 and a.col_a = 9
  ) as t;
show trace;


-- test case 20 
select /*+ recompile */
  count (*)
from
  (
    select /*+ no_merge ordered */
      a.col_a, a.col_b, a.col_c
    from
      tbl_a as a, tbl_b as b
    where
      a.col_a = b.col_a
    group by
      a.col_a, a.col_b
    having
      a.col_c = 1 and a.col_c = 9
  ) as t;
show trace;


-- test case 21 
select /*+ recompile */
  count (*)
from
  (
    select /*+ no_merge ordered */
      a.col_a, a.col_b, max (a.col_c)
    from
      tbl_a as a, tbl_b as b
    where
      a.col_a = b.col_a
    group by
      a.col_a, a.col_b
    having
      max (a.col_c) = 1 and max (a.col_c) = 9
  ) as t;
show trace;


-- test case 22 
select /*+ recompile */
  count (*)
from
  (
    select /*+ no_merge ordered */
      a.col_a, a.col_b, abs (a.col_c)
    from
      tbl_a as a, tbl_b as b
    where
      a.col_a = b.col_a
      and abs (a.col_c) = -1
  ) as t;
show trace;


-- test case 23 
select /*+ recompile */
  count (*)
from
  (
    select /*+ no_merge ordered */
      a.col_a, a.col_b, a.col_c
    from
      tbl_a as a, tbl_b as b
    where
      a.col_a = b.col_a
      and a.col_c = 1
  ) as t
where
  t.col_c = 9;
show trace;


-- test case 24 
prepare q from '
select /*+ recompile */
  count(*)
from
  (
    select /*+ no_merge ordered */
      a.col_a, a.col_b, a.col_c
    from
      tbl_a as a, tbl_b as b
    where a.col_a = b.col_a
      and a.col_c = ?
      and a.col_c = ?
  )
';
execute q using 1, 9;
show trace;
deallocate prepare q;


set trace off;

drop table if exists tbl_a, tbl_b, tbl_c;
