/**
 *  This test case verifies CBRD-27583: a prepared statement whose host variable is a key of a
 *  single-column index fails with -181, Cannot coerce value of domain, when the value bound is
 *  of a type no index holds (a collection), whatever keys the index holds.
 *
 *  Develop raises the error on every such execution.  The PR head before its fix raised it only
 *  where the B-tree compared a key with the value, and answered no row without an error where
 *  the range meets no key: an empty table, or a lower bound above every key.  The answers are
 *  develop's (no specification change).
 *
 *  Judged by the error code of every EXECUTE.  Every statement scans its index (USING INDEX),
 *  so the key range is built from the value.  The cases that compare a key with the value are
 *  the controls: they fail with -181 on both.
 *
 *  Coverage:
 *    Case 1:  an empty table, a range and an equality bound to a collection
 *    Case 2:  one row, a range whose lower bound is above the only key
 *    Case 3:  one row, a range and an equality that compare the key with the collection
 */

drop table if exists t_empty, t_one;

create table t_empty (c int);
create index i_empty on t_empty (c);
create table t_one (c int);
insert into t_one values (1);
create index i_one on t_one (c);


evaluate 'Case 1: an empty table, a range and an equality bound to a collection';
prepare s_empty_range from 'select * from t_empty where c > ? and c < ? using index i_empty';
execute s_empty_range using 0, {9};
prepare s_empty_eq from 'select * from t_empty where c = ? using index i_empty';
execute s_empty_eq using {1};


evaluate 'Case 2: one row, a range whose lower bound is above the only key';
prepare s_one_range from 'select * from t_one where c > ? and c < ? using index i_one';
execute s_one_range using 5, {9};


evaluate 'Case 3: one row, a range and an equality that compare the key with the collection';
execute s_one_range using 0, {9};
prepare s_one_eq from 'select * from t_one where c = ? using index i_one';
execute s_one_eq using {1};

deallocate prepare s_empty_range;
deallocate prepare s_empty_eq;
deallocate prepare s_one_range;
deallocate prepare s_one_eq;
drop table t_empty, t_one;
