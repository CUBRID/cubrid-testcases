--+ holdcas on;
autocommit off;
create class mark1 (mark char(1));
create class mark2 (mark char(1));
insert into mark1 values ('A');
insert into mark1 values ('B');
insert into mark2 values ('D');
insert into mark2 values ('C');
create vclass mark3 (
	mark char(1),
	dummy char(0)) as
select mark, 'Z' from mark1 union all
select mark, 'Y' from mark2;
select mark from mark3 where dummy = 'Z' order by 1
delete from mark1 where mark = 'A';
select mark into :p1 from mark3 where dummy = 'Z';
select :p1 from class db_user;
rollback;

--+ holdcas off;
