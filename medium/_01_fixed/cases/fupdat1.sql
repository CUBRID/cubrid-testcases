autocommit off;
create class c (i int);
insert into c values(9) into :p;
select * from c;
update object p set i = 1;
select * from c;
rollback work;
rollback;
