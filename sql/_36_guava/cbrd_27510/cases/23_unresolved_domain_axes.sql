/**
 *  This test case verifies CBRD-27510: the unresolved-domain check at load accepts two shapes develop ran - a string
 *  function over a CAST of a bind, and a CONNECT BY block over a derived table with a bind.
 *
 *  The load refuses a plan that leaves a node's domain unresolved (ER_QPROC_DOMAIN_UNRESOLVED, -1383), on two axes:
 *  the type must be fixed, and a string whose collation the values give must be a collation late-binding node. Two
 *  shapes failed the check although every domain is known before the rows:
 *    - MIN / MAX, and the analytic MIN / MAX, LAG / LEAD, FIRST_VALUE / NTH_VALUE, over CAST (? AS VARCHAR (n)) or
 *      CHAR (n), STRING, NCHAR VARYING (n): the compiler types the function with ENFORCE over an argument it could
 *      not type, and the argument's fixed domain carries the collation - the function takes the rule's domain at
 *      load (the collation axis).
 *    - a CONNECT BY block joined with a derived table whose column holds a bind (AVG (w) * ?): the block's position
 *      lists read its input list, the parent tuple and its own list without a list scan, so their readers of the
 *      derived column stayed variable (the type axis); once they resolve, they take the column's resolved domain
 *      before the block reads a tuple, or the slot read gives NULL.
 *    - PRIOR ? and PRIOR t.thr over such a column: the node's type is MAYBE and a user host variable carries no
 *      expected domain, so XASL generation stopped without a message; the node is a late-binding node now, and a
 *      row's value (PRIOR reads another tuple), never a constant expression. CONNECT_BY_ROOT t.thr read the root
 *      tuple's column in the compiled variable domain and answered NULL; it reads it in the execution's domain.
 *  Every answer is the develop answer. The control statements (COUNT, SUM, GROUP_CONCAT, a numeric or date CAST, a
 *  literal CAST, a bare bind, the join without CONNECT BY, a derived column with a fixed domain, a scalar subquery)
 *  ran before as well.
 *
 *  Coverage:
 *    Case 1: MIN / MAX over CAST (? AS VARCHAR (10)), CHAR (5), STRING, NCHAR VARYING (5), with a string and an
 *            integer bind; the controls
 *    Case 2: the analytic MIN / MAX, LAG / LEAD, FIRST_VALUE / NTH_VALUE over the same CAST
 *    Case 3: CONNECT BY with a derived table over AVG (w) * ?, in the CONNECT BY condition and in the select list
 *            alone, an INT, string, DOUBLE and NULL bind; the four shapes that ran before
 *    Case 4: the derived column's value in the CONNECT BY output (it came out NULL once the block loaded), and
 *            PRIOR / CONNECT_BY_ROOT over a bind and over such a column (they failed at execution with an internal
 *            semantic error)
 */
--+ holdcas on;
-- Case 1. The aggregate over a CAST of a bind.
evaluate 'Case 1: MIN / MAX over a CAST of a bind to a string type';
drop table if exists ud_t;
create table ud_t (id int primary key, s varchar(10));
insert into ud_t values (1, 'b'), (2, 'a'), (3, 'c');
prepare q from 'select max(cast(? as varchar(10))), min(cast(? as varchar(10))) from ud_t';
execute q using '7', '7';
execute q using 7, 7;
prepare q from 'select max(cast(? as char(5))), max(cast(? as string)), max(cast(? as nchar varying(5))) from ud_t';
execute q using '7', '7', '7';
prepare q from 'select max(cast(? as varchar(10))), s from ud_t group by s order by s';
execute q using 'z';
prepare q from 'select count(cast(? as varchar(10))), group_concat(cast(? as varchar(10))), sum(cast(? as varchar(10))) from ud_t';
execute q using '7', '7', '7';
prepare q from 'select max(cast(? as int)), max(cast(? as date)), max(cast(''x'' as varchar(10))), max(?) from ud_t';
execute q using 7, '2024-01-01', '7';

