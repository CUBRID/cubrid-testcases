/**
 *  This test case verifies CBRD-27771: a trigger condition or action that a
 *  session has compiled is compiled again when a view it names changes.
 *
 *  Each case fires its trigger once, changes the view, and fires it again.
 *  Before the fix the second firing ran the statement compiled against the
 *  old view.
 *
 *  Coverage:
 *    Case 1:  an action fails after its view is renamed
 *    Case 2:  an action follows a view renamed and replaced by a new view
 *    Case 3:  an action follows ALTER VIEW to another table
 *    Case 4:  an action follows a view dropped and created again
 *    Case 5:  an action fails after the owner of its view changes
 *    Case 6:  an UPDATE action follows CREATE OR REPLACE VIEW
 *    Case 7:  a DELETE action follows ALTER VIEW
 *    Case 8:  a MERGE action follows ALTER VIEW
 *    Case 9:  a REPLACE action follows ALTER VIEW
 *    Case 10: an INSERT ... ON DUPLICATE KEY UPDATE action follows ALTER VIEW
 *    Case 11: an action that reads a view fails after the view is renamed
 *    Case 12: under READ COMMITTED, an action fails while a rename is
 *             uncommitted and runs after the rollback
 *    Case 13: under REPEATABLE READ, an action fails while a rename is
 *             uncommitted and runs after the rollback
 *    Case 14: under SERIALIZABLE, an action fails while a rename is
 *             uncommitted and runs after the rollback
 *    Case 15: a condition fails after its view is renamed
 *    Case 16: a condition fails after the owner of its view changes
 */

drop table if exists src1, dst1, src2, dst2, new2, src3, dst3, new3, src4, dst4, new4, src5, dst5, src6, dst6, new6;
drop table if exists src7, dst7, new7, src8, dst8, new8, src9, dst9, new9, src10, dst10, new10;
drop table if exists src11, from11, dst11, src12, dst12, src13, dst13, src14, dst14, src15, cond15, dst15, src16, cond16, dst16;
drop view if exists view1, old_view1, view2, old_view2, view3, view4, view5, view6, view7, view8, view9, view10;
drop view if exists view11, old_view11, view12, old_view12, view13, old_view13, view14, old_view14, view15, old_view15, view16;
create user u_27771;

-- dont_reuse_oid: a view over a table that reuses OIDs is not updatable
evaluate 'Case 1: after view1 is renamed, the insert into src1 fails and src1 and dst1 keep one row';
create table src1 (c1 int);
create table dst1 (c1 int) dont_reuse_oid;
create view view1 as select c1 from dst1;
create trigger trig1 after insert on src1 execute insert into view1 values (obj.c1);
insert into src1 values (1);
rename view view1 as old_view1;
insert into src1 values (2);
select c1 from src1 order by c1;
select c1 from dst1 order by c1;

evaluate 'Case 2: after view2 is renamed and a new view2 is created on new2, trig2 writes 2 to new2 and dst2 keeps one row';
create table src2 (c1 int);
create table dst2 (c1 int) dont_reuse_oid;
create table new2 (c1 int) dont_reuse_oid;
create view view2 as select c1 from dst2;
create trigger trig2 after insert on src2 execute insert into view2 values (obj.c1);
insert into src2 values (1);
rename view view2 as old_view2;
create view view2 as select c1 from new2;
insert into src2 values (2);
select c1 from dst2 order by c1;
select c1 from new2 order by c1;

evaluate 'Case 3: after ALTER VIEW moves view3 to new3, trig3 writes 2 to new3 and dst3 keeps one row';
create table src3 (c1 int);
create table dst3 (c1 int) dont_reuse_oid;
create table new3 (c1 int) dont_reuse_oid;
create view view3 as select c1 from dst3;
create trigger trig3 after insert on src3 execute insert into view3 values (obj.c1);
insert into src3 values (1);
alter view view3 as select c1 from new3;
insert into src3 values (2);
select c1 from dst3 order by c1;
select c1 from new3 order by c1;

evaluate 'Case 4: after view4 is dropped and created again on new4, trig4 writes 2 to new4 and dst4 keeps one row';
create table src4 (c1 int);
create table dst4 (c1 int) dont_reuse_oid;
create table new4 (c1 int) dont_reuse_oid;
create view view4 as select c1 from dst4;
create trigger trig4 after insert on src4 execute insert into view4 values (obj.c1);
insert into src4 values (1);
drop view view4;
create view view4 as select c1 from new4;
insert into src4 values (2);
select c1 from dst4 order by c1;
select c1 from new4 order by c1;

