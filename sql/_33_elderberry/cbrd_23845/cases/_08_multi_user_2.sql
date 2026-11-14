/**
 *  This test case verifies CBRD-23845: the same synonym name for different users
 *
 *  dba and u1 each create a synonym s1 for db_class. A name without an owner resolves to
 *  the synonym of the current user, and a name with an owner to the synonym of that owner.
 *  db_class shows to each user only the classes that user may see.
 *
 *  Revised for CBRD-26470 (package catalog changes).
 *
 *  Coverage:
 *    Case 1:  as u1, the synonym u1.s1 and the synonym dba.s1, both for db_class, count the same rows
 *    Case 2:  as dba, the synonym s1 and the synonym u1.s1 count the same rows
 *    Case 3:  after the cleanup, db_synonym lists no synonym and db_class lists no user class
 */

call login ('dba') on class db_user;
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;
drop table if exists t4;
drop table if exists t5;
drop synonym if exists s1;

create table t1 (c1 int);
create table t2 (c1 int);
create table t3 (c1 int);
create table t4 (c1 int);
create table t5 (c1 int);
create synonym s1 for db_class;
create user u1;

evaluate 'Case 1: as u1, the synonym u1.s1 and the synonym dba.s1, both for db_class, count the same rows';
call login ('u1') on class db_user;
drop synonym if exists s1;
create synonym s1 for db_class;
select count(*) from s1;
select count(*) from dba.s1;

evaluate 'Case 2: as dba, the synonym s1 and the synonym u1.s1 count the same rows';
call login ('dba') on class db_user;
select count(*) from s1;
select count(*) from u1.s1;

call login ('dba') on class db_user;
drop synonym if exists u1.s1;
drop synonym if exists s1;
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;
drop table if exists t4;
drop table if exists t5;
drop user u1;

evaluate 'Case 3: after the cleanup, db_synonym lists no synonym and db_class lists no user class';
select synonym_name, synonym_owner_name, is_public_synonym, target_name, target_owner_name, comment from db_synonym;
select class_name, owner_name, class_type, is_system_class, tde_algorithm, partitioned, is_reuse_oid_class, collation, comment from db_class where is_system_class = upper ('NO');

