/**
 *  This test case verifies CBRD-27577: when the transaction rolls back to a savepoint, the user trigger
 *  cache is rebuilt on the next COMMIT, so it matches the catalog restored by the rollback.
 *
 *  ALTER TRIGGER ... OWNER TO and ALTER TRIGGER ... PRIORITY of a user trigger in a transaction, then
 *  ROLLBACK TO SAVEPOINT. The user trigger cache is built from the owner of each trigger, so it must be
 *  rebuilt after the rollback restores the owner of t1. Both user triggers of DBA run on the COMMIT, as
 *  before the change of the user trigger cache.
 *
 *  Coverage:
 *    Case 1:  both user triggers of DBA run on the COMMIT after the rollback to the savepoint
 *    Case 2:  after DBA drops its user trigger, the COMMIT runs only the remaining one
 */

-- users
create user u1;

-- tables
drop table if exists dba.trg_log;
create table dba.trg_log (trg varchar (32));

-- triggers
create trigger t1 before commit execute insert into dba.trg_log values ('t1');
create trigger x before commit execute insert into dba.trg_log values ('x');

evaluate 'Case 1: both user triggers of DBA run on the COMMIT after the rollback to the savepoint; result = dba.t1 and dba.x owned by DBA, t1 and x logged';
autocommit off;
delete from dba.trg_log;
savepoint sp;
alter trigger dba.t1 owner to u1;
alter trigger x priority 1.0;
rollback to savepoint sp;
commit;

select unique_name, owner.name from db_trigger where unique_name in ('dba.t1', 'dba.x') order by 1;
select trg from dba.trg_log order by 1;
autocommit on;

-- Case 2 drops t1 in the session where Case 1 rolled back ALTER TRIGGER ... OWNER TO; the DROP reads the
-- user trigger cache that the rollback left, so it must run right after Case 1 in the same session
evaluate 'Case 2: after DBA drops its user trigger, the COMMIT runs only the remaining one; result = dba.x owned by DBA, x logged';
autocommit off;
delete from dba.trg_log;
drop trigger t1;
commit;

select unique_name, owner.name from db_trigger where unique_name in ('dba.t1', 'dba.x') order by 1;
select trg from dba.trg_log order by 1;
autocommit on;

-- cleanup
drop trigger x;
drop table dba.trg_log;
drop user u1;
