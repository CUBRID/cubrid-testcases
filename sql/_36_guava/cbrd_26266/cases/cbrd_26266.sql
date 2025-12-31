/**
 *  This test case verifies CBRD-26266: Support for order by skip optimization when using function-based indexes in multi-column indexes.
 *  Fixes the issue where order by skip was not applied when the first index column had an equality condition 
 *  and the second column was a function index in the ORDER BY clause.
 */

evaluate 'Test 1 Setup';

drop table if exists tbl_orderby_num;

create table tbl_orderby_num (
    col_a int,
    col_b int
);

create index idx_col_a_upper_col_b on tbl_orderby_num(col_a desc, upper(col_b) desc);

insert into tbl_orderby_num values
(1,100),
(50,200),
(30,300),
(100,0),
(1,200),
(1,300),
(1,0);

evaluate '[TEST 1] Multi-column index with range condition and function-based ORDER BY -> verify ORDER BY skip using index order';
select col_a, col_b
from tbl_orderby_num
where col_a > 1 and upper(col_b) > '0'
order by col_a desc, upper(col_b) desc
for orderby_num() between 1 and 10;

evaluate '[TEST 1.1] Function expression mismatch in ORDER BY -> should NOT skip order by';
select /*+ recompile */ col_a, col_b
from tbl_orderby_num
where col_a = 1 and upper(col_b) > '0'
order by upper(cast(col_b as varchar) || '_') desc;


evaluate 'Test 2 Setup';

drop table if exists tbl_join_a;
drop table if exists tbl_join_b;
drop table if exists tbl_join_c;

create table tbl_join_a (col_a int);
create table tbl_join_b (col_a int);
create table tbl_join_c (col_a int, col_x int);

create index idx_join_a_col_a        on tbl_join_a(col_a);
create index idx_join_b_col_a        on tbl_join_b(col_a);
create index idx_join_c_col_a_col_x  on tbl_join_c(col_a, col_x);
create index idx_join_a_upper_col_a  on tbl_join_a(upper(col_a));

insert into tbl_join_a values (5),(3),(1),(4),(3),(5),(2),(5);
insert into tbl_join_b values (5),(3),(1),(4),(3),(5),(2),(5);
insert into tbl_join_c values (5,1),(3,9),(1,9),(4,9),(3,9),(5,2),(2,9),(5,3);


evaluate '[TEST 2.1] JOIN query with equality join and function-based ORDER BY (ASC) -> verify ORDER BY skip across join';
select /*+ recompile */ *
from tbl_join_a a, tbl_join_b b
where upper(a.col_a) > '0' and upper(a.col_a) = b.col_a
order by upper(a.col_a)
limit 3;


evaluate '[TEST 2.2] JOIN query with equality join and function-based ORDER BY (DESC) -> verify ORDER BY skip with descending order';
select /*+ recompile */ *
from tbl_join_a a, tbl_join_b b, tbl_join_c c
where upper(a.col_a) > '0' and upper(a.col_a) = b.col_a and b.col_a = c.col_a
order by upper(a.col_a) desc
limit 3;

evaluate '[TEST 2.3] JOIN + multi-key ORDER BY(function + base) + LIMIT -> correctness regression check';
select /*+ recompile */ a.col_a as a_a, b.col_a as b_a
from tbl_join_a a, tbl_join_b b
where upper(a.col_a) = b.col_a
order by upper(a.col_a) asc, b.col_a asc
limit 5;


evaluate 'Test 3 Setup';

drop table if exists tbl_keylimit;

create table tbl_keylimit (
    col_a int,
    col_b int,
    col_s varchar(100)
);

insert into tbl_keylimit values
(2,8,'two'),
(1,9,'one'),
(3,7,'three'),
(4,6,'four'),
(5,5,'five'),
(6,4,'six'),
(7,3,'seven'),
(8,2,'eight'),
(9,1,'nine');

