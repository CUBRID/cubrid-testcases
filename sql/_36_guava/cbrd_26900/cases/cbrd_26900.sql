/**
 *  This test case verifies CBRD-26900: Evaluate eligible after-join predicates in the hash join probe loop
 *
 *  A hash join evaluates the residual condition of a matched pair (a non-equality condition of an inner join, or an
 *  after-join condition of an outer join) while it probes, so a tuple that fails the condition never reaches the list
 *  file. Each case runs one join as a hash join and as a nested loop join with the same statement apart from the hint,
 *  and the two results must match. The data of a case makes the residual condition TRUE, FALSE, or UNKNOWN by NULL
 *  operands, and leaves one key without a match.
 *
 *  Coverage:
 *    Case 1:  Comparison predicate
 *    Case 2:  Comparison predicate (type mismatch)
 *    Case 3:  Arithmetic expression
 *    Case 4:  Three-table join (one prior-join column)
 *    Case 5:  Three-table join (both prior-join columns)
 *    Case 6:  Four-table join (after_join_pred on nested build input)
 *    Case 7:  BETWEEN predicate
 *    Case 8:  IN predicate
 *    Case 9:  LIKE predicate on a string over 254 bytes, which the engine compresses
 *    Case 10:  NULL predicate
 *    Case 11:  CASE expression
 *    Case 12:  NOT operator
 *    Case 13:  OR operator (column vs constant)
 *    Case 14:  OR operator (column vs column)
 *    Case 15:  Built-in function
 *    Case 16:  User-defined function (UDF)
 *    Case 17:  EXISTS predicate
 *    Case 18:  Scalar subquery, non-correlated
 *    Case 19:  LIMIT clause
 *    Case 20:  Cached plan reuse
 *    Case 21:  During/after predicate shared column
 *    Case 22:  During/after predicate column order
 *    Case 23:  ROWNUM and INST_NUM() conditions, which the node above the hash join evaluates
 */

evaluate 'Case 1: Comparison predicate';

drop table if exists ta, tb;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
insert into ta values (1, -10), (2, 20), (3, null), (4, 40), (5, null), (6, 60);
insert into tb values (1, 10), (2, -20), (3, 30), (4, null), (5, null);

--@queryplan
select /*+ ordered use_hash */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and a.cb < b.cb
 order by a_ca, a_cb, b_cb;

--@queryplan
select /*+ ordered use_nl */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and a.cb < b.cb
 order by a_ca, a_cb, b_cb;

drop table if exists ta, tb;

evaluate 'Case 2: Comparison predicate (type mismatch)';

drop table if exists ta, tb;
create table ta (ca int, cb int);
create table tb (ca int, cb numeric(10,2));
insert into ta values (1, -10), (2, 20), (3, null), (4, 40), (5, null), (6, 60);
insert into tb values (1, 10.5), (2, -20.5), (3, 30.5), (4, null), (5, null);

--@queryplan
select /*+ ordered use_hash */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and a.cb < b.cb
 order by a_ca, a_cb, b_cb;

--@queryplan
select /*+ ordered use_nl */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and a.cb < b.cb
 order by a_ca, a_cb, b_cb;

drop table if exists ta, tb;

evaluate 'Case 3: Arithmetic expression';

drop table if exists ta, tb;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
insert into ta values (1, -10), (2, 20), (3, null), (4, 40), (5, null), (6, 60);
insert into tb values (1, 10), (2, -20), (3, 30), (4, null), (5, null);

--@queryplan
select /*+ ordered use_hash */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and a.cb + 1 < b.cb
 order by a_ca, a_cb, b_cb;

--@queryplan
select /*+ ordered use_nl */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and a.cb + 1 < b.cb
 order by a_ca, a_cb, b_cb;

drop table if exists ta, tb;

evaluate 'Case 4: Three-table join (one prior-join column)';

drop table if exists ta, tb, tc;
create table ta (ca int, cb int);
create table tb (ca int);
create table tc (ca int, cb int);
insert into ta values (1, -10), (2, 20), (3, null), (4, 40), (5, null), (6, 60);
insert into tb values (1), (2), (3), (4), (5), (6);
insert into tc values (1, 10), (2, -20), (3, 30), (4, null), (5, null);

--@queryplan
select /*+ ordered use_hash */
       a.ca as a_ca, a.cb as a_cb, c.cb as c_cb
  from ta a, tb b, tc c
 where a.ca = b.ca
   and b.ca = c.ca
   and a.cb < c.cb
 order by a_ca, a_cb, c_cb;

