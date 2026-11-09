-- CBRD-27904: x OR NULL was folded to x and x AND NULL to NULL, so NOT, IS, XOR and CASE over them
-- returned wrong results. A NULL term may act as FALSE only in a filter, after NOT is pushed down.

drop table if exists t1, t5, u1;

-- 1. x AND c and x OR c for x = TRUE (id 1), FALSE (id 2), UNKNOWN (id 3) and c = TRUE, FALSE, NULL:
--    v = CASE result, u = IS UNKNOWN, f = IS FALSE, x = XOR TRUE
create table t5 (id int primary key, k int);
insert into t5 values (1, 5), (2, 6), (3, null);

-- AND TRUE: T F U
select id, case when (k = 5 and 1 = 1) then 'T' when not (k = 5 and 1 = 1) then 'F' else 'U' end v,
       if ((k = 5 and 1 = 1) is unknown, 1, 0) u, if ((k = 5 and 1 = 1) is false, 1, 0) f,
       case when (k = 5 and 1 = 1) xor (1 = 1) then 'T' when not ((k = 5 and 1 = 1) xor (1 = 1)) then 'F' else 'U' end x
from t5 order by id;
-- AND FALSE: F F F
select id, case when (k = 5 and 1 = 0) then 'T' when not (k = 5 and 1 = 0) then 'F' else 'U' end v,
       if ((k = 5 and 1 = 0) is unknown, 1, 0) u, if ((k = 5 and 1 = 0) is false, 1, 0) f,
       case when (k = 5 and 1 = 0) xor (1 = 1) then 'T' when not ((k = 5 and 1 = 0) xor (1 = 1)) then 'F' else 'U' end x
from t5 order by id;
-- AND NULL: U F U
select id, case when (k = 5 and k = null) then 'T' when not (k = 5 and k = null) then 'F' else 'U' end v,
       if ((k = 5 and k = null) is unknown, 1, 0) u, if ((k = 5 and k = null) is false, 1, 0) f,
       case when (k = 5 and k = null) xor (1 = 1) then 'T' when not ((k = 5 and k = null) xor (1 = 1)) then 'F' else 'U' end x
from t5 order by id;
-- OR TRUE: T T T
select id, case when (k = 5 or 1 = 1) then 'T' when not (k = 5 or 1 = 1) then 'F' else 'U' end v,
       if ((k = 5 or 1 = 1) is unknown, 1, 0) u, if ((k = 5 or 1 = 1) is false, 1, 0) f,
       case when (k = 5 or 1 = 1) xor (1 = 1) then 'T' when not ((k = 5 or 1 = 1) xor (1 = 1)) then 'F' else 'U' end x
from t5 order by id;
-- OR FALSE: T F U
select id, case when (k = 5 or 1 = 0) then 'T' when not (k = 5 or 1 = 0) then 'F' else 'U' end v,
       if ((k = 5 or 1 = 0) is unknown, 1, 0) u, if ((k = 5 or 1 = 0) is false, 1, 0) f,
       case when (k = 5 or 1 = 0) xor (1 = 1) then 'T' when not ((k = 5 or 1 = 0) xor (1 = 1)) then 'F' else 'U' end x
from t5 order by id;
-- OR NULL: T U U
select id, case when (k = 5 or k = null) then 'T' when not (k = 5 or k = null) then 'F' else 'U' end v,
       if ((k = 5 or k = null) is unknown, 1, 0) u, if ((k = 5 or k = null) is false, 1, 0) f,
       case when (k = 5 or k = null) xor (1 = 1) then 'T' when not ((k = 5 or k = null) xor (1 = 1)) then 'F' else 'U' end x
from t5 order by id;
-- IF and IS NOT TRUE / IS NOT FALSE
select id, if (not (k = 5 or k = null), 1, 0), if (not (k = 5 and k = null), 1, 0),
       if ((k = 5 or k = null) is not true, 1, 0), if ((k = 5 and k = null) is not false, 1, 0)
from t5 order by id;