-- CTP runs as dba: after the owner change, view5 in the action means dba.view5, which no longer exists
evaluate 'Case 5: after the owner of view5 changes, the insert into src5 fails and src5 and dst5 keep one row';
create table src5 (c1 int);
create table dst5 (c1 int) dont_reuse_oid;
create view view5 as select c1 from dst5;
create trigger trig5 after insert on src5 execute insert into view5 values (obj.c1);
insert into src5 values (1);
alter view view5 owner to u_27771;
insert into src5 values (2);
select c1 from src5 order by c1;
select c1 from dst5 order by c1;

evaluate 'Case 6: after CREATE OR REPLACE VIEW moves view6 to new6, trig6 updates new6 to 2 and dst6 keeps 1';
create table src6 (c1 int);
create table dst6 (c1 int) dont_reuse_oid;
create table new6 (c1 int) dont_reuse_oid;
insert into dst6 values (0);
insert into new6 values (0);
create view view6 as select c1 from dst6;
create trigger trig6 after insert on src6 execute update view6 set c1 = obj.c1;
insert into src6 values (1);
create or replace view view6 as select c1 from new6;
insert into src6 values (2);
select c1 from dst6 order by c1;
select c1 from new6 order by c1;

evaluate 'Case 7: after ALTER VIEW moves view7 to new7, trig7 deletes 2 from new7 and dst7 keeps 2';
create table src7 (c1 int);
create table dst7 (c1 int) dont_reuse_oid;
create table new7 (c1 int) dont_reuse_oid;
insert into dst7 values (1), (2);
insert into new7 values (1), (2);
create view view7 as select c1 from dst7;
create trigger trig7 after insert on src7 execute delete from view7 where c1 = obj.c1;
insert into src7 values (1);
alter view view7 as select c1 from new7;
insert into src7 values (2);
select c1 from dst7 order by c1;
select c1 from new7 order by c1;

evaluate 'Case 8: after ALTER VIEW moves view8 to new8, trig8 merges 2 into new8 and dst8 keeps one row';
create table src8 (c1 int);
create table dst8 (c1 int) dont_reuse_oid;
create table new8 (c1 int) dont_reuse_oid;
create view view8 as select c1 from dst8;
create trigger trig8 after insert on src8 execute merge into view8 t using db_root on (t.c1 = obj.c1) when not matched then insert values (obj.c1);
insert into src8 values (1);
alter view view8 as select c1 from new8;
insert into src8 values (2);
select c1 from dst8 order by c1;
select c1 from new8 order by c1;

evaluate 'Case 9: after ALTER VIEW moves view9 to new9, trig9 writes 2 to new9 and dst9 keeps one row';
create table src9 (c1 int);
create table dst9 (c1 int) dont_reuse_oid;
create table new9 (c1 int) dont_reuse_oid;
create view view9 as select c1 from dst9;
create trigger trig9 after insert on src9 execute replace into view9 values (obj.c1);
insert into src9 values (1);
alter view view9 as select c1 from new9;
insert into src9 values (2);
select c1 from dst9 order by c1;
select c1 from new9 order by c1;

evaluate 'Case 10: after ALTER VIEW moves view10 to new10, trig10 writes 2 to new10 and dst10 keeps one row';
create table src10 (c1 int);
create table dst10 (c1 int) dont_reuse_oid;
create table new10 (c1 int) dont_reuse_oid;
create view view10 as select c1 from dst10;
create trigger trig10 after insert on src10 execute insert into view10 values (obj.c1) on duplicate key update c1 = obj.c1;
insert into src10 values (1);
alter view view10 as select c1 from new10;
insert into src10 values (2);
select c1 from dst10 order by c1;
select c1 from new10 order by c1;

evaluate 'Case 11: after view11 is renamed, the insert into src11 fails and src11 and dst11 keep one row';
create table src11 (c1 int);
create table from11 (c1 int);
create table dst11 (c1 int);
insert into from11 values (11);
create view view11 as select c1 from from11;
create trigger trig11 after insert on src11 execute insert into dst11 select c1 from view11;
insert into src11 values (1);
rename view view11 as old_view11;
insert into src11 values (2);
select c1 from src11 order by c1;
select c1 from dst11 order by c1;