--@queryplan
select /*+ ordered use_nl */
       a.ca as a_ca, a.cb as a_cb, c.cb as c_cb
  from ta a, tb b, tc c
 where a.ca = b.ca
   and b.ca = c.ca
   and a.cb < c.cb
 order by a_ca, a_cb, c_cb;

drop table if exists ta, tb, tc;

evaluate 'Case 5: Three-table join (both prior-join columns)';

drop table if exists ta, tb, tc;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
create table tc (ca int, cb int);
insert into ta values (1, -10), (2, 20), (3, null), (4, 40), (5, null), (6, 60);
insert into tb values (1, 10), (2, -20), (3, 30), (4, null), (5, null), (6, 60);
insert into tc values (1, 0), (2, 10), (3, 20), (4, 30), (5, 40);

--@queryplan
select /*+ ordered use_hash */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb, c.cb as c_cb
  from ta a, tb b, tc c
 where a.ca = b.ca
   and b.ca = c.ca
   and a.cb + b.cb = c.cb
 order by a_ca, a_cb, b_cb;

--@queryplan
select /*+ ordered use_nl */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb, c.cb as c_cb
  from ta a, tb b, tc c
 where a.ca = b.ca
   and b.ca = c.ca
   and a.cb + b.cb = c.cb
 order by a_ca, a_cb, b_cb;

drop table if exists ta, tb, tc;

evaluate 'Case 6: Four-table join (after_join_pred on nested build input)';

drop table if exists ta, tb, tc, td;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
create table tc (ca int, cb int);
create table td (ca int, cb varchar(1));
insert into ta values (10, 1), (11, 2), (12, 1), (13, 2);
insert into tb values (10, 20), (11, 21), (12, 22), (13, 23);
insert into tc values (20, 2), (21, 1), (22, 1), (23, 2);
insert into td values (1, 'A'), (2, 'B');

-- the leading hint and a top-level select are needed: the bug path is not reached inside a cte
--@queryplan
select /*+ leading(a, b, da, c, db) use_hash */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb, da.cb as da_cb, db.cb as db_cb
  from ta a, tb b, tc c, td da, td db
 where a.ca = b.ca
   and b.cb = c.ca
   and a.cb = da.ca
   and c.cb = db.ca
   and ((da.cb = 'A' and db.cb = 'B') or (da.cb = 'B' and db.cb = 'A'))
 order by a_ca, a_cb, b_cb, da_cb, db_cb;

--@queryplan
select /*+ leading(a, b, da, c, db) use_nl */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb, da.cb as da_cb, db.cb as db_cb
  from ta a, tb b, tc c, td da, td db
 where a.ca = b.ca
   and b.cb = c.ca
   and a.cb = da.ca
   and c.cb = db.ca
   and ((da.cb = 'A' and db.cb = 'B') or (da.cb = 'B' and db.cb = 'A'))
 order by a_ca, a_cb, b_cb, da_cb, db_cb;

drop table if exists ta, tb, tc, td;

evaluate 'Case 7: BETWEEN predicate';

drop table if exists ta, tb;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
insert into ta values (1, 10), (2, 20), (3, null), (4, 40), (5, null), (6, 60);
insert into tb values (1, 15), (2, -20), (3, 30), (4, null), (5, null);

--@queryplan
select /*+ ordered use_hash */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and a.cb between b.cb - 5 and b.cb + 5
 order by a_ca, a_cb, b_cb;

--@queryplan
select /*+ ordered use_nl */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and a.cb between b.cb - 5 and b.cb + 5
 order by a_ca, a_cb, b_cb;

drop table if exists ta, tb;

evaluate 'Case 8: IN predicate';

drop table if exists ta, tb;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
insert into ta values (1, 10), (2, -20), (3, null), (4, 40), (5, null), (6, 60);
insert into tb values (1, 0), (2, 0), (3, 0), (4, null), (5, null);

--@queryplan
select /*+ ordered use_hash */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and a.cb in (b.cb - 10, b.cb, b.cb + 10)
 order by a_ca, a_cb, b_cb;

--@queryplan
select /*+ ordered use_nl */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and a.cb in (b.cb - 10, b.cb, b.cb + 10)
 order by a_ca, a_cb, b_cb;

drop table if exists ta, tb;

evaluate 'Case 9: LIKE predicate on a string over 254 bytes, which the engine compresses';

