/**
 *  This test case verifies CBRD-27527: ALTER PACKAGE statement
 *
 *  ALTER PACKAGE p COMPILE compiles the stored spec and body again, ALTER PACKAGE p COMMENT changes the
 *  comment, and ALTER PACKAGE p OWNER TO u moves the package to u with its privileges and compiles it for u.
 *  The _db_package row is kept, so the grants on the package, its comment and its created time stay, and a
 *  failed compile leaves the package as it was. An OWNER TO the current owner changes nothing, for a stored
 *  procedure as well, and an owner change clears the authorization cache of the routine or the package.
 *
 *  Coverage:
 *    Case 1:  a missing package, a package body without its spec and a system package cannot be altered
 *    Case 2:  a user with EXECUTE on the package cannot alter it, and the owner can change the comment
 *             but cannot change the owner
 *    Case 3:  COMMENT changes the comment and updated_time but compiles nothing, and an empty comment is
 *             stored as NULL
 *    Case 4:  COMPILE gives a new compile ID and keeps the source, the comment, the created time, the
 *             member routines and the grants
 *    Case 5:  a failed COMPILE leaves the package as it was
 *    Case 6:  COMPILE of a package without its body, and COMPILE by the owner gives a new compile ID
 *    Case 7:  OWNER TO a missing user, or to a user who has a package or a package body of the name, fails
 *    Case 8:  OWNER TO the current owner compiles nothing and keeps updated_time
 *    Case 9:  OWNER TO with COMMENT moves the catalog rows and the grants to the new owner, keeps the
 *             source, and the package now reads the table of the new owner
 *    Case 10: OWNER TO a user for whom the package does not compile leaves everything as it was
 *    Case 11: only a dba group member changes the owner, and dba need not be the one
 *    Case 12: ALTER PROCEDURE ... OWNER TO the current owner, alone or by change_sp_owner, compiles
 *             nothing and keeps updated_time, with COMMENT it changes updated_time, and COMPILE compiles
 *    Case 13: in one transaction, after OWNER TO, a routine running with the rights of the old owner
 *             cannot call the procedure or the package
 *    Case 14: a user who owns a package cannot be dropped until the package is moved away
 */

drop table if exists t27527_snap;

create user u27527a;
create user u27527b;
create user u27527c;
create table u27527a.t (a int, b varchar(20));
insert into u27527a.t values (1, 'u27527a.t one');
create table u27527b.t (a int, b varchar(20));
insert into u27527b.t values (1, 'u27527b.t one');
-- the cases compare the catalog after a change with this copy taken before it
create table t27527_snap (k varchar(20) primary key, cid varchar(64), ct datetime, ut datetime, sspec string, sbody string);

call login('u27527a', '') on class db_user;
create or replace package pk as
  function f(x int) return varchar comment 'f of pk';
  procedure p;
end pk comment 'pk comment';
create or replace package body pk as
  function f(x int) return varchar is
    r varchar;
  begin
    select b into r from t where a = x;
    return r;
  end;
  procedure p is begin dbms_output.put_line('pk.p: ' || f(1)); end;
end pk;
create or replace procedure run_pk as begin pk.p(); end;
grant execute on package pk to u27527b;
grant execute on package pk to u27527c;
call login('dba', '') on class db_user;
create or replace package u27527a.pq as
  procedure q(a int);
end pq comment 'pq comment';
create or replace package body u27527a.pq as
  procedure q(a int) is begin null; end;
end pq;
insert into t27527_snap (k, ct, sspec, sbody)
  select 'pk', p.created_time, c.scode_spec, c.scode_body from _db_package p, _db_package_code c
  where p.unique_name = 'u27527a.pk' and c.pkg_unique_name = p.unique_name;


evaluate 'Case 1: a missing package, a package body without its spec and dbms_output cannot be altered';
alter package u27527a.nopkg compile;
create or replace package body u27527a.bodyonly as
  procedure p is begin null; end;
