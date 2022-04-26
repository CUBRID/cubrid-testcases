/*
 * test group #3: alter synonym.
 *   - without for
 *   - incorrect use of to instead of for
 *   - without comment string
 *   - with comment
 *   - user does not exist
 *   - target does not exist
 *
 */

--prepare
drop synonym if exists s1;
drop synonym if exists s2;
create synonym s1 for db_class;
create private synonym s2 for db_class;
select * from _db_synonym order by 1;

-- without for
--err case
alter synonym s1;
alter private synonym s2;
select * from _db_synonym order by 1;

-- incorrect use of to instead of for
--err case
alter synonym s1 to db_index;
alter private synonym s2 to db_index;
select * from _db_synonym order by 1;

-- without comment string
--err case
alter synonym s1 for db_index comment;
alter private synonym s2 for db_index comment;
select * from _db_synonym order by 1;

drop synonym s1;
drop synonym s2;

-- with comment
drop synonym if exists s1;
drop synonym if exists s2;
create synonym s1 for db_class comment 'synonym of db_class.';
create private synonym s2 for db_class comment 'private synonym of db_class.';
select * from _db_synonym order by 1;

alter synonym s1 for db_index;
alter private synonym s2 for db_index;
select * from _db_synonym order by 1;

create user u1;
drop table if exists u1.t1;
drop table if exists u1.t2;
drop synonym if exists u1.s1;
drop synonym if exists u1.s2;
create table u1.t1 (c1 int);
create table u1.t2 (c1 int);
create synonym u1.s1 for u1.t1 comment 'synonym of u1.t1.';
create private synonym u1.s2 for u1.t1 comment 'private synonym of u1.t1.';
select * from _db_synonym order by 1;

alter synonym u1.s1 for u1.t2;
alter private synonym u1.s2 for u1.t2;
select * from _db_synonym order by 1;

drop synonym s1;
drop private synonym s2;
drop synonym u1.s1;
drop private synonym u1.s2;
drop table u1.t1;
drop table u1.t2;
drop user u1;

-- user does not exist
create user u1;
drop table if exists u1.t1;
drop synonym if exists u1.s1;
drop synonym if exists u1.s2;
create table u1.t1 (c1 int);
create synonym u1.s1 for u1.t1;
create private synonym u1.s2 for u1.t1;
select * from _db_synonym order by 1;
--err case
alter synonym u1.s1 for u2.t1;
alter private synonym u1.s2 for u2.t1;
select * from _db_synonym order by 1;

drop synonym u1.s1;
drop synonym u1.s2;
drop table u1.t1;
drop user u1;

-- target does not exist
drop synonym if exists s1;
drop synonym if exists s2;
create synonym s1 for db_class;
create private synonym s2 for db_class;
select * from _db_synonym order by 1;

alter synonym s1 for db_null;
alter private synonym s2 for db_null;
select * from _db_synonym order by 1;

create user u1;
drop table if exists u1.t1;
drop synonym if exists u1.s1;
drop synonym if exists u1.s2;
create table u1.t1 (c1 int);
create synonym u1.s1 for u1.t1;
create private synonym u1.s2 for u1.t1;
select * from _db_synonym order by 1;

alter synonym u1.s1 for u1.t2;
alter private synonym u1.s2 for u1.t2;
select * from _db_synonym order by 1;

drop synonym s1;
drop private synonym s2;
drop synonym u1.s1;
drop private synonym u1.s2;
drop table u1.t1;
drop user u1;
