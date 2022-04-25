/*
 * test group #5: drop synonym.
 *   - only if exists
 *   - general
 *   - user/synonym does not exist
 */

-- only if exists
-- err case
drop synonym if exists;
drop private synonym if exists;
drop public synonym if exists;

-- general
create synonym s1 for db_class;
create private synonym s2 for db_class;
select * from _db_synonym order by 1;

drop synonym s1;
drop private synonym s2;
select * from _db_synonym order by 1;

create user u1;
drop table if exists u1.t1;
create table u1.t1 (c1 int);
create synonym u1.s1 for u1.t1;
create private synonym u1.s2 for u1.t1;
select * from _db_synonym order by 1;

drop synonym u1.s1;
drop private synonym u1.s2;
select * from _db_synonym order by 1;

-- user/synonym does not exist
drop synonym if exists s1;
drop private synonym if exists s2;
--err case
drop synonym s1;
drop private synonym s2;
drop synonym if exists u1.s1;
drop private synonym if exists u1.s2;

