autocommit off;
create class foo (d set of date);
create class bar (d date);
insert into foo values ({'4/7/56'});
insert into bar values ('4/7/56');

select d from foo where (select d from bar) in d;
select ssn from joe.faculty2 
where ssn <> (select distinct ssn from joe.faculty1);
drop foo, bar;
rollback;
