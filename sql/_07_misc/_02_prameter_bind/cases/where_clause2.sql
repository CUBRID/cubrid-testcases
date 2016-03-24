--bind parameters in where clause

create class xoo ( a int, b int);
insert into xoo values(1, 1);
insert into xoo values(2, 2);
insert into xoo values(3, 3);

$int, $1;
select * from xoo where ? in ( select sum(set{a}) from xoo) ;

select * from xoo where 1 in ( select sum(set{a}) from xoo) ;
select sum(set{a}) from xoo;
select * from xoo where 1 in {1,2,3};
drop xoo;