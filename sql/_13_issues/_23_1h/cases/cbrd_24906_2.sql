

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
prepare q from '
select /*+ recompile */
  count (*)
from
  (
    select /*+ no_merge ordered */
      a.*
    from
      tbl_a as a, tbl_b as b
    where a.col_a = b.col_a
      and a.col_c = ?
      and a.col_c = ?
  )';
execute q using 1, 9;
show trace;
deallocate prepare q;


-- test case 2
prepare q from '
select /*+ recompile */
  t.col_a
from
  (
    select /*+ no_merge ordered */
      a.*
    from
      tbl_a as a, tbl_b as b
    where a.col_a = b.col_a
      and a.col_b = ?
      and a.col_b = ?
  ) as t
limit 999, 1';
execute q using 1, 9;
show trace;
deallocate prepare q;


-- test case 3
prepare q from '
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
      and a.col_c = ?
  )
';
execute q using 9;
show trace;
deallocate prepare q;


-- test case 4
prepare q from '
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
      and a.col_c = ?
  )
'; 
execute q using 1;
show trace;
deallocate prepare q;


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
prepare q from '
select /*+ recompile */
  a.col_a,
  (select /*+ no_merge ordered */ b.col_b from tbl_b as b where b.col_c = ? and b.col_c = ? limit 1) as c9
from
  tbl_a as a
limit 999, 1
';
execute q using 1,9;
show trace;
deallocate prepare q;


-- test case 7
prepare q from '
select /*+ recompile */
  a.col_a,
  (select /*+ no_merge ordered */ b.col_c from tbl_b as b where a.col_a = b.col_a and b.col_c = ? and b.col_c = ?) as c9
from
  tbl_a as a
limit 999, 1
';
execute q using 1, 9;
show trace;
deallocate prepare q;


-- test case 8
prepare q from '
select /*+ recompile */
  count (*)
from
  tbl_a as a
where
  exists (select /*+ no_merge ordered */ 1 from tbl_b as b where a.col_a = b.col_a and b.col_c = ? and b.col_c = ?)
';
execute q using 1, 9;
show trace;
deallocate prepare q;


-- test case 9
prepare q from '
select /*+ recompile */
  count (*)
from
  tbl_a as a
where
  exists (select /*+ no_merge ordered */ 1 from tbl_b as b, tbl_c as c where a.col_a = b.col_a and b.col_a = c.col_a and c.col_c = ? and c.col_c = ?)
';
execute q using 1, 9;
show trace;
deallocate prepare q;


-- test case 10 
prepare q from '
select /*+ recompile */
  count (*)
from
  tbl_a as a
where
  a.col_a in (select /*+ no_merge ordered */ b.col_a from tbl_b as b where b.col_c = ? and b.col_c = ?)
';
execute q using 1,9;
show trace;
deallocate prepare q;


-- test case 11 
prepare q from '
select /*+ recompile */
  count (*)
from
  tbl_a as a
where
  a.col_b in (select /*+ no_merge ordered */ b.col_b from tbl_b as b where a.col_a = b.col_a and b.col_c = ? and b.col_c = ?)
';
execute q using 1, 9;
show trace;
deallocate prepare q;


-- test case 12 
prepare q from '
select /*+ recompile */
  count (*)
from
  tbl_a as a
where
  a.col_a in (select /*+ no_merge ordered */ c.col_a from tbl_b as b, tbl_c as c where b.col_a = c.col_a and c.col_c = ? and c.col_c = ?)
';
execute q using 1,9;
show trace;
deallocate prepare q;


-- test case 13 
prepare q from '
select /*+ recompile */
  count (*)
from
  tbl_a as a
where
  a.col_a in (select /*+ no_merge ordered */ b.col_b from tbl_b as b where a.col_a = b.col_a and b.col_c = ? and b.col_c = ?)
';
execute q using 1, 9;
show trace;
deallocate prepare q;


-- test case 14 
prepare q from '
select /*+ recompile */
  count (*)
from
  tbl_a as a
  left outer join (select /*+ no_merge ordered */ bb.col_a, bb.col_b, bb.col_c from tbl_b as bb where bb.col_c = ? and bb.col_c = ?) b on a.col_a = b.col_a
';
execute q using 1, 9;
show trace;
deallocate prepare q;

prepare q from '
select /*+ recompile */
  count (*)
