autocommit off;
create table vu (a char(10), b varchar(10));
insert into vu values('111', '111');
create view v (a, b) as 
        select a, b from vu 
	union 
	select cast('0' as char(10)), cast('0' as varchar(10)) from db_root;
select a, b, char_length(a), char_length(b) from v;
rollback work;
rollback;