end;
alter package u27527a.bodyonly compile;
alter package u27527a.bodyonly comment 'x';
alter package u27527a.bodyonly owner to u27527b;
alter package public.dbms_output compile;
alter package public.dbms_output comment 'x';
alter package public.dbms_output owner to u27527a;
select unique_name, owner.name, comment from _db_package where unique_name in ('u27527a.bodyonly', 'public.dbms_output') order by 1;


evaluate 'Case 2: u27527c with EXECUTE cannot alter pk, and the owner changes the comment but not the owner';
call login('u27527c', '') on class db_user;
alter package u27527a.pk compile;
alter package u27527a.pk comment 'by u27527c';
alter package u27527a.pk owner to u27527c;
call login('u27527a', '') on class db_user;
alter package pk owner to u27527b;
alter package pk comment 'pk comment by u27527a';
call login('dba', '') on class db_user;
select unique_name, owner.name, comment from _db_package where unique_name like '%.pk' order by 1;
alter package u27527a.pk comment 'pk comment';


evaluate 'Case 3: COMMENT changes the comment and updated_time but compiles nothing, and an empty comment is stored as NULL';
update t27527_snap set cid = (select compile_id from _db_package_code where pkg_unique_name = 'u27527a.pk'),
  ut = (select updated_time from _db_package where unique_name = 'u27527a.pk') where k = 'pk';
-- updated_time is a DATETIME: wait past it so that a change of it shows
select sleep(1);
alter package u27527a.pk comment 'pk comment 2';
select p.comment, c.compile_id = s.cid, p.created_time = s.ct, p.updated_time > s.ut, c.scode_spec = s.sspec, c.scode_body = s.sbody
  from _db_package p, _db_package_code c, t27527_snap s
  where p.unique_name = 'u27527a.pk' and c.pkg_unique_name = p.unique_name and s.k = 'pk';
alter package u27527a.pk comment '';
select comment is null from _db_package where unique_name = 'u27527a.pk';
alter package u27527a.pk comment 'pk comment';


evaluate 'Case 4: COMPILE gives a new compile ID and keeps the source, the comment, the created time, the routines and the grants';
update t27527_snap set cid = (select compile_id from _db_package_code where pkg_unique_name = 'u27527a.pk') where k = 'pk';
alter package u27527a.pk compile;
select c.compile_id <> s.cid, c.scode_spec = s.sspec, c.scode_body = s.sbody, p.comment, p.created_time = s.ct
  from _db_package p, _db_package_code c, t27527_snap s
  where p.unique_name = 'u27527a.pk' and c.pkg_unique_name = p.unique_name and s.k = 'pk';
select unique_name, owner.name, comment from _db_stored_procedure where unique_name like 'u27527a.pk.%' order by 1;
select grantor.name, grantee.name, auth_type, is_grantable from _db_auth
  where object_of in (select p from _db_package p where unique_name = 'u27527a.pk') order by 1, 2;
--+ server-message on
call u27527a.run_pk();
--+ server-message off


evaluate 'Case 5: COMPILE fails after a column of t is renamed, and the package stays as it was';
alter table u27527a.t rename column b to c;
update t27527_snap set cid = (select compile_id from _db_package_code where pkg_unique_name = 'u27527a.pk') where k = 'pk';
alter package u27527a.pk compile;
select c.compile_id = s.cid from _db_package_code c, t27527_snap s where c.pkg_unique_name = 'u27527a.pk' and s.k = 'pk';
select unique_name from _db_stored_procedure where unique_name like 'u27527a.pk.%' order by 1;
alter table u27527a.t rename column c to b;
alter package u27527a.pk compile;
--+ server-message on
call u27527a.run_pk();
--+ server-message off


evaluate 'Case 6: COMPILE of a package without its body, and COMPILE by the owner gives a new compile ID';
create or replace package u27527a.nobody as
  procedure p;
end;
alter package u27527a.nobody compile;
select pkg_unique_name, scode_body is null from _db_package_code where pkg_unique_name = 'u27527a.nobody';
select unique_name from _db_stored_procedure where unique_name like 'u27527a.nobody.%' order by 1;
update t27527_snap set cid = (select compile_id from _db_package_code where pkg_unique_name = 'u27527a.pk') where k = 'pk';
call login('u27527a', '') on class db_user;
alter package pk compile;
call login('dba', '') on class db_user;
select c.compile_id <> s.cid from _db_package_code c, t27527_snap s where c.pkg_unique_name = 'u27527a.pk' and s.k = 'pk';


