/**
 *  This test case verifies CBRD-27946: Deprecate KEYLIMIT hint (USING INDEX ... KEYLIMIT [m,] n)
 *
 *  The KEYLIMIT index hint is removed from the grammar, so a statement that uses it fails with a
 *  syntax error and does nothing. KEYLIMIT is no longer a keyword, so it can still name a table,
 *  a column and an index. USING INDEX without KEYLIMIT keeps working, and LIMIT gives the rows
 *  that KEYLIMIT was used for.
 *
 *  Coverage:
 *    Case 1:  SELECT with KEYLIMIT n and with KEYLIMIT m, n is a syntax error
 *    Case 2:  UPDATE and DELETE with KEYLIMIT are syntax errors and change no row
 *    Case 3:  keylimit names a table, a column and an index
 *    Case 4:  the same SELECT without KEYLIMIT runs, with LIMIT n and LIMIT m, n
 */

drop table if exists t27946;
create table t27946 (a int primary key, b int);
insert into t27946 values (1, 1), (2, 2), (3, 3), (4, 4), (5, 5);
create index i_t27946_b on t27946 (b);


evaluate 'Case 1: SELECT with KEYLIMIT n and with KEYLIMIT m, n is a syntax error; result = Error:-493 twice';
select a from t27946 where b > 0 using index i_t27946_b keylimit 2;
select a from t27946 where b > 0 using index i_t27946_b keylimit 1, 2;


evaluate 'Case 2: UPDATE and DELETE with KEYLIMIT are syntax errors and change no row; result = Error:-493 twice, then rows 1 to 5 unchanged';
update t27946 set b = b + 10 where b > 0 using index i_t27946_b keylimit 2;
delete from t27946 where b > 0 using index i_t27946_b keylimit 2;
select a, b from t27946 order by a;


evaluate 'Case 3: keylimit names a table, a column and an index; result = 7';
drop table if exists keylimit;
create table keylimit (keylimit int);
create index keylimit on keylimit (keylimit);
insert into keylimit values (7);
select keylimit from keylimit where keylimit > 0 using index keylimit;
drop table keylimit;


evaluate 'Case 4: the same SELECT without KEYLIMIT runs, with LIMIT n and LIMIT m, n; result = 1 2, then 2 3';
select a from t27946 where b > 0 using index i_t27946_b order by b limit 2;
select a from t27946 where b > 0 using index i_t27946_b order by b limit 1, 2;

drop table t27946;