-- READ COMMITTED is the CTP default, so Case 12 sets no isolation level
evaluate 'Case 12: under READ COMMITTED, while the rename of view12 is uncommitted, the insert into src12 fails and src12 and dst12 keep one row, and trig12 writes 3 after the rollback';
create table src12 (c1 int);
create table dst12 (c1 int) dont_reuse_oid;
create view view12 as select c1 from dst12;
create trigger trig12 after insert on src12 execute insert into view12 values (obj.c1);
insert into src12 values (1);
get transaction isolation level into :isolation_level;
select :isolation_level;
autocommit off;
rename view view12 as old_view12;
insert into src12 values (2);
select c1 from src12 order by c1;
select c1 from dst12 order by c1;
rollback;
insert into src12 values (3);
select c1 from dst12 order by c1;
commit;
autocommit on;

evaluate 'Case 13: under REPEATABLE READ, while the rename of view13 is uncommitted, the insert into src13 fails and src13 and dst13 keep one row, and trig13 writes 3 after the rollback';
create table src13 (c1 int);
create table dst13 (c1 int) dont_reuse_oid;
create view view13 as select c1 from dst13;
create trigger trig13 after insert on src13 execute insert into view13 values (obj.c1);
insert into src13 values (1);
set transaction isolation level repeatable read;
get transaction isolation level into :isolation_level;
select :isolation_level;
autocommit off;
rename view view13 as old_view13;
insert into src13 values (2);
select c1 from src13 order by c1;
select c1 from dst13 order by c1;
rollback;
insert into src13 values (3);
select c1 from dst13 order by c1;
commit;
autocommit on;

evaluate 'Case 14: under SERIALIZABLE, while the rename of view14 is uncommitted, the insert into src14 fails and src14 and dst14 keep one row, and trig14 writes 3 after the rollback';
create table src14 (c1 int);
create table dst14 (c1 int) dont_reuse_oid;
create view view14 as select c1 from dst14;
create trigger trig14 after insert on src14 execute insert into view14 values (obj.c1);
insert into src14 values (1);
set transaction isolation level serializable;
get transaction isolation level into :isolation_level;
select :isolation_level;
autocommit off;
rename view view14 as old_view14;
insert into src14 values (2);
select c1 from src14 order by c1;
select c1 from dst14 order by c1;
rollback;
insert into src14 values (3);
select c1 from dst14 order by c1;
commit;
autocommit on;
set transaction isolation level read committed;

evaluate 'Case 15: after view15 is renamed, the insert into src15 fails and src15 and dst15 keep one row';
create table src15 (c1 int);
create table cond15 (c1 int);
create table dst15 (c1 int);
insert into cond15 values (1);
create view view15 as select c1 from cond15;
create trigger trig15 after insert on src15 if (select count(*) from view15) > 0 execute insert into dst15 values (obj.c1);
insert into src15 values (1);
rename view view15 as old_view15;
insert into src15 values (2);
select c1 from src15 order by c1;
select c1 from dst15 order by c1;

-- CTP runs as dba: after the owner change, view16 in the condition means dba.view16, which no longer exists
evaluate 'Case 16: after the owner of view16 changes, the insert into src16 fails and src16 and dst16 keep one row';
create table src16 (c1 int);
create table cond16 (c1 int);
create table dst16 (c1 int);
insert into cond16 values (1);
create view view16 as select c1 from cond16;
create trigger trig16 after insert on src16 if (select count(*) from view16) > 0 execute insert into dst16 values (obj.c1);
insert into src16 values (1);
alter view view16 owner to u_27771;
insert into src16 values (2);
select c1 from src16 order by c1;
select c1 from dst16 order by c1;

drop view old_view1, view2, old_view2, view3, view4, u_27771.view5, view6, view7, view8, view9, view10;
drop view old_view11, view12, view13, view14, old_view15, u_27771.view16;
drop table src1, dst1, src2, dst2, new2, src3, dst3, new3, src4, dst4, new4, src5, dst5, src6, dst6, new6;
drop table src7, dst7, new7, src8, dst8, new8, src9, dst9, new9, src10, dst10, new10;
drop table src11, from11, dst11, src12, dst12, src13, dst13, src14, dst14, src15, cond15, dst15, src16, cond16, dst16;
drop user u_27771;
