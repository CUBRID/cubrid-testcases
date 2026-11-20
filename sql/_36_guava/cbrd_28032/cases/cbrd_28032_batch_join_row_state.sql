/*
 * CBRD-28032: a batched nested loop join holds outer rows and reads the inner index for them ahead.
 * A statement that evaluates a value changing from row to row (a session variable, a serial)
 * joins a row at a time: the inner key of a row is computed after the rows ahead of it were output.
 *
 *    Case 1: the inner key reads a session variable the select list assigns
 *    Case 2: the inner key reads a serial the select list advances
 *    Case 3: the same join with no such value: batched (nlbatch in the trace), same rows as Case 1
 */

drop table if exists bj_o, bj_i;
drop serial if exists bj_s;

create table bj_o (id int, a int);
insert into bj_o select rownum, mod(rownum * 7, 40) + 1 from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b, table({0,1,2}) c;
create table bj_i (k int, v int);
insert into bj_i select rownum, mod(rownum * 37, 1009) from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b, table({0,1,2,3,4,5,6,7,8,9}) c, table({0,1,2}) d;
create index i_bj_i on bj_i (k);
update statistics on bj_o, bj_i with fullscan;
create serial bj_s;

set trace on;

evaluate 'Case 1: the inner key reads a session variable the select list assigns; row n joins k = a + n';
set @v = 0;
select /*+ recompile ordered use_nl no_parallel_scan */ count(*), sum(x.k), sum(x.v), max(@v := @v + 1) from bj_o o, bj_i x where x.k = mod(o.a + @v, 3000) + 1;
show trace;

evaluate 'Case 2: the inner key reads a serial the select list advances';
select /*+ recompile ordered use_nl no_parallel_scan */ count(*), sum(x.k), sum(x.v), max(bj_s.next_value) from bj_o o, bj_i x where x.k = mod(o.a + bj_s.current_value, 3000) + 1;

evaluate 'Case 3: no value that changes from row to row, batched; the rows of Case 1';
select /*+ recompile ordered use_nl no_parallel_scan */ count(*), sum(x.k), sum(x.v) from bj_o o, bj_i x where x.k = o.a + o.id;
show trace;
set trace off;

drop serial bj_s;
drop table bj_o, bj_i;
