/**
 *  This test case verifies CBRD-26470 (PR #7819): DROP PACKAGE [BODY] IF EXISTS.
 *
 *  Background:
 *    - Symptom: when the package did not exist, DROP PACKAGE IF EXISTS still failed with
 *      "Package "dba.nopkg" does not exist.". The grammar accepted if_exists, but
 *      jsp_drop_package () did not look at it.
 *    - Fix: with IF EXISTS, missing packages (bodies) are skipped and only existing ones are
 *      dropped.
 *  After each case, the packages and whether each has a body are shown from _db_package (spec) and
 *  _db_package_code.scode_body (body), as name:Y (body) or name:N (spec only).
 *
 *  Coverage:
 *    Case 1:  the initial state of the packages before the drops
 *    Case 2:  DROP PACKAGE IF EXISTS nopkg68                         -> success
 *    Case 3:  DROP PACKAGE BODY IF EXISTS nopkg68                    -> success
 *    Case 4:  DROP PACKAGE BODY IF EXISTS on a package without a body -> success, spec kept
 *    Case 5:  DROP PACKAGE BODY IF EXISTS on a package with a body   -> only the body dropped
 *    Case 6:  DROP PACKAGE IF EXISTS pk68_1, nopkg68, pk68_2         -> pk68_1, pk68_2 dropped
 *    Case 7:  DROP PACKAGE BODY IF EXISTS pk68_3, nopkg68 (pk68_3 has a body) -> body of pk68_3 dropped
 *    Case 8:  DROP PACKAGE IF EXISTS db_user (system class name)     -> success
 *    Case 9:  DROP PACKAGE nopkg68 without IF EXISTS (regression)    -> does not exist
 *    Case 10: DROP PACKAGE BODY nopkg68 without IF EXISTS (regression) -> does not exist
 *    Case 11: DROP PACKAGE IF EXISTS pk68_4, pk68_4 (regression)      -> duplicate name error, pk68_4 kept
 */

--+ server-message on

drop view if exists v68;
drop package if exists ps68, pb68, pk68_1, pk68_2, pk68_3, pk68_4;

create package ps68 as function f return int; end;
create package pb68 as function f return int; end;
create package body pb68 as function f return int as begin return 1; end; end;
create package pk68_1 as function f return int; end;
create package pk68_2 as function f return int; end;
create package pk68_3 as function f return int; end;
create package body pk68_3 as function f return int as begin return 3; end; end;
create package pk68_4 as function f return int; end;

create or replace view v68 as
select p.pkg_name || ':' || if (c.scode_body is null, 'N', 'Y') as s
from _db_package p left join _db_package_code c on c.pkg_unique_name = p.unique_name
where p.owner.name = 'DBA' and p.pkg_name in ('ps68', 'pb68', 'pk68_1', 'pk68_2', 'pk68_3', 'pk68_4');

evaluate 'Case 1: initial state; result = pb68:Y pk68_1:N pk68_2:N pk68_3:Y pk68_4:N ps68:N';
select s from v68 order by 1;


evaluate 'Case 2: drop package if exists nopkg68 -> success, no change';
drop package if exists nopkg68;
select s from v68 order by 1;

evaluate 'Case 3: drop package body if exists nopkg68 -> success, no change';
drop package body if exists nopkg68;
select s from v68 order by 1;

evaluate 'Case 4: drop package body if exists ps68 (no body) -> success, no change';
drop package body if exists ps68;
select s from v68 order by 1;

evaluate 'Case 5: drop package body if exists pb68 -> pb68:N';
drop package body if exists pb68;
select s from v68 order by 1;

evaluate 'Case 6: drop package if exists pk68_1, nopkg68, pk68_2 -> pb68:N pk68_3:Y pk68_4:N ps68:N';
drop package if exists pk68_1, nopkg68, pk68_2;
select s from v68 order by 1;

evaluate 'Case 7: drop package body if exists pk68_3, nopkg68 -> pb68:N pk68_3:N pk68_4:N ps68:N';
drop package body if exists pk68_3, nopkg68;
select s from v68 order by 1;

evaluate 'Case 8: drop package if exists db_user -> success, no change';
drop package if exists db_user;
select s from v68 order by 1;

evaluate 'Case 9: drop package nopkg68 -> Package "dba.nopkg68" does not exist.';
drop package nopkg68;
select s from v68 order by 1;

evaluate 'Case 10: drop package body nopkg68 -> Package Body "dba.nopkg68" does not exist.';
drop package body nopkg68;
select s from v68 order by 1;

evaluate 'Case 11: drop package if exists pk68_4, pk68_4 -> duplicate name error, no change';
drop package if exists pk68_4, pk68_4;
select s from v68 order by 1;


drop view v68;
drop package ps68, pb68, pk68_3, pk68_4;

--+ server-message off
