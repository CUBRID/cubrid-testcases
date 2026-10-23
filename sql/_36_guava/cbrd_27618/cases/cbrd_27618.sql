/**
 *  This test case verifies CBRD-27618: a trigger condition or action that a
 *  session has compiled is compiled again when a class it refers to changes.
 *  That an action fails to compile after a rename or an owner change, whether
 *  or not it fired before, is checked by rename2-3 and change_owner2-3 in
 *  sql/_33_elderberry/cbrd_23844/cbrd_24195.
 */

drop table if exists src1, dst1, old1, src2, mid2, dst2, old2, src3, cond3, dst3, old3, src4, cond4, dst4, old4;

-- 1. After trig1 has fired, it writes to a new dst1 created after dst1 is
--    renamed to old1.
create table src1 (c1 int);
create table dst1 (c1 int);
create trigger trig1 after insert on src1 execute insert into dst1 values (obj.c1);
insert into src1 values (1);
rename table dst1 to old1;
create table dst1 (c1 int);
insert into src1 values (2);
select c1 from dst1;

-- 2. After trig2a's action has fired trig2b, the insert into src2 fails once
--    dst2 is renamed to old2, since trig2b's action no longer compiles.
create table src2 (c1 int);
create table mid2 (c1 int);
create table dst2 (c1 int);
create trigger trig2a after insert on src2 execute insert into mid2 values (obj.c1);
create trigger trig2b after insert on mid2 execute insert into dst2 values (obj.c1);
insert into src2 values (1);
rename table dst2 to old2;
insert into src2 values (2);

-- 3. When cond3 is renamed to old3 before trig3 first fires, trig3's condition
--    fails to compile.
create table src3 (c1 int);
create table cond3 (c1 int);
create table dst3 (c1 int);
create trigger trig3 after insert on src3 if (select count(*) from cond3) > 0 execute insert into dst3 values (obj.c1);
rename table cond3 to old3;
insert into src3 values (1);

-- 4. When cond4 is renamed to old4 after trig4 has evaluated its condition, the
--    condition fails to compile.
create table src4 (c1 int);
create table cond4 (c1 int);
create table dst4 (c1 int);
create trigger trig4 after insert on src4 if (select count(*) from cond4) > 0 execute insert into dst4 values (obj.c1);
insert into src4 values (1);
rename table cond4 to old4;
insert into src4 values (2);

drop table src1, dst1, old1, src2, mid2, old2, src3, dst3, old3, src4, dst4, old4;