drop table if exists ta, tb;
create table ta (ca int, cb varchar (384));
create table tb (ca int, cb varchar (32));
insert into ta values (1, repeat('x', 128) || 'APPLE'  || repeat('x', 128)),
                      (2, repeat('x', 128) || 'BANANA' || repeat('x', 128)),
                      (3, null),
                      (4, repeat('x', 128) || 'MELON'  || repeat('x', 128)),
                      (5, null),
                      (6, repeat('x', 128) || 'PEACH'  || repeat('x', 128));
insert into tb values (1, 'APPLE'), (2, 'ORANGE'), (3, 'GRAPE'), (4, null), (5, null);

--@queryplan
select /*+ ordered use_hash */
       a.ca as a_ca, replace (a.cb, 'x', '') as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and a.cb like '%' || b.cb || '%'
 order by a_ca, a_cb, b_cb;

--@queryplan
select /*+ ordered use_nl */
       a.ca as a_ca, replace (a.cb, 'x', '') as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and a.cb like '%' || b.cb || '%'
 order by a_ca, a_cb, b_cb;

drop table if exists ta, tb;

evaluate 'Case 10: NULL predicate';

drop table if exists ta, tb;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
insert into ta values (1, -10), (2, 20), (3, null), (4, 40), (5, null), (6, 60);
insert into tb values (1, 10), (2, -20), (3, 30), (4, null), (5, null);

--@queryplan
select /*+ ordered use_hash */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and nvl (a.cb, b.cb) is null
 order by a_ca, a_cb, b_cb;

--@queryplan
select /*+ ordered use_nl */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and nvl (a.cb, b.cb) is null
 order by a_ca, a_cb, b_cb;

drop table if exists ta, tb;

evaluate 'Case 11: CASE expression';

drop table if exists ta, tb;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
insert into ta values (1, -10), (2, 20), (3, null), (4, 40), (5, null), (6, 60);
insert into tb values (1, 10), (2, -20), (3, 30), (4, null), (5, null);

--@queryplan
select /*+ ordered use_hash */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and (case when a.cb < b.cb then 1 else 0 end) = 1
 order by a_ca, a_cb, b_cb;

--@queryplan
select /*+ ordered use_nl */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and (case when a.cb < b.cb then 1 else 0 end) = 1
 order by a_ca, a_cb, b_cb;

drop table if exists ta, tb;

evaluate 'Case 12: NOT operator';

drop table if exists ta, tb;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
insert into ta values (1, -10), (2, 20), (3, null), (4, 40), (5, null), (6, 60);
insert into tb values (1, 10), (2, -20), (3, 30), (4, null), (5, null);

--@queryplan
select /*+ ordered use_hash */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and not (a.cb >= b.cb)
 order by a_ca, a_cb, b_cb;

--@queryplan
select /*+ ordered use_nl */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and not (a.cb >= b.cb)
 order by a_ca, a_cb, b_cb;

drop table if exists ta, tb;

evaluate 'Case 13: OR operator (column vs constant)';

drop table if exists ta, tb;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
insert into ta values (1, -10), (2, 20), (3, null), (4, 40), (5, null), (6, 60);
insert into tb values (1, 10), (2, -20), (3, 30), (4, null), (5, null);

--@queryplan
select /*+ ordered use_hash */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and (a.cb < 0 or b.cb >= 20)
 order by a_ca, a_cb, b_cb;

--@queryplan
select /*+ ordered use_nl */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and (a.cb < 0 or b.cb >= 20)
 order by a_ca, a_cb, b_cb;

drop table if exists ta, tb;

evaluate 'Case 14: OR operator (column vs column)';

drop table if exists ta, tb;
create table ta (ca int, cb int);
create table tb (ca int, cb int, cc int);
insert into ta values (1, -10), (2, 20), (3, null), (4, 40), (5, null), (6, 60);
insert into tb values (1, -5, 5), (2, -15, 15), (2, -100, 100), (3, -25, 25), (4, null, 35), (4, null, null), (5, null, null);

--@queryplan
select /*+ ordered use_hash */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb, b.cc as b_cc
  from ta a, tb b
 where a.ca = b.ca
   and (a.cb < b.cb or a.cb >= b.cc)
 order by a_ca, a_cb, b_cb, b_cc;

--@queryplan
select /*+ ordered use_nl */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb, b.cc as b_cc
  from ta a, tb b
 where a.ca = b.ca
   and (a.cb < b.cb or a.cb >= b.cc)
 order by a_ca, a_cb, b_cb, b_cc;

