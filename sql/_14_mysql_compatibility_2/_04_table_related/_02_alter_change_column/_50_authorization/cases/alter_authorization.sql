--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : 
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed
-- check authorization of ALTER




-- no ALTER grants
create user user1 password 'a';

create table t1(sh1 short);
insert into t1 values(1),(-32768),(32767);

show columns in t1;
select * from t1 order by 1;

call login('user1','a') on class db_user;


-- should fail
alter table t1 change sh1 i1 int;

call login('dba','') on class db_user;

drop table t1;

drop user user1;



-- with ALTER grants
-- UPDATE GRANT is not required for performing a row upgrade
create user user1 password 'a';

create table t1(sh1 short);
insert into t1 values(1),(-32768),(32767);

show columns in t1;
select * from t1 order by 1;

grant alter to user1 on t1;

call login('user1','a') on class db_user;


alter table t1 change sh1 i1 int;

call login('dba','') on class db_user;

show columns in t1;
select * from t1 order by 1;

drop table t1;

drop user user1;


--+ holdcas off;
