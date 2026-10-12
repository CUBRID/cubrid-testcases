/**
 *  This test case verifies CBRD-27481: a non-DBA can see and alter the
 *  AUTO_INCREMENT column of a table it or its group owns, and use the serials
 *  it owns, after CBRD-25862 removed PUBLIC's privileges on _db_serial.
 *  DROP of the column is not checked: it passes the same serial owner check
 *  as MODIFY.
 */

create user cbrd27481_g1;
create user cbrd27481_u1 groups cbrd27481_g1;

-- for check 3
call login('cbrd27481_g1','') on class db_user;
create table t (a int auto_increment);

call login('cbrd27481_u1','') on class db_user;
create table t (a int auto_increment(10,5));

-- 1. SHOW CREATE TABLE by the owner: shows AUTO_INCREMENT (10, 5)
show create table t;

-- 2. MODIFY of the AUTO_INCREMENT column's type by the owner: succeeds
alter table t modify a bigint auto_increment;

-- 3. MODIFY of the AUTO_INCREMENT column's type by a member of the table's owner group: succeeds
alter table cbrd27481_g1.t modify a bigint auto_increment;

-- 4. NEXT_VALUE of the owner's serial into a session variable: returns 1
create serial s;
set @a = s.next_value;
select @a;

drop variable @a;
drop serial s;
drop table t;

call login('dba','') on class db_user;
drop table cbrd27481_g1.t;
drop user cbrd27481_u1;
drop user cbrd27481_g1;
