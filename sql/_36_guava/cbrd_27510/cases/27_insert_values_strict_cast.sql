/**
 *  This test case verifies CBRD-27510: a value INSERT ... VALUES computes from a bind is cast into its column without
 *  truncation on every execution. The compiler wraps a string expression longer than its column in a CAST to the
 *  column's type; the row path marks the inserted values as strict casts just before it fetches them, and the
 *  constant expression step of CBRD-27510 fetches a constant value before that. The load marks them now. Before the
 *  fix the first execution of a prepared INSERT stored the truncated value and the second raised the overflow
 *  (-427, ER_IT_DATA_OVERFLOW) develop raised on every execution.
 *
 *  Coverage:
 *    Case 1: the shapes the review of PR 8022 reported, each prepared statement executed twice: UPPER, ||, CONCAT,
 *            TRIM into VARCHAR(3), CONCAT into CHAR(2), a CAST into BIT VARYING(8), a multi-row VALUES
 *    Case 2: the values that fit, UPDATE SET and INSERT ... SELECT of the same shape, the literal (a compile error)
 */
--+ holdcas on;
drop table if exists sc_t, sc_s;
create table sc_t (id int primary key, c varchar(3), ch char(2), bv bit varying(8));
create table sc_s (id int, c varchar(10));
insert into sc_s values (1, 'abcdef');

-- Case 1. A computed value longer than its column, twice.
evaluate 'Case 1: a computed value longer than its column';
prepare q from 'insert into sc_t (id, c) values (?, upper(?))';
execute q using 1, 'abcdef';
execute q using 2, 'abcdef';
prepare q from 'insert into sc_t (id, c) values (?, ? || ''zz'')';
execute q using 3, 'ab';
execute q using 4, 'ab';
prepare q from 'insert into sc_t (id, c) values (?, concat(?, ''xyz''))';
execute q using 5, 'ab';
execute q using 6, 'ab';
prepare q from 'insert into sc_t (id, c) values (?, trim(?))';
execute q using 7, '  abcd  ';
execute q using 8, '  abcd  ';
prepare q from 'insert into sc_t (id, ch) values (?, concat(?, ''q''))';
execute q using 9, 'ab';
execute q using 10, 'ab';
prepare q from 'insert into sc_t (id, bv) values (?, cast(? as bit varying(16)))';
execute q using 11, B'0101010101';
execute q using 12, B'0101010101';
prepare q from 'insert into sc_t (id, c) values (?, concat(?, ''xyz'')), (?, ''ok'')';
execute q using 13, 'ab', 14;
execute q using 15, 'ab', 16;
select * from sc_t order by id;

-- Case 2. The values that fit, and the same shape elsewhere.
evaluate 'Case 2: the values that fit, UPDATE and INSERT ... SELECT';
prepare q from 'insert into sc_t (id, c) values (?, upper(?))';
execute q using 21, 'ab';
execute q using 22, 'abc';
prepare q from 'insert into sc_t (id, ch) values (?, concat(?, ''q''))';
execute q using 23, 'a';
prepare q from 'update sc_t set c = upper(?) where id = 21';
execute q using 'abcdef';
execute q using 'xy';
prepare q from 'insert into sc_t (id, c) select 31, upper(c) from sc_s where id = ?';
execute q using 1;
insert into sc_t (id, c) values (41, concat('ab', 'xyz'));
select * from sc_t order by id;
deallocate prepare q;
drop table sc_t, sc_s;
--+ holdcas off;
