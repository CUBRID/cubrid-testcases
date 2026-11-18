/**
 *  This test case verifies CBRD-27608: SCHEMA() computed on the client returns the
 *  database name instead of the name of the current user.
 *
 *  CBRD-25875 made SCHEMA() return the name of the current user, but only where the
 *  server computes it. The client evaluator still returned the database name, so the
 *  same SCHEMA() gave another value in a SET of a session variable, in an INSERT that
 *  the client runs (the INSERT_EXECUTION_MODE(0) hint, a table with a trigger) and in a
 *  DEFAULT SCHEMA() that is folded when the table is created. The fix makes the client
 *  evaluator return the name of the current user as well.
 *
 *  Each client path is printed next to the server path of the same statement, first as
 *  dba and then as the user u_27608. DATABASE() must stay the database name on both
 *  paths, which is basic under CTP. The login of the whole file needs one CAS, so the
 *  file keeps it with the holdcas control lines.
 *
 *  Coverage:
 *    Case 1:  as dba, SCHEMA() and current_schema of a SELECT are DBA
 *    Case 2:  as dba, a session variable set from SCHEMA() or current_schema is DBA
 *    Case 3:  as dba, the INSERT that the client runs stores DBA like the INSERT of the server
 *    Case 4:  as dba, an INSERT into a table with a trigger stores DBA
 *    Case 5:  as dba, DEFAULT SCHEMA() of a new table is DBA
 *    Case 6:  as u_27608, SCHEMA() and current_schema of a SELECT are U_27608
 *    Case 7:  as u_27608, a session variable set from SCHEMA() or current_schema is U_27608
 *    Case 8:  as u_27608, a session variable set from an expression over SCHEMA() uses U_27608
 *    Case 9:  as u_27608, the INSERT that the client runs stores U_27608 like the INSERT of the server
 *    Case 10: as u_27608, an INSERT into a table with a trigger stores U_27608
 *    Case 11: as u_27608, INSERT SELECT and UPDATE store U_27608
 *    Case 12: as u_27608, DEFAULT SCHEMA() of a new table is U_27608
 *    Case 13: as u_27608, DEFAULT SCHEMA() of the table that dba created stays DBA
 *    Case 14: as u_27608, DATABASE() is the database name on the client and the server paths
 */

--+ holdcas on;

drop table if exists t_schema, t_schema_trg, t_schema_def;

create user u_27608;
create table t_schema (id int, c varchar(40));
create table t_schema_trg (id int, c varchar(40));
create trigger trg_27608 before insert on t_schema_trg if new.id < 0 execute reject;
grant all privileges on t_schema to u_27608;
grant all privileges on t_schema_trg to u_27608;


evaluate 'Case 1: as dba, SCHEMA() and current_schema of a SELECT are DBA';
select schema(), current_schema (), database() from db_root;


evaluate 'Case 2: as dba, a session variable set from SCHEMA() or current_schema is DBA';
set @s_27608 = schema();
set @cs_27608 = current_schema ();
set @d_27608 = database();
select @s_27608, @cs_27608, @d_27608 from db_root;


-- the rows with an odd id are inserted by the server, the rows with an even id by the client
evaluate 'Case 3: as dba, the INSERT that the client runs stores DBA like the INSERT of the server';
insert into t_schema values (1, schema());
insert /*+ insert_execution_mode(0) */ into t_schema values (2, schema());
insert into t_schema values (3, current_schema ());
insert /*+ insert_execution_mode(0) */ into t_schema values (4, current_schema ());
select id, c from t_schema order by id;
delete from t_schema;


evaluate 'Case 4: as dba, an INSERT into a table with a trigger stores DBA';
insert into t_schema_trg values (1, schema());
insert into t_schema_trg values (2, current_schema ());
insert into t_schema_trg values (3, database());
select id, c from t_schema_trg order by id;
delete from t_schema_trg;