evaluate 'Case 7: OWNER TO a missing user, or to a user with a package or a package body of the name, fails';
alter package u27527a.pk owner to u27527_none;
create or replace package u27527b.pk as
  procedure p;
end;
alter package u27527a.pk owner to u27527b;
drop package u27527b.pk;
create or replace package body u27527b.pk as
  procedure p is begin null; end;
end;
alter package u27527a.pk owner to u27527b;
drop package body u27527b.pk;
select unique_name, owner.name from _db_package where pkg_name = 'pk' order by 1;


evaluate 'Case 8: OWNER TO the current owner compiles nothing and keeps updated_time';
update t27527_snap set cid = (select compile_id from _db_package_code where pkg_unique_name = 'u27527a.pk'),
  ut = (select updated_time from _db_package where unique_name = 'u27527a.pk') where k = 'pk';
select sleep(1);
alter package u27527a.pk owner to u27527a;
select c.compile_id = s.cid, p.updated_time = s.ut from _db_package p, _db_package_code c, t27527_snap s
  where p.unique_name = 'u27527a.pk' and c.pkg_unique_name = p.unique_name and s.k = 'pk';


evaluate 'Case 9: OWNER TO u27527b with COMMENT moves the rows and the grants, keeps the source, and reads u27527b.t; result = the grant by u27527a to u27527b is revoked, and the grant to u27527c is now by u27527b';
alter package u27527a.pk owner to u27527b comment 'pk of u27527b';
select p.unique_name, p.pkg_name, p.owner.name, p.comment, p.created_time = s.ct
  from _db_package p, t27527_snap s where p.pkg_name = 'pk' and s.k = 'pk' order by 1;
select pkg_unique_name, name, owner.name, pkg_of.unique_name from _db_package_code where pkg_unique_name like '%.pk' order by 1;
select unique_name, owner.name, target_class, comment from _db_stored_procedure where unique_name like '%.pk.%' order by 1;
select c.scode_spec = s.sspec, c.scode_body = s.sbody from _db_package_code c, t27527_snap s
  where c.pkg_unique_name = 'u27527b.pk' and s.k = 'pk';
select grantor.name, grantee.name, auth_type, is_grantable from _db_auth
  where object_of in (select p from _db_package p where unique_name = 'u27527b.pk') order by 1, 2;
create or replace procedure u27527b.run_pk as begin pk.p(); end;
call login('u27527c', '') on class db_user;
create or replace procedure run_pk as begin u27527b.pk.p(); end;
call login('dba', '') on class db_user;
--+ server-message on
call u27527b.run_pk();
call u27527c.run_pk();
--+ server-message off


evaluate 'Case 10: OWNER TO u27527c fails, as u27527c has no table t, and everything stays as it was';
alter package u27527b.pk owner to u27527c;
select unique_name, owner.name, comment from _db_package where pkg_name = 'pk' order by 1;
select unique_name, owner.name from _db_stored_procedure where unique_name like '%.pk.%' order by 1;
select grantor.name, grantee.name, auth_type, is_grantable from _db_auth
  where object_of in (select p from _db_package p where unique_name = 'u27527b.pk') order by 1, 2;
alter package u27527b.pk owner to u27527a comment 'pk comment';
select unique_name, owner.name, comment from _db_package where pkg_name = 'pk' order by 1;
--+ server-message on
call u27527a.run_pk();
--+ server-message off


evaluate 'Case 11: the owner u27527a cannot change the owner of pq, and u27527c of the dba group can';
call login('u27527a', '') on class db_user;
alter package pq owner to u27527b;
call login('dba', '') on class db_user;
alter user dba add members u27527c;
call login('u27527c', '') on class db_user;
alter package u27527a.pq owner to u27527b;
call login('dba', '') on class db_user;
select unique_name, owner.name, comment from _db_package where pkg_name = 'pq' order by 1;


