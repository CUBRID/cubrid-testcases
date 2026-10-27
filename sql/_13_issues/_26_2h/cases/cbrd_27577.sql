/**
 *  This test case verifies CBRD-27577: when the transaction rolls back to a savepoint, the user trigger
 *  cache is rebuilt on the next COMMIT, so it matches the catalog restored by the rollback.
 *
 *  ALTER TRIGGER ... OWNER TO marks the cache invalid, and ALTER TRIGGER ... PRIORITY of a user trigger
 *  rebuilds it at once, without t1 whose owner is u1 at that point. ROLLBACK TO SAVEPOINT restores the
 *  owner of t1 to DBA. Before the fix the cache kept the state before the rollback, so t1 did not run
 *  on the COMMIT of DBA.
 *
 *  Coverage:
 *    Case 1:  both user triggers of DBA run on the COMMIT after the rollback to the savepoint
 *    Case 2:  after DBA drops its user trigger, the COMMIT runs only the remaining one
 */

-- users
create user u1;

-- tables
create table dba.trg_log (trg varchar (32));

-- triggers
create trigger t1 before commit execute insert into dba.trg_log values ('t1');
create trigger x before commit execute insert into dba.trg_log values ('x');

evaluate 'Case 1. both user triggers of DBA run on the COMMIT after the rollback to the savepoint';
autocommit off;
delete from dba.trg_log;
savepoint sp;
alter trigger dba.t1 owner to u1;
alter trigger x priority 1.0;
rollback to savepoint sp;
commit;

-- Expected: dba.t1 DBA, dba.x DBA
select unique_name, owner.name from db_trigger order by 1;
-- Expected: t1, x
select trg from dba.trg_log order by 1;
autocommit on;

evaluate 'Case 2. after DBA drops its user trigger, the COMMIT runs only the remaining one';
autocommit off;
delete from dba.trg_log;
drop trigger t1;
commit;

-- Expected: dba.x DBA
select unique_name, owner.name from db_trigger order by 1;
-- Expected: x
select trg from dba.trg_log order by 1;
autocommit on;

-- cleanup
drop trigger x;
drop table dba.trg_log;
drop user u1;
