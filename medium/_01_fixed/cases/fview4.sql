autocommit off;
create view boo
as select * from (joe.faculty2, joe.faculty1);
select * from boo;
rollback;
