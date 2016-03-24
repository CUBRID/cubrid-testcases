autocommit off;
call login('joe') on class db_user
create class xxx (a int)
insert into xxx values(6)
create vclass xxx_v (a1 int) as select a from xxx;
select * from xxx_v
grant all on xxx_v to public
call login('public') on class db_user
select * from xxx_v
insert into xxx_v values(12);
select * from xxx_v;
delete from xxx_v where a1=6;
select * from xxx_v;
update xxx_v set a1=9 where a1=12;
select * from xxx_v;
call login('dba', '') on class db_user;
rollback;