drop table if exists ta, tb;

evaluate 'Case 15: Built-in function';

drop table if exists ta, tb;
create table ta (ca int, cb varchar (10));
create table tb (ca int, cb varchar (10));
insert into ta values (1, 'apple'), (2, 'banana'), (3, null), (4, 'melon'), (5, null), (6, 'peach');
insert into tb values (1, 'APPLE'), (2, 'ORANGE'), (3, 'GRAPE'), (4, null), (5, null);

--@queryplan
select /*+ ordered use_hash */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and upper (a.cb) >= b.cb
 order by a_ca, a_cb, b_cb;

--@queryplan
select /*+ ordered use_nl */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and upper (a.cb) >= b.cb
 order by a_ca, a_cb, b_cb;

drop table if exists ta, tb;

evaluate 'Case 16: User-defined function (UDF)';

drop table if exists ta, tb;
create table ta (ca int, cb varchar (10));
create table tb (ca int, cb varchar (10));
insert into ta values (1, 'apple '), (2, 'banana '), (3, null), (4, 'melon '), (5, null), (6, 'peach');
insert into tb values (1, 'apple'), (2, 'orange'), (3, 'grape'), (4, null), (5, null);

create or replace function f_rtrim (s varchar) return varchar
as begin return rtrim (s); end;

--@queryplan
select /*+ ordered use_hash */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and f_rtrim (a.cb) >= b.cb
 order by a_ca, a_cb, b_cb;

--@queryplan
select /*+ ordered use_nl */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and f_rtrim (a.cb) >= b.cb
 order by a_ca, a_cb, b_cb;

drop table if exists ta, tb;
drop function f_rtrim;

evaluate 'Case 17: EXISTS predicate';

drop table if exists ta, tb, tc;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
create table tc (ca int, cb int, cc int /* a.cb */ );
insert into ta values (1, -10), (2, 20), (3, null), (4, 40), (5, null), (6, 60), (7, 70);
insert into tb values (1, 10), (2, -20), (3, 30), (4, null), (5, null), (6, 60);
insert into tc values (1, 1, -10), (2, 2, 20), (3, 3, null), (4, 4, 40), (5, 5, null);

--@queryplan
select /*+ ordered use_hash */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and exists (select 1 from tc c where c.ca = a.ca and c.cb = b.ca and c.cc < b.cb)
 order by a_ca, a_cb, b_cb;

--@queryplan
select /*+ ordered use_nl */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and exists (select 1 from tc c where c.ca = a.ca and c.cb = b.ca and c.cc < b.cb)
 order by a_ca, a_cb, b_cb;

drop table if exists ta, tb, tc;

evaluate 'Case 18: Scalar subquery, non-correlated';

drop table if exists ta, tb, tc;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
create table tc (ca int, cb int);
insert into ta values (1, 10), (2, 20), (3, null), (4, 40), (5, null), (6, 60);
insert into tb values (1, 10), (2, 20), (3, 30), (4, null), (5, null);
insert into tc values (1, 10), (2, 20), (3, 30), (4, -40), (5, -50);

--@queryplan
select /*+ ordered use_hash */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and a.cb + b.cb < (select max (c.cb) from tc c)
 order by a_ca, a_cb, b_cb;

--@queryplan
select /*+ ordered use_nl */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and a.cb + b.cb < (select max (c.cb) from tc c)
 order by a_ca, a_cb, b_cb;

drop table if exists ta, tb, tc;

evaluate 'Case 19: LIMIT clause';

drop table if exists ta, tb;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
insert into ta values (1, -10), (2, -20), (3, null), (4, 40), (5, null), (6, 60);
insert into tb values (1, 10), (2, 20), (3, 30), (4, null), (5, null);

--@queryplan
select /*+ ordered use_hash */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and a.cb < b.cb
 order by a_ca, a_cb, b_cb
 limit 1;

--@queryplan
select /*+ ordered use_nl */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and a.cb < b.cb
 order by a_ca, a_cb, b_cb
 limit 1;

drop table if exists ta, tb;

evaluate 'Case 20: Cached plan reuse';

drop table if exists ta, tb;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
insert into ta values (1, -10), (2, 20), (3, null), (4, 40), (5, null), (6, 60);
insert into tb values (1, 10), (1, 12), (1, 14), (1, 16), (1, 18), (2, -20), (3, 30), (4, null), (5, null);

