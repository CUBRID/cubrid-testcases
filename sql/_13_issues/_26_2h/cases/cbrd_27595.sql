/**
 *  CBRD-27595: UPDATE and DELETE must reject a reference to a SEMI / ANTI JOIN inner table
 *  outside that join's ON condition, and an ON condition that does not reference the outer
 *  table, with the -494 that SELECT already raises.
 *
 *  A SEMI JOIN stops reading the inner at the first matching row and an ANTI JOIN keeps an
 *  outer row only when no inner row matched, so after the join the inner's columns hold
 *  whatever row the scan read last. SELECT rejects such a reference. UPDATE and DELETE ran
 *  it: SET t1.c3 = t2.c2 stored the value of a t2 row that did not match the t1 row, and a
 *  DELETE with a t2 column in its WHERE removed t1 rows that had a match.
 *
 *  Every case runs the UPDATE or DELETE with a SEMI JOIN and with an ANTI JOIN. A statement
 *  that runs assigns the value the column already has or deletes no row, so every case sees
 *  the same data.
 *
 *  Coverage:
 *  1    an inner column in the SET clause
 *  2    an inner column in the WHERE of an UPDATE; a WHERE on an outer column runs
 *  3    an inner column in the WHERE of a DELETE
 *  4    the inner table as the DELETE target; the outer table as the target runs
 *  5    an ON condition that does not reference the outer table
 */

drop table if exists t1, t2;

create table t1 (c1 int primary key, c2 int not null, c3 int);
create table t2 (c1 int not null, c2 int);

insert into t1 values (1, 20, 0), (2, 30, 0), (3, 20, 0), (4, 40, 0);
insert into t2 values (20, 200), (20, 201), (30, 300);


evaluate 'Case 1: an inner column in the SET clause';
update t1 semi join t2 on t1.c2 = t2.c1 set t1.c3 = t2.c2;
update t1 anti join t2 on t1.c2 = t2.c1 set t1.c3 = t2.c2;


evaluate 'Case 2: an inner column in the WHERE of an UPDATE -- a WHERE on an outer column runs';
update t1 semi join t2 on t1.c2 = t2.c1 set t1.c3 = 0 where t2.c2 = 201;
update t1 anti join t2 on t1.c2 = t2.c1 set t1.c3 = 0 where t2.c2 = 201;
update t1 semi join t2 on t1.c2 = t2.c1 set t1.c3 = 0 where t1.c1 > 1;
update t1 anti join t2 on t1.c2 = t2.c1 set t1.c3 = 0 where t1.c1 > 1;


evaluate 'Case 3: an inner column in the WHERE of a DELETE';
delete t1 from t1 semi join t2 on t1.c2 = t2.c1 where t2.c2 = 300;
delete t1 from t1 anti join t2 on t1.c2 = t2.c1 where t2.c2 = 300;


evaluate 'Case 4: the inner table as the DELETE target -- the outer table as the target runs';
delete t2 from t1 semi join t2 on t1.c2 = t2.c1 where t1.c1 > 10;
delete t2 from t1 anti join t2 on t1.c2 = t2.c1 where t1.c1 > 10;
delete t1 from t1 semi join t2 on t1.c2 = t2.c1 where t1.c1 > 10;
delete t1 from t1 anti join t2 on t1.c2 = t2.c1 where t1.c1 > 10;


evaluate 'Case 5: an ON condition that does not reference the outer table';
update t1 semi join t2 on 1 = 1 set t1.c3 = 0;
update t1 anti join t2 on 1 = 1 set t1.c3 = 0;
delete t1 from t1 semi join t2 on 1 = 1;
delete t1 from t1 anti join t2 on 1 = 1;


drop table t1, t2;