from
  tbl_a as a,
  (select /*+ no_merge ordered */ bb.col_a, bb.col_b, bb.col_c from tbl_b as bb where bb.col_c = ? and bb.col_c = ?) b
where a.col_a = b.col_a (+)
';
execute q using 1, 9;
show trace;
deallocate prepare q;


-- test case 15 
prepare q from '
select /*+ recompile */
  count (*)
from
  tbl_a as a
  left outer join (select /*+ no_merge ordered */ bb.col_a, bb.col_b, bb.col_c from tbl_b as bb where bb.col_b = ?) b on a.col_a = b.col_a and b.col_b = ?
';
execute q using 1, 9;
show trace;
deallocate prepare q;

prepare q from '
select /*+ recompile */
  count (*)
from
  tbl_a as a,
  (select /*+ no_merge ordered */ bb.col_a, bb.col_b, bb.col_c from tbl_b as bb where bb.col_b = ?) b 
where a.col_a = b.col_a (+)
and b.col_b (+) = ?
';
execute q using 1,9;
show trace;
deallocate prepare q;


-- test case 16 
prepare q from '
select /*+ recompile */
  count (*)
from
  tbl_a as a
  left outer join (select /*+ no_merge ordered */ bb.col_a, bb.col_b, bb.col_c from tbl_b as bb where bb.col_c = ? and bb.col_c = ?) as b on a.col_a = b.col_a
  left outer join (select /*+ no_merge ordered */ cc.col_a, cc.col_b, cc.col_c from tbl_c as cc where cc.col_c = ?) as c on b.col_b = c.col_b
';
execute q using 1, 9, 1;
show trace;
deallocate prepare q;

prepare q from '
select /*+ recompile */
  count (*)
from
  tbl_a as a,
  (select /*+ no_merge ordered */ bb.col_a, bb.col_b, bb.col_c from tbl_b as bb where bb.col_c = ? and bb.col_c = ?) as b,
  (select /*+ no_merge ordered */ cc.col_a, cc.col_b, cc.col_c from tbl_c as cc where cc.col_c = ?) as c
where a.col_a = b.col_a (+)
and b.col_b = c.col_b (+)
';
execute q using 1, 9, 1;
show trace;
deallocate prepare q;


-- test case 17 
prepare q from '
with b as
  (
    select /*+ no_merge ordered */ bb.col_a, bb.col_b, bb.col_c from tbl_b as bb where bb.col_c = ? and bb.col_c = ?
  )
select /*+ recompile */
  count (*)
from
  tbl_a as a
  left outer join b as b on a.col_a = b.col_a
';
execute q using 1, 9;
show trace;
deallocate prepare q;

prepare q from '
with b as
  (
    select /*+ no_merge ordered */ bb.col_a, bb.col_b, bb.col_c from tbl_b as bb where bb.col_c = ? and bb.col_c = ?
  )
select /*+ recompile */
  count (*)
from
  tbl_a as a,
  b as b
where a.col_a = b.col_a (+)
';
execute q using 1, 9;
show trace;
deallocate prepare q;


-- test case 18 
prepare q from '
select /*+ recompile */
  count(*)
from
  (
    (select /*+ no_merge ordered */ a.col_a, a.col_b, a.col_c from tbl_a as a)
    union
    (select /*+ no_merge ordered */ b.col_a, b.col_b, b.col_c from tbl_b as b where b.col_c = ? and b.col_c = ?)
  )
';
execute q using 1, 9;
show trace;
deallocate prepare q;


-- test case 19 
prepare q from '
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
      a.col_a = ? and a.col_a = ?
  ) as t
';
execute q using 1, 9;
show trace;
deallocate prepare q;


-- test case 20 
prepare q from '
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
      a.col_c = ? and a.col_c = ?
  ) as t
';
execute q using 1, 9;
show trace;
deallocate prepare q;


-- test case 21 
prepare q from '
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
      max (a.col_c) = ? and max (a.col_c) = ?
  ) as t
';
execute q using 1,9;
show trace;
deallocate prepare q;


-- test case 22 
prepare q from '
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
      and abs (a.col_c) = ?
  ) as t
';
execute q using -1;
show trace;
deallocate prepare q;


-- test case 23 
prepare q from '
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
      and a.col_c = ?
  ) as t
where
  t.col_c = ?
';
execute q using 1, 9;
show trace;
deallocate prepare q;


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
