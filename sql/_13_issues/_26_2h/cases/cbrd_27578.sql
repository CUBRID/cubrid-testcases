/**
 *  This test case verifies CBRD-27578: RENAME TRIGGER that changes the owner of the trigger name is refused,
 *  as RENAME TABLE is. Before the fix only the unique_name moved to the other user and the owner stayed.
 *
 *  Coverage:
 *    Case 1:  DBA renames u2.trg to a name of u1, refused
 *    Case 2:  DBA renames u2.trg keeping u2, allowed
 */

-- users
create user u1;
create user u2;

-- tables
create table u2.t (a int);
create table u2.t_log (a int);

-- triggers
create trigger u2.trg after insert on u2.t execute insert into u2.t_log values (obj.a);

evaluate 'Case 1. DBA renames u2.trg to a name of u1, refused';
rename trigger u2.trg as u1.trg;
-- Expected: u2.trg U2
select unique_name, owner.name from db_trigger order by 1;

evaluate 'Case 2. DBA renames u2.trg keeping u2, allowed';
rename trigger u2.trg as u2.trg2;
-- Expected: u2.trg2 U2
select unique_name, owner.name from db_trigger order by 1;

-- cleanup
drop trigger u2.trg2;
drop table u2.t_log;
drop table u2.t;
drop user u2;
drop user u1;