--@queryplan
prepare q_use_hash from 'select /*+ ordered use_hash */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and a.cb + nvl (?, 0) < b.cb
 order by a_ca, a_cb, b_cb';
--@queryplan
execute q_use_hash using 27;
execute q_use_hash using 25;
execute q_use_hash using 23;
execute q_use_hash using 21;
execute q_use_hash using 19;
execute q_use_hash using null;
deallocate prepare q_use_hash;

--@queryplan
prepare q_use_nl from 'select /*+ ordered use_nl */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a, tb b
 where a.ca = b.ca
   and a.cb + nvl (?, 0) < b.cb
 order by a_ca, a_cb, b_cb';
--@queryplan
execute q_use_nl using 27;
execute q_use_nl using 25;
execute q_use_nl using 23;
execute q_use_nl using 21;
execute q_use_nl using 19;
execute q_use_nl using null;
deallocate prepare q_use_nl;

drop table if exists ta, tb;

evaluate 'Case 21: During/after predicate shared column';

drop table if exists ta, tb;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
insert into ta values (1, 10), (2, -20), (3, null), (4, 40), (5, null), (6, 60);
insert into tb values (1, -5), (1, 10), (1, 15), (2, 20), (3, 30), (4, null), (5, null);

--@queryplan
select /*+ use_hash */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a left join tb b on a.ca = b.ca and a.cb <= b.cb
 where (b.ca is null or a.cb >= b.cb)
 order by a_ca, a_cb, b_cb;

--@queryplan
select /*+ use_nl */
       a.ca as a_ca, a.cb as a_cb, b.cb as b_cb
  from ta a left join tb b on a.ca = b.ca and a.cb <= b.cb
 where (b.ca is null or a.cb >= b.cb)
 order by a_ca, a_cb, b_cb;

drop table if exists ta, tb;

evaluate 'Case 22: During/after predicate column order';

drop table if exists ta, tb;
create table ta (ca int, cb int, cc int);
create table tb (ca int, cb int, cc int);
insert into ta values (1, -10, 999), (1, -10, 1000), (2, 20, 1999), (3, null, null), (4, 40, 3999), (5, null, null), (6, 60, 5999);
insert into tb values (1, 10, 100), (2, -20, 200), (3, 30, 300), (4, null, null), (5, null, null);

--@queryplan
select /*+ ordered use_hash */
       a.ca as a_ca, a.cb as a_cb, a.cc as a_cc, b.cb as b_cb, b.cc as b_cc
  from ta a left join tb b on a.ca = b.ca and a.cc < b.cc * 10
 where (b.ca is null or a.cb < b.cb)
 order by a_ca, a_cb, a_cc, b_cb, b_cc;

--@queryplan
select /*+ ordered use_nl */
       a.ca as a_ca, a.cb as a_cb, a.cc as a_cc, b.cb as b_cb, b.cc as b_cc
  from ta a left join tb b on a.ca = b.ca and a.cc < b.cc * 10
 where (b.ca is null or a.cb < b.cb)
 order by a_ca, a_cb, a_cc, b_cb, b_cc;

drop table if exists ta, tb;

evaluate 'Case 23: ROWNUM and INST_NUM() conditions, which the node above the hash join evaluates; result = 2 and 3';

-- ca 1 to 4 fail a.cb < b.cb and ca 5 to 8 pass it
drop table if exists ta, tb;
create table ta (ca int, cb int);
create table tb (ca int, cb int);
insert into ta values (1, 10), (2, 20), (3, 30), (4, 40), (5, 50), (6, 60), (7, 70), (8, 80);
insert into tb values (1, 5), (2, 15), (3, 25), (4, 35), (5, 55), (6, 65), (7, 75), (8, 85);

--@queryplan
select /*+ ordered use_hash */
       count(*) as cnt
  from ta a, tb b
 where a.ca = b.ca
   and a.cb < b.cb
   and rownum <= 2;

--@queryplan
select /*+ ordered use_nl */
       count(*) as cnt
  from ta a, tb b
 where a.ca = b.ca
   and a.cb < b.cb
   and rownum <= 2;

--@queryplan
select /*+ ordered use_hash */
       count(*) as cnt
  from ta a, tb b
 where a.ca = b.ca
   and a.cb < b.cb
   and inst_num() <= 3;

--@queryplan
select /*+ ordered use_nl */
       count(*) as cnt
  from ta a, tb b
 where a.ca = b.ca
   and a.cb < b.cb
   and inst_num() <= 3;

drop table if exists ta, tb;

