autocommit off;

drop table if exists rt0, rt1;
commit;

autocommit off;
create table rt0 (a int) reuse_oid;
select decode(is_reuse_oid_class , 'YES', 'OK', 'NOK') as case1 from db_class where class_name = 'rt0';
create table rt1 like rt0;
select decode(is_reuse_oid_class , 'YES', 'OK', 'NOK') as case2 from db_class where class_name = 'rt1';
rollback;

autocommit on;
create table rt0 (a int) reuse_oid;
select decode(is_reuse_oid_class , 'YES', 'OK', 'NOK') as case3 from db_class where class_name = 'rt0';
create table rt1 like rt0;
select decode(is_reuse_oid_class , 'YES', 'OK', 'NOK') as case4 from db_class where class_name = 'rt1';
drop table rt0, rt1;

autocommit off;
commit;
autocommit on;

