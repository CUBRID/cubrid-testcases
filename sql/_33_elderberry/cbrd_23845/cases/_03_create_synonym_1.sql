/*
 * test group #2: create synonym.
 *   - without for
 *   - incorrect use of to instead of for
 *   - without comment string
 *   - only or replace
 *   - with comment
 *   - user does not exist
 *   - target does not exist
 *   - already exist
 *
 */

-- create synonym
-- without for
--err case
create synonym s1;
create private synonym s2;
create public synonym s3;
create synonym or replace s1;
create private synonym or replace s2;
create public synonym or replace s3;
create synonym s1 comment;
create private synonym s2 comment;
create public synonym s3 comment;
create synonym s1 comment 'synonym of db_class';
create private synonym s2 comment 'private synonym of db_class';
create public synonym s3 comment 'public synonym of db_class';
select * from _db_synonym order by 1;

-- incorrect use of to instead of for
drop synonym if exists s1;
drop synonym if exists s2;
drop synonym if exists s3;
--err case
create synonym s1 to db_class;
create private synonym s2 to db_class;
create public synonym s3 to db_class;
select * from _db_synonym order by 1;

-- without comment string
drop synonym if exists s1;
drop synonym if exists s2;
drop synonym if exists s3;
--err case
create synonym s1 for db_class comment;
create private synonym s2 for db_class comment;
create public synonym s3 for db_class comment;
select * from _db_synonym order by 1;

-- with dot(.)
--err case
create synonym [u1.s1] for db_class;
create synonym "u1.s1" for db_class;
create synonym `u1.s1` for db_class;
create private synonym [u1.s2] for db_class;
create private synonym "u1.s2" for db_class;
create private synonym `u1.s2` for db_class;
create public synonym [u1.s3] for db_class;
create public synonym "u1.s3" for db_class;
create public synonym `u1.s3` for db_class;
select * from _db_synonym order by 1;

-- with comment
create synonym s1 for db_class comment 'synonym of db_class';
create private synonym s2 for db_class comment 'private synonym of db_class';
create user u1;
drop table if exists u1.t1;
drop synonym if exists u1.s1;
create table u1.t1 (c1 int);
create synonym u1.s1 for u1.t1 comment 'synonym of db_class';
create private synonym u1.s2 for u1.t2 comment 'private synonym of db_class';
-- err case : public synonym is not supported.
create public synonym s3 for db_class comment 'public synonym of db_class';
create public synonym u1.s3 for u1.t3 comment 'public synonym of db_class';
select * from _db_synonym order by 1;

drop synonym s1;
drop private synonym s2;
drop synonym u1.s1;
drop private synonym u1.s2;
drop table u1.t1;
drop user u1;

-- user does not exist
--err case
create synonym u1.s1 for db_class;
create private synonym u1.s2 for db_class;
create public synonym u1.s3 for db_class;
create synonym s1 for u1.db_class;
create private synonym s2 for u1.db_class;
create public synonym s3 for u1.db_class;
select * from _db_synonym order by 1;

-- target does not exist
drop synonym if exists s1;
drop synonym if exists s2;
create synonym s1 for db_null;
create private synonym s2 for db_null;

create user u1;
drop synonym if exists u1.s1;
drop synonym if exists u1.s2;
create synonym u1.s1 for u1.t1;
create private synonym u1.s2 for u1.t1;
-- err case : public synonym is not supported.
create public synonym s3 for db_null;
create public synonym u1.s3 for u1.t1;

select * from _db_synonym order by 1;

drop synonym s1;
drop private synonym s2;
drop synonym u1.s1;
drop private synonym u1.s2;
drop user u1;

-- already exist
drop synonym if exists s1;
drop synonym if exists s2;
create synonym s1 for db_class;
create private synonym s2 for db_class;
-- err case 
create synonym s1 for db_class comment 'synonym of db_index';
create private synonym s2 for db_class comment 'synonym of db_index';
-- err case : public synonym is not supported.
create public synonym s3 for db_class;
create public synonym s3 for db_class comment 'synonym of db_index';

select * from _db_synonym order by 1;

drop synonym s1;
drop private synonym s2;

-- or replace
drop synonym if exists s1;
drop synonym if exists s2;
create synonym s1 for db_class comment 'synonym of db_class';
create private synonym s2 for db_class comment 'private synonym of db_class';
-- err case : public synonym is not supported.
create public synonym s3 for db_class comment 'public synonym of db_class';
select * from _db_synonym order by 1;

create or replace synonym s1 for db_index;
create or replace private synonym s2 for db_index;
-- err case : public synonym is not supported.
create or replace public synonym s3 for db_index;
select * from _db_synonym order by 1;

create user u1;
drop table if exists u1.t1;
drop table if exists u1.t2;
drop synonym if exists u1.s1;
drop synonym if exists u1.s2;
create table u1.t1 (c1 int);
create table u1.t2 (c1 int);
create synonym u1.s1 for u1.t1 comment 'synonym of db_class';
create private synonym u1.s2 for u1.t1 comment 'private synonym of db_class';
-- err case : public synonym is not supported.
create public synonym u1.s3 for u1.t1 comment 'public synonym of db_class';
select * from _db_synonym order by 1;

create or replace synonym u1.s1 for u1.t2;
create or replace private synonym u1.s2 for u1.t2;
-- err case : public synonym is not supported.
create or replace public synonym u1.s3 for u1.t2;
select * from _db_synonym order by 1;

drop synonym s1;
drop private synonym s2;
drop synonym u1.s1;
drop private synonym u1.s2;
drop table u1.t1;
drop table u1.t2;
drop user u1;
