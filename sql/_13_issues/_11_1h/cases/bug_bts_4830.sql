create table x (a int,b int);
insert into x values (1,1);
insert into x values (2,2);

--result is good
update x set a=1 where b < 10  order by b asc limit 1;
--fail: ERROR: Invalid data type referenced.
update x set a=1 where b < 10  order by b asc limit 1;


drop table x;

