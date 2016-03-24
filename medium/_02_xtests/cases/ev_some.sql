autocommit off;
create class a (o int);
create class z (i int);
insert into a values(5);
insert into z values(NULL);
select * from a where o >some (select i from z);
rollback;