-- Case 2. The analytic functions over the same CAST.
evaluate 'Case 2: analytic MIN / MAX, LAG / LEAD, FIRST_VALUE / NTH_VALUE over the CAST';
prepare q from 'select id, max(cast(? as varchar(10))) over (), min(cast(? as char(5))) over (partition by id) from ud_t order by id';
execute q using '7', '7';
prepare q from 'select id, lag(cast(? as varchar(10)), 1) over (order by id), lead(cast(? as varchar(10)), 1) over (order by id) from ud_t order by id';
execute q using 'p', 'n';
prepare q from 'select id, first_value(cast(? as varchar(10))) over (order by id), nth_value(cast(? as varchar(10)), 2) over (order by id) from ud_t order by id';
execute q using 'f', 'n';

-- Case 3. CONNECT BY joined with a derived table that holds a bind.
evaluate 'Case 3: CONNECT BY with a derived table over a bind';
drop table if exists ud_h;
create table ud_h (id int primary key, pid int, w numeric(5,2));
insert into ud_h values (1, null, 1.5), (2, 1, 2.25), (3, 1, 3);
prepare q from 'select h.id, level from ud_h h, (select avg(w) * ? thr from ud_h) t start with h.id = 1 connect by prior h.id = h.pid and h.w > t.thr order by h.id';
execute q using 0;
execute q using '0';
execute q using 0.5;
execute q using null;
prepare q from 'select h.id, level, t.thr from ud_h h, (select avg(w) * ? thr from ud_h) t start with h.id = 1 connect by prior h.id = h.pid order by h.id';
execute q using 1;
prepare q from 'select h.id, level from ud_h h, (select w * ? thr from ud_h where id = 1) t start with h.id = 1 connect by prior h.id = h.pid and h.w > t.thr order by h.id';
execute q using 1;
prepare q from 'select h.id, level from ud_h h join (select max(w) over () * ? thr from ud_h limit 1) t on h.w > t.thr start with h.id = 1 connect by prior h.id = h.pid order by h.id';
execute q using 0;
prepare q from 'select h.id from ud_h h, (select avg(w) * ? thr from ud_h) t where h.w > t.thr order by h.id';
execute q using 0;
prepare q from 'select h.id, level from ud_h h, (select avg(nvl(w, ?)) thr from ud_h) t start with h.id = 1 connect by prior h.id = h.pid and h.w > t.thr order by h.id';
execute q using 0;
prepare q from 'select h.id, level from ud_h h, (select avg(w) thr from ud_h) t start with h.id = ? connect by prior h.id = h.pid and h.w > t.thr order by h.id';
execute q using 1;
prepare q from 'select h.id, level, (select avg(w) * ? from ud_h) thr from ud_h h start with h.id = 1 connect by prior h.id = h.pid order by h.id';
execute q using 0;

-- Case 4. The derived column's value in the output, and PRIOR / CONNECT_BY_ROOT over a bind.
evaluate 'Case 4: the derived column in the CONNECT BY output; PRIOR and CONNECT_BY_ROOT over a bind';
prepare q from 'select h.id, t.thr, typeof(t.thr), t.thr + 0, count(t.thr) over () from ud_h h, (select avg(w) * ? thr from ud_h) t start with h.id = 1 connect by prior h.id = h.pid order by h.id';
execute q using 1;
execute q using '1';
prepare q from 'select h.id, t.thr from ud_h h, (select ? thr from ud_h limit 1) t start with h.id = 1 connect by prior h.id = h.pid order by h.id';
execute q using 5;
prepare q from 'select h.id, t.thr, t.k from ud_h h, (select nvl(?, 1) thr, max(w) k from ud_h) t start with h.id = 1 connect by prior h.id = h.pid and t.thr > 0 order by t.thr, h.id';
execute q using 2;
prepare q from 'select h.id, prior t.thr, connect_by_root t.thr from ud_h h, (select avg(w) * ? thr from ud_h) t start with h.id = 1 connect by prior h.id = h.pid order by h.id';
execute q using 1;
prepare q from 'select h.id, prior ?, connect_by_root ?, prior h.w + ? from ud_h h start with h.id = 1 connect by prior h.id = h.pid order by h.id';
execute q using 1, 'r', 1;
prepare q from 'select h.id, prior t.thr from ud_h h, (select ? thr from ud_h limit 1) t start with h.id = 1 connect by prior h.id = h.pid order by h.id';
execute q using 1;
deallocate prepare q;
drop table ud_t;
drop table ud_h;
--+ holdcas off;