create index idx_keylimit_upper_col_a on tbl_keylimit(upper(col_a));

evaluate '[TEST 3.1] KEYLIMIT -> skip order by';
select /*+ recompile */
    *
from tbl_keylimit
where upper(col_a) > '0'
using index idx_keylimit_upper_col_a
keylimit 2,4
order by upper(col_a);

evaluate '[TEST 3.2] KEYLIMIT -> skip order by (desc)';
select /*+ recompile */
    *
from tbl_keylimit
where upper(col_a) > '0'
using index idx_keylimit_upper_col_a
keylimit 4,2
order by upper(col_a);

evaluate 'Test 4 Setup';

drop table if exists tbl_brd_notice;

create table tbl_brd_notice
(
    brd_id     varchar(60),
    seq        integer,
    notice_yn  varchar(3) default 'N',
    titl       varchar(900)
);

insert into tbl_brd_notice (brd_id, seq, notice_yn, titl) values ('3000', 1, 'N',  'abc');
insert into tbl_brd_notice (brd_id, seq, notice_yn, titl) values ('3001', 2, NULL, 'def');
insert into tbl_brd_notice (brd_id, seq, notice_yn, titl) values ('3002', 3, NULL, 'ghi');
insert into tbl_brd_notice (brd_id, seq, notice_yn, titl) values ('3003', 4, NULL, 'jkl');
insert into tbl_brd_notice (brd_id, seq, notice_yn, titl) values ('3004', 5, 'Y',  'mno');

create index idx_brd_id_nvl_notice_yn on tbl_brd_notice(brd_id, nvl(notice_yn,'N') desc);

evaluate '[TEST 4] Equality on leading index column and function-based ORDER BY on second column -> verify ORDER BY skip after skipping equality key';
select /*+ recompile */ seq, titl
from tbl_brd_notice
where brd_id = '3003'
order by nvl(notice_yn,'N') desc;

create index idx_brd_notice_complex on tbl_brd_notice(seq, nvl(notice_yn,'N'), notice_yn, brd_id, titl);

evaluate '[TEST 4.1] Range on leading key + equality on function-based key, ORDER BY subsequent key -> check ORDER BY skip behavior';
select /*+ recompile */ seq, titl
from tbl_brd_notice
where seq > 0 and nvl(notice_yn,'N') = 'N'
order by notice_yn;

evaluate '[TEST 4.2] Range on leading key, ORDER BY function-based key -> check ORDER BY skip behavior';
select /*+ recompile */ seq, titl
from tbl_brd_notice
where seq > 0
order by nvl(notice_yn,'N');

evaluate '[TEST 4.3] Extra ORDER BY column not aligned with index order -> should NOT skip order by';
select /*+ recompile */ seq, titl
from tbl_brd_notice
where seq > 0 and nvl(notice_yn,'N') = 'N'
order by brd_id;

evaluate '[TEST 4.4] Extra ORDER BY column with gaps -> should NOT skip order by';
select /*+ recompile */ seq, titl
from tbl_brd_notice
where seq > 0 and nvl(notice_yn,'N') = 'N' and notice_yn = 'N'
order by titl;

evaluate '[TEST 4.5] IS NULL predicate + function ORDER BY -> stability regression check';
select /*+ recompile */ brd_id, seq, notice_yn, titl
from tbl_brd_notice
where brd_id = '3001'
and notice_yn is null
order by nvl(notice_yn,'N') desc;

evaluate 'Test 5 Setup';

drop table if exists tbl_multi_eq;

create table tbl_multi_eq (
    col_a varchar(10),
    col_b varchar(10),
    col_c varchar(100),
    col_val int
);

insert into tbl_multi_eq values ('A', 'X', 'apple', 1);
insert into tbl_multi_eq values ('A', 'X', 'Banana', 2);
insert into tbl_multi_eq values ('A', 'X', 'cherry', 3);
insert into tbl_multi_eq values ('A', 'Y', 'date', 4);
insert into tbl_multi_eq values ('B', 'X', 'elderberry', 5);