evaluate 'Case 12: ALTER PROCEDURE OWNER TO the current owner compiles nothing, and keeps updated_time without COMMENT';
create or replace procedure u27527a.sp1 as begin null; end;
insert into t27527_snap (k, cid, ut) select 'sp1', code.compile_id, updated_time from _db_stored_procedure where unique_name = 'u27527a.sp1';
-- updated_time is a DATETIME: wait past it so that a change of it shows
select sleep(1);
alter procedure u27527a.sp1 owner to u27527a;
call change_sp_owner('u27527a.sp1', 'u27527a') on class db_root;
select p.code.compile_id = s.cid, p.updated_time = s.ut from _db_stored_procedure p, t27527_snap s
  where p.unique_name = 'u27527a.sp1' and s.k = 'sp1';
alter procedure u27527a.sp1 owner to u27527a comment 'sp1 comment';
select p.comment, p.code.compile_id = s.cid, p.updated_time > s.ut from _db_stored_procedure p, t27527_snap s
  where p.unique_name = 'u27527a.sp1' and s.k = 'sp1';
replace into t27527_snap (k, cid, ut) select 'sp1', code.compile_id, updated_time from _db_stored_procedure where unique_name = 'u27527a.sp1';
select sleep(1);
alter procedure u27527a.sp1 compile;
select p.code.compile_id <> s.cid, p.updated_time > s.ut from _db_stored_procedure p, t27527_snap s
  where p.unique_name = 'u27527a.sp1' and s.k = 'sp1';
drop procedure u27527a.sp1;


evaluate 'Case 13: in one transaction, after OWNER TO, a routine of the old owner cannot call the procedure or the package';
-- u27527a.r calls u27527b.sp2 and u27527a.rp calls u27527b.pk2.p, granted to u27527a when they are created.
-- After both are dropped, u27527a creates its own sp2 and pk2, which u27527a.r0 and u27527a.rp0 call.
create or replace procedure u27527b.sp2 as begin null; end;
grant execute on procedure u27527b.sp2 to u27527a;
create or replace package u27527b.pk2 as procedure p; end;
create or replace package body u27527b.pk2 as procedure p is begin null; end; end;
grant execute on package u27527b.pk2 to u27527a;
create or replace procedure u27527a.r as begin u27527b.sp2(); end;
create or replace procedure u27527a.rp as begin u27527b.pk2.p(); end;
drop procedure u27527b.sp2;
drop package u27527b.pk2;
create or replace procedure u27527a.sp2 as begin null; end;
create or replace package u27527a.pk2 as procedure p; end;
create or replace package body u27527a.pk2 as procedure p is begin null; end; end;
create or replace procedure u27527a.r0 as begin sp2(); pk2.p(); end;
-- no server message control line until the rollback, as CTP commits at such a line
autocommit off;
-- r0 calls sp2 and pk2.p with the rights of u27527a, then both move to u27527b in the same transaction
call u27527a.r0();
alter procedure u27527a.sp2 owner to u27527b;
alter package u27527a.pk2 owner to u27527b;
select unique_name, owner.name from _db_stored_procedure where sp_name = 'sp2' order by 1;
select unique_name, owner.name from _db_package where pkg_name = 'pk2' order by 1;
call u27527a.r();
call u27527a.rp();
rollback;
autocommit on;
drop procedure u27527a.r;
drop procedure u27527a.rp;
drop procedure u27527a.r0;
drop procedure u27527a.sp2;
drop package u27527a.pk2;


evaluate 'Case 14: u27527b who owns pq cannot be dropped until pq is moved away';
drop procedure u27527b.run_pk;
drop table u27527b.t;
drop user u27527b;
alter package u27527b.pq owner to u27527a;
drop user u27527b;
select unique_name, owner.name from _db_package where unique_name like 'u27527%' order by 1;


drop package u27527a.pk;
drop package u27527a.pq;
drop package u27527a.nobody;
drop package body u27527a.bodyonly;
drop procedure u27527a.run_pk;
drop procedure u27527c.run_pk;
drop table u27527a.t;
drop table t27527_snap;
drop user u27527a;
drop user u27527c;
