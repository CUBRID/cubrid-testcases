/* create trigger - check if the identifier name includes a dot(.). */

create user u1;
call login ('u1') on class db_user;
create table u1.t1 (c1 int, c2 varchar, c3 datetime);
create table u1.t2 (c1 int, c2 varchar, c3 datetime);
create trigger u1.trig1 after insert on u1.t1 execute insert into t2 values (obj.c1, obj.c2, obj.c3);

create trigger u1.trig1.trig1 after insert on u1.t1 execute insert into t2 values (obj.c1, obj.c2, obj.c3);

create trigger [trig2.trig2] after insert on u1.t1 execute insert into t2 values (obj.c1, obj.c2, obj.c3);

create trigger "trig3.trig3" after insert on u1.t1 execute insert into t2 values (obj.c1, obj.c2, obj.c3);

create trigger `trig4.trig4` after insert on u1.t1 execute insert into t2 values (obj.c1, obj.c2, obj.c3);

call login ('u1') on class db_user;
drop trigger trig1;
drop table t2;
drop table t1;
call login ('dba') on class db_user;
drop user u1;
