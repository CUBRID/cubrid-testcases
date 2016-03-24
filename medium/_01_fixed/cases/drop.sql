autocommit off;
create class xx (a int);
insert into xx values (42);
drop xx;
create class xx (b int);
insert into xx values (13);
select * from xx;
drop xx;
rollback;
