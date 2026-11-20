/**
 *  This test case verifies CBRD-28154: A collection value sent to a Java stored procedure must keep
 *  its NUMERIC and long string elements.
 *
 *  Before the server sends a value to the PL server, it computes the packed size and then packs
 *  the value into a buffer of that size. For a collection, the size of each NUMERIC or string
 *  element was taken from the collection itself instead of the element. A NUMERIC element made a
 *  debug server fail an assertion, and a long string element was sized too small so the buffer ran
 *  out of room. Integer and short string elements were not affected.
 *
 *  The same happens on two paths: a collection passed as an argument (SpTest6.testset1 returns
 *  its argument), and a collection column read through the server-side JDBC connection
 *  (jdbc_cubrid415.main1). main1 prints a collection as a Java object with a hash code, so the
 *  read path is checked with LIKE.
 *
 *  Coverage:
 *    Case 1:  control - sequence argument, integer elements
 *    Case 2:  sequence argument, NUMERIC elements
 *    Case 3:  sequence argument, 60-byte string element
 *    Case 4:  sequence argument, 300-byte string element (the long string form of the packer)
 *    Case 5:  set argument, NUMERIC elements
 *    Case 6:  multiset argument, 60-byte string element
 *    Case 7:  sequence argument, integer, NUMERIC and string elements, compared with the argument
 *    Case 8:  collection columns as arguments
 *    Case 9:  server-side JDBC reads a SET OF NUMERIC column and a SEQUENCE OF VARCHAR column
 */

drop table if exists t_28154;
create table t_28154 (id int primary key, sn sequence of numeric(10,2), ss sequence of varchar(400), st set of numeric(10,2));
insert into t_28154 values (1, {1.50, 2.25}, {'a', 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb', repeat('c', 300)}, {3.75, 1.50});

create or replace function f_28154_seq (x sequence) return sequence as language java name 'SpTest6.testset1(java.lang.Object[]) return java.lang.Object[]';
create or replace function f_28154_set (x set) return set as language java name 'SpTest6.testset1(java.lang.Object[]) return java.lang.Object[]';
create or replace function f_28154_mset (x multiset) return multiset as language java name 'SpTest6.testset1(java.lang.Object[]) return java.lang.Object[]';
create or replace function f_28154_q (q string) return string as language java name 'jdbc_cubrid415.main1(java.lang.String) return java.lang.String';

evaluate 'Case 1: sequence argument, integer elements';
select f_28154_seq ({1, 2});
evaluate 'Case 2: sequence argument, numeric elements';
select f_28154_seq ({1.5, 2.25});
evaluate 'Case 3: sequence argument, 60-byte string element';
select f_28154_seq ({'a', 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'});
evaluate 'Case 4: sequence argument, 300-byte string element';
select f_28154_seq ({'a', repeat ('c', 300)});
evaluate 'Case 5: set argument, numeric elements';
select f_28154_set ({1.5, 2.25});
evaluate 'Case 6: multiset argument, 60-byte string element';
select f_28154_mset ({'a', 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'});
evaluate 'Case 7: sequence argument, mixed elements come back equal';
-- JDBC returns a collection whose elements have different types as NULL, with or without a stored procedure, so Case 7 compares the result with the argument instead of printing it
select f_28154_seq ({1, 1.5, 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'}) = {1, 1.5, 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'};
evaluate 'Case 8: collection columns as arguments';
select f_28154_seq (sn), f_28154_seq (ss) from t_28154 order by id;
evaluate 'Case 9: server-side JDBC reads collection columns';
select f_28154_q ('select st from t_28154 order by id') like 'st|[Ljava.lang.Object;@%|';
select f_28154_q ('select ss from t_28154 order by id') like 'ss|[Ljava.lang.Object;@%|';

drop function f_28154_seq, f_28154_set, f_28154_mset, f_28154_q;
drop table t_28154;