-- 2. NOT in every filter: k = mod (id, 20) for id 1 .. 200, NULL for id 201 .. 205
create table t1 (id int primary key, k int);
insert into t1 select rownum, mod (rownum, 20) from db_class a, db_class b limit 200;
insert into t1 values (201, null), (202, null), (203, null), (204, null), (205, null);
create index i_t1_k on t1 (k);
update statistics on t1 with fullscan;

-- WHERE: 0, 190, 190
select count (*) from t1 where not (k = 5 or k = null);
select count (*) from t1 where not (k = 5 and k = null);
select count (*) from t1 where not (k = null and k = 5);
-- JOIN ON: 0, 190
select count (b.id) from t1 a left join t1 b on a.id = b.id and not (b.k = 5 or b.k = null);
select count (b.id) from t1 a left join t1 b on a.id = b.id and not (b.k = 5 and b.k = null);
-- HAVING: no row, 19
select k from t1 group by k having not (k = 5 or k = null) order by k;
select count (*) from (select k from t1 group by k having max (k) = null or max (k) > 0) x;
-- START WITH (10 starts with k = 1, each followed by k = 2): 20
select count (*) from t1 start with not (k <> 1 and k = null) connect by prior id + 1 = id and k < 3;
-- CONNECT BY: 1 (stops at id 2), 4 (stops at id 5)
select count (*) from t1 start with id = 1 connect by prior id + 1 = id and not (k = 5 or k = null);
select count (*) from t1 start with id = 1 connect by prior id + 1 = id and not (k = 5 and k = null);
-- the filter after CONNECT BY (WHERE of a hierarchical query) over id 1 .. 10: 9
select count (*) from t1 where not (k = 5 and k = null) start with id = 1 connect by prior id + 1 = id and id <= 10;
-- ORDER BY ... FOR: id 1 .. 3
select id from t1 order by id for not (orderby_num () > 3 and orderby_num () = null);
-- host variable: 0, 180, 190
prepare s1 from 'select count (*) from t1 where not (k = 5 or k = ?)';
execute s1 using null;
execute s1 using 6;
deallocate prepare s1;
prepare s1 from 'select count (*) from t1 where not (k = 5 and k = ?)';
execute s1 using null;
deallocate prepare s1;

-- UPDATE, DELETE, MERGE: 0, 205, 0, 205, 190
create table u1 (id int primary key, k int);
insert into u1 select * from t1;
update u1 set k = -1 where not (k = 5 or k = null);
select count (*) from u1 where k = -1;
delete from u1 where not (k = 5 or k = null);
select count (*) from u1;
merge into u1 using t1 s on (u1.id = s.id)
  when matched then update set u1.k = -1 where not (s.k = 5 or s.k = null);
select count (*) from u1 where k = -1;
merge into u1 using t1 s on (u1.id = s.id)
  when matched then update set u1.k = u1.k delete where not (s.k = 5 or s.k = null);
select count (*) from u1;
delete from u1;
merge into u1 using t1 s on (u1.id = s.id)
  when not matched then insert values (s.id, s.k) where not (s.k = 5 and s.k = null);
select count (*) from u1;

-- 3. a NULL in the OR lists of a filter is dropped
-- head, consecutive, only NULLs, several OR lists: 10, 20, 0, 10
select count (*) from t1 where k = null or k = 5;
select count (*) from t1 where k = 5 or k = null or k = null or k = 6;
select count (*) from t1 where k = null or k = null;
select count (*) from t1 where (k = null or k = 5) and (id > 3 or k = null);
-- the index is used, and NOT over it is always false: 10, 0, 10
--@queryplan
select count (*) from t1 where k = 5 or k = null;
--@queryplan
select count (*) from t1 where not (k = 5 or k = null);
--@queryplan
select count (*) from t1 where not (k <> 5 and k <> null);

-- 4. a NULL joined by AND makes the condition always false: 0, 0, id 1, 0
--@queryplan
select count (*) from t1 where k = 5 and k = null;
--@queryplan
select count (*) from t1 where k > 3 and (id < 100 and k = null);
select id from t1 where id = 1 union all select id from t1 where k = 5 and k = null;
select count (b.id) from t1 a left join t1 b on a.id = b.id where b.k = 5 and b.k = null;

drop table t1, t5, u1;
