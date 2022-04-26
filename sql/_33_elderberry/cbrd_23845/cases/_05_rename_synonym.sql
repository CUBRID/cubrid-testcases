/*
 * test group #4: rename synonym.
 *   - without as/to
 *   - general
 *   - user/synonym does not exist
 *   - change owner
 *   - with same name
 */

-- without as/to
create synonym s1 for db_class;
create private synonym s2 for db_class;
select * from _db_synonym order by 1;
--err case
rename synonym s1;
rename private synonym s2;
drop synonym s1;
drop synonym s2;

-- general
create synonym s1 for db_class;
create private synonym s2 for db_class;
select * from _db_synonym order by 1;

rename synonym s1 to new_s1;
rename private synonym s2 to new_s2;
select * from _db_synonym order by 1;

create user u1;
drop table if exists t1;
create table t1 (c1 int);
create synonym u1.s1 for u1.t1;
create private synonym u1.s2 for u1.t1;
select * from _db_synonym order by 1;

rename synonym u1.s1 to u1.new_s1;
rename private synonym u1.s2 to u1.new_s2;
select * from _db_synonym order by 1;

drop synonym u1.new_s1;
drop synonym u1.new_s2;
drop synonym new_s1;
drop synonym new_s2;
drop table t1;
drop user u1;

-- user/synonym does not exist
--err case
select * from _db_synonym order by 1;
rename synonym s1 to new_s1;
rename private synonym s2 to new_s2;
rename synonym u1.s1 to new_s1;
rename private synonym u1.s2 to new_s2;

-- change owner
create user u1;
create user u2;
drop table if exists u1.t1;
create table u1.t1 (c1 int);
create synonym u1.s1 for u1.t1;
create private synonym u1.s2 for u1.t1;
select * from _db_synonym order by 1;

--err case
rename synonym u1.s1 to u2.s1;
rename private synonym u1.s2 to u2.s2;

drop synonym u1.s1;
drop private synonym u1.s2;
drop table u1.t1;
drop user u2;
drop user u1;

-- with same name
create synonym s1 for db_class;
create private synonym s2 for db_class;
select * from _db_synonym order by 1;

--err case
rename synonym s1 to s1;
rename private synonym s2 to s2;

create user u1;
drop table if exists u1.t1;
create table u1.t1 (c1 int);
create synonym u1.s1 for u1.t1;
create private synonym u1.s2 for u1.t1;
select * from _db_synonym order by 1;

--err case
rename synonym u1.s1 to u1.s1;
rename private synonym u1.s2 to u1.s2;

drop synonym u1.s1;
drop private synonym u1.s2;
drop synonym s1;
drop private synonym s2;
drop table u1.t1;
drop user u1;
