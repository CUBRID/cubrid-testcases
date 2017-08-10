--test multiple rows select using two tables and a view and union, union all keyword

create class a1 ( id integer);
Create class a2 ( id integer);
Create vclass a ( id integer)
as select id from a1
   union
   select id from a2;
Insert into a1 values(1);
Insert into a1 values(2);
Insert into a1 values(3);
Insert into a1 values(4);
Insert into a2 values(4);
Insert into a2 values(5);
Insert into a2 values(6);

select * from a1 order by 1;
select * from a2 order by 1;
select * from a order by 1;
Select count(*) from a order by 1;
Select count(*) from (select * from a1 union select * from a2) as x(t) order by 1;
Select count(*) from (select * from a1 union all select * from a2) as x(t) order by 1;


drop vclass a;
drop class a1;
drop class a2;
