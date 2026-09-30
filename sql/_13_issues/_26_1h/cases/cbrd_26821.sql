/**
 * This test case verifies CBRD-26821: authorization checks must be back on after a DML statement
 * (stale Au_disable left by do_select_internal overwriting parser->au_save)
 *
 * After each DML statement, the same session reads a table that u_26821 has no
 * privilege on. The read must fail with an authorization error.
 * If Au_disable leaks (stays true), the read succeeds and 777 is shown.
 *
 * Coverage:
 * Case 1, 2, 9 - reproduce CBRD-26821
 * Case 3 - 8   - regression guards for CBRD-26823
 *
 * 1 - UPDATE OBJECT with a subquery in SET
 * 2 - UPDATE CLASS attribute with a subquery and an object host variable in SET
 * 3 - UPDATE with a subquery in SET
 * 4 - DELETE with a subquery in WHERE
 * 5 - MERGE with subqueries in both UPDATE and INSERT branches
 * 6 - INSERT VALUES with a subquery
 * 7 - INSERT ON DUPLICATE KEY UPDATE with a subquery
 * 8 - DO with a subquery
 * 9 - UPDATE OBJECT by dba, then login as u_26821
 */

drop table if exists t_secret;

create user u_26821;
create table t_secret (s int);
insert into t_secret values (777);

call login ('u_26821', '') on class db_user;

create table t1 (a int, b int, c varchar(10)) dont_reuse_oid;
create table t2 (x int);
create class t3 class attribute (ca int, cb t1) (a int);
create unique index idx_t1_a on t1 (a);

insert into t1 values (1, 1, 'a'), (2, 2, 'b');
insert into t2 values (10), (20);
insert into t3 values (1);

select t1 into :o from t1 where a = 1;
select t1 into :o2 from t1 where a = 2;

evaluate 'Case 1: UPDATE OBJECT with a subquery in SET';
update object :o set a = (select max(x) from t2);
select * from dba.t_secret;

evaluate 'Case 2: UPDATE CLASS attribute with a subquery and an object host variable in SET';
update class t3 set ca = (select max(x) from t2), cb = :o2;
select class t3.ca, class t3.cb.a from t3;
select * from dba.t_secret;

evaluate 'Case 3: UPDATE with a subquery in SET';
update t1 set b = (select max(x) from t2), c = 'u' where a = 2;
select * from dba.t_secret;

evaluate 'Case 4: DELETE with a subquery in WHERE';
delete from t1 where a = (select max(x) from t2);
select * from dba.t_secret;

evaluate 'Case 5: MERGE with subqueries in both UPDATE and INSERT branches';
merge into t1 using t2 on (t1.a + 8 = t2.x)
  when matched then update set t1.b = (select max(x) from t2)
  when not matched then insert values ((select min(x) from t2) + t2.x, 9, 'm');
select * from dba.t_secret;

evaluate 'Case 6: INSERT VALUES with a subquery';
insert into t1 values ((select max(x) from t2) + 100, 5, 'i');
select * from dba.t_secret;

evaluate 'Case 7: INSERT ON DUPLICATE KEY UPDATE with a subquery';
insert into t1 values (2, 0, 'd') on duplicate key update b = (select min(x) from t2), c = 'odku';
select * from dba.t_secret;

evaluate 'Case 8: DO with a subquery';
do (select max(x) from t2);
select * from dba.t_secret;

evaluate 'Case 9: UPDATE OBJECT by dba, then login as u_26821';
call login ('dba', '') on class db_user;
update object :o2 set b = (select max(x) from u_26821.t2);
call login ('u_26821', '') on class db_user;
select * from dba.t_secret;

drop table t1, t2, t3;

call login ('dba', '') on class db_user;

drop table t_secret;
drop user u_26821;
