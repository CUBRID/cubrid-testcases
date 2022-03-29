/*
 *      3. CREATE TABLE, SERIAL, TRIGGER. OWNED BY NORMAL USER. BY NORMAL USER.
 */

create user u1;
create user u2;
call login ('u2') on class db_user;
select user;
create table u1.t1 (c1 int);
create serial u1.s1;
create table t1 (c1 int);
create table t2 (c1 int);
create trigger u1.trig1 after insert on t1 execute insert into t2 values (obj.c1);

call login ('dba') on class db_user;
drop table u2.t2;
drop table u2.t1;
drop user u2;
drop user u1;