evaluate 'Case 5: as dba, DEFAULT SCHEMA() of a new table is DBA';
create table t_schema_def (id int, c varchar(40) default schema(), e varchar(40) default database());
grant all privileges on t_schema_def to u_27608;
insert into t_schema_def (id) values (1);
select id, c, e from t_schema_def order by id;
select attr_name, default_value from db_attribute where class_name = 't_schema_def' and owner_name = 'DBA' order by attr_name;


call login ('u_27608', '') on class db_user;

evaluate 'Case 6: as u_27608, SCHEMA() and current_schema of a SELECT are U_27608';
select schema(), current_schema (), current_user from db_root;
select count(*) from db_root where schema() = current_user;


evaluate 'Case 7: as u_27608, a session variable set from SCHEMA() or current_schema is U_27608';
set @s_27608 = schema();
set @cs_27608 = current_schema ();
select @s_27608, @cs_27608 from db_root;
select collation (@s_27608), collation (schema()) from db_root;


evaluate 'Case 8: as u_27608, a session variable set from an expression over SCHEMA() uses U_27608';
set @c_27608 = concat (lower (schema()), '.', database());
select @c_27608, length (@s_27608) from db_root;


evaluate 'Case 9: as u_27608, the INSERT that the client runs stores U_27608 like the INSERT of the server';
insert into dba.t_schema values (1, schema());
insert /*+ insert_execution_mode(0) */ into dba.t_schema values (2, schema());
insert into dba.t_schema values (3, current_schema ());
insert /*+ insert_execution_mode(0) */ into dba.t_schema values (4, current_schema ());
select id, c from dba.t_schema order by id;
delete from dba.t_schema;


evaluate 'Case 10: as u_27608, an INSERT into a table with a trigger stores U_27608';
insert into dba.t_schema_trg values (1, schema());
insert into dba.t_schema_trg values (2, current_schema ());
select id, c from dba.t_schema_trg order by id;
delete from dba.t_schema_trg;


evaluate 'Case 11: as u_27608, INSERT SELECT and UPDATE store U_27608';
insert into dba.t_schema select 1, schema() from db_root;
insert into dba.t_schema values (2, null);
update dba.t_schema set c = schema() where id = 2;
insert into dba.t_schema_trg values (3, null);
update dba.t_schema_trg set c = schema() where id = 3;
select id, c from dba.t_schema order by id;
select id, c from dba.t_schema_trg order by id;
delete from dba.t_schema;
delete from dba.t_schema_trg;


evaluate 'Case 12: as u_27608, DEFAULT SCHEMA() of a new table is U_27608';
create table t_schema_def (id int, c varchar(40) default schema(), e varchar(40) default database());
insert into t_schema_def (id) values (1);
insert into t_schema_def values (2, default, default);
select id, c, e from t_schema_def order by id;
select attr_name, default_value from db_attribute where class_name = 't_schema_def' and owner_name = 'U_27608' order by attr_name;
drop table t_schema_def;


-- dba created dba.t_schema_def in Case 5 and inserted its row 1
evaluate 'Case 13: as u_27608, DEFAULT SCHEMA() of the table that dba created stays DBA';
insert into dba.t_schema_def (id) values (2);
insert /*+ insert_execution_mode(0) */ into dba.t_schema_def (id) values (3);
select id, c, e from dba.t_schema_def order by id;


evaluate 'Case 14: as u_27608, DATABASE() is the database name on the client and the server paths';
set @d_27608 = database();
insert into dba.t_schema values (1, database());
insert /*+ insert_execution_mode(0) */ into dba.t_schema values (2, database());
insert into dba.t_schema_trg values (3, database());
select @d_27608, database() from db_root;
select id, c from dba.t_schema order by id;
select id, c from dba.t_schema_trg order by id;


call login ('dba', '') on class db_user;

drop variable @s_27608, @cs_27608, @d_27608, @c_27608;
drop trigger trg_27608;
drop table t_schema, t_schema_trg, t_schema_def;
drop user u_27608;

--+ holdcas off;
