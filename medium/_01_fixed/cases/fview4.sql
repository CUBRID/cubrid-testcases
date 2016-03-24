autocommit off;
create view boo
as select * from (faculty2, faculty1);
select * from boo;
rollback;