create index idx_multi_eq_lower on tbl_multi_eq(col_a, col_b, lower(col_c) desc);

evaluate '[TEST 5] Multiple leading equality conditions followed by function-based ORDER BY column -> verify skipping multiple equality keys';
select /*+ recompile */ col_c, col_val
from tbl_multi_eq
where col_a = 'A' and col_b = 'X'
order by lower(col_c) desc;

evaluate '[TEST 5.1] Extra ORDER BY column not in index -> should NOT skip order by';
select /*+ recompile */ col_c, col_val
from tbl_multi_eq
where col_a = 'A' and col_b = 'X'
order by lower(col_c) desc, col_val;


evaluate 'Test 6 Setup';

drop table if exists tbl_func_eq;

create table tbl_func_eq (
    col_a varchar(20),
    col_b int
);

insert into tbl_func_eq values ('hello', 1);
insert into tbl_func_eq values ('Hello', 2);
insert into tbl_func_eq values ('HELLO', 3);
insert into tbl_func_eq values ('world', 4);
insert into tbl_func_eq values ('World', 5);

create index idx_func_eq_upper on tbl_func_eq(upper(col_a), col_b desc);

evaluate '[TEST 6] Equality condition on function-based leading index column and ORDER BY on subsequent column -> verify ORDER BY skip';
select /*+ recompile */ col_a, col_b
from tbl_func_eq
where upper(col_a) = 'HELLO'
order by col_b desc;

evaluate '[TEST 6.1] DISTINCT + ORDER BY(function) -> correctness regression check';
select /*+ recompile */ distinct upper(col_a) as u
from tbl_func_eq
where upper(col_a) > '0'
order by u;

evaluate '[TEST 6.2] GROUP BY + ORDER BY(function) -> should NOT incorrectly skip (correctness check)';
select /*+ recompile */ upper(col_a) as u, count(*) as cnt
from tbl_func_eq
group by upper(col_a)
order by u;


evaluate 'Test 7 Setup';

drop table if exists tbl_trim_order;

create table tbl_trim_order (
    category int,
    item_name varchar(50)
);

insert into tbl_trim_order values (1, '  zebra');
insert into tbl_trim_order values (1, 'apple  ');
insert into tbl_trim_order values (1, ' mango ');
insert into tbl_trim_order values (1, 'banana');
insert into tbl_trim_order values (2, '  kiwi');

create index idx_trim_order on tbl_trim_order(category, trim(item_name));

evaluate '[TEST 7] Equality on leading column with TRIM-based function ORDER BY -> verify ORDER BY skip with string function index';
select /*+ recompile */ item_name
from tbl_trim_order
where category = 1
order by trim(item_name);

evaluate '[TEST 7.1] ORDER BY using alias of function expression -> should skip order by';
select /*+ recompile */ item_name, trim(item_name) as t
from tbl_trim_order
where category = 1
order by t;

evaluate '[TEST 7.2] LIMIT + OFFSET with function ORDER BY -> should skip order by (or at least correct ordering)';
select /*+ recompile */ item_name
from tbl_trim_order
where category = 1
order by trim(item_name)
limit 2 offset 1;

evaluate '[TEST 7.3] Derived table + ORDER BY on function alias -> stability/correctness check';
select /*+ recompile */ item_name
from (
    select category, item_name, trim(item_name) as t
    from tbl_trim_order
    where category = 1
) dt
order by dt.t;


evaluate 'Clean up';
drop table tbl_join_a;
drop table tbl_join_b;
drop table tbl_join_c;
drop table tbl_keylimit;
drop table tbl_orderby_num;
drop table tbl_brd_notice;
drop table tbl_multi_eq;
drop table tbl_func_eq;
drop table tbl_trim_order;