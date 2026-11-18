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
 *    Case 8:  an action that reads a view fails after the view is renamed
 *    Case 9:  an action fails while a rename is uncommitted and runs
 *             after the rollback
 *    Case 10: a condition fails after its view is renamed
 *    Case 11: a condition fails after the owner of its view changes
 */

drop table if exists src1, dst1, src2, dst2, new2, src3, dst3, new3, src4, dst4, new4, src5, dst5, src6, dst6, new6;
drop table if exists src7, dst7, new7, src8, from8, dst8, src9, dst9, src10, cond10, dst10, src11, cond11, dst11;
drop view if exists view1, old_view1, view2, old_view2, view3, view4, view5, view6, view7, view8, old_view8, view9, old_view9, view10, old_view10, view11;
create user u_27771;

-- dont_reuse_oid: a view over a table that reuses OIDs is not updatable
evaluate 'Case 1: after view1 is renamed, the insert into src1 fails and dst1 keeps one row';
create table src1 (c1 int);
create table dst1 (c1 int) dont_reuse_oid;
create view view1 as select c1 from dst1;
create trigger trig1 after insert on src1 execute insert into view1 values (obj.c1);
insert into src1 values (1);
rename view view1 as old_view1;
insert into src1 values (2);
select c1 from dst1 order by c1;

evaluate 'Case 2: after view2 is renamed and a new view2 is created on new2, trig2 writes 2 to new2';
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

evaluate 'Case 3: after ALTER VIEW moves view3 to new3, trig3 writes 2 to new3';
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

evaluate 'Case 4: after view4 is dropped and created again on new4, trig4 writes 2 to new4';
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

evaluate 'Case 5: after the owner of view5 changes, the insert into src5 fails and dst5 keeps one row';
create table src5 (c1 int);
create table dst5 (c1 int) dont_reuse_oid;
create view view5 as select c1 from dst5;
create trigger trig5 after insert on src5 execute insert into view5 values (obj.c1);
insert into src5 values (1);
alter view view5 owner to u_27771;
insert into src5 values (2);
select c1 from dst5 order by c1;

evaluate 'Case 6: after CREATE OR REPLACE VIEW moves view6 to new6, trig6 updates new6 to 2';
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

evaluate 'Case 7: after ALTER VIEW moves view7 to new7, trig7 deletes 2 from new7';
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

evaluate 'Case 8: after view8 is renamed, the insert into src8 fails and dst8 keeps one row';
create table src8 (c1 int);
create table from8 (c1 int);
create table dst8 (c1 int);
insert into from8 values (8);
create view view8 as select c1 from from8;
create trigger trig8 after insert on src8 execute insert into dst8 select c1 from view8;
insert into src8 values (1);
rename view view8 as old_view8;
insert into src8 values (2);
select c1 from dst8 order by c1;

evaluate 'Case 9: the insert into src9 fails while the rename of view9 is uncommitted, and trig9 writes 3 after the rollback';
create table src9 (c1 int);
create table dst9 (c1 int) dont_reuse_oid;
create view view9 as select c1 from dst9;
create trigger trig9 after insert on src9 execute insert into view9 values (obj.c1);
insert into src9 values (1);
autocommit off;
rename view view9 as old_view9;
insert into src9 values (2);
select c1 from dst9 order by c1;
rollback;
insert into src9 values (3);
select c1 from dst9 order by c1;
commit;
autocommit on;

evaluate 'Case 10: after view10 is renamed, the insert into src10 fails and dst10 keeps one row';
create table src10 (c1 int);
create table cond10 (c1 int);
create table dst10 (c1 int);
insert into cond10 values (1);
create view view10 as select c1 from cond10;
create trigger trig10 after insert on src10 if (select count(*) from view10) > 0 execute insert into dst10 values (obj.c1);
insert into src10 values (1);
rename view view10 as old_view10;
insert into src10 values (2);
select c1 from dst10 order by c1;

evaluate 'Case 11: after the owner of view11 changes, the insert into src11 fails and dst11 keeps one row';
create table src11 (c1 int);
create table cond11 (c1 int);
create table dst11 (c1 int);
insert into cond11 values (1);
create view view11 as select c1 from cond11;
create trigger trig11 after insert on src11 if (select count(*) from view11) > 0 execute insert into dst11 values (obj.c1);
insert into src11 values (1);
alter view view11 owner to u_27771;
insert into src11 values (2);
select c1 from dst11 order by c1;

drop view old_view1, view2, old_view2, view3, view4, u_27771.view5, view6, view7, old_view8, view9, old_view10, u_27771.view11;
drop table src1, dst1, src2, dst2, new2, src3, dst3, new3, src4, dst4, new4, src5, dst5, src6, dst6, new6;
drop table src7, dst7, new7, src8, from8, dst8, src9, dst9, src10, cond10, dst10, src11, cond11, dst11;
drop user u_27771;
