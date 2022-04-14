--+ holdcas on;
--use index granted from DBA

call login('dba','') on class db_user;
create user user1;
create class xoo ( a int, b int);
create index idx1 on xoo(a,b);
create reverse index idx2 on xoo(b,a);
insert into xoo values(1,1);
insert into xoo values(2,2);
create serial ser1;
grant select, insert on xoo to user1;
create trigger tri1
after insert on xoo
execute update object obj set a = a+100;

call login('user1','') on class db_user;

select * from dba.xoo;
select dba.ser1.next_value from db_root;
insert into dba.xoo values(10, 10);
select * from dba.xoo where a > 0 using index idx1(+);
select * from dba.xoo where b > 0 using index idx2(+);
select /*+ USE_IDX */ x.a from dba.xoo x, dba.xoo y where x.a = y.a order by 1 desc;
select /*+ USE_IDX */ x.a from dba.xoo x, dba.xoo y where x.a = y.a order by 1 asc;

call login('dba','') on class db_user;
drop user user1;
drop serial ser1;
drop trigger tri1;
drop xoo;
commit;
--+ holdcas off;
