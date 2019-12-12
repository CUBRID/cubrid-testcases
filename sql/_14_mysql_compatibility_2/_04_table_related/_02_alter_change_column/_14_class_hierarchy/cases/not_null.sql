---- ALTER TABLE ...  CHANGE COLUMN  
-- ordering : no order defined
-- name : same of different
-- other : the table is in a hierarchy



-- altering a column in a class hierarchy with multiple inheritance , change not null

create class b1 (i integer);

create class b2 (i integer);

create class c1 under b1,b2  (ic integer)  inherit i of b1;

create class c2 under b1,b2  (ic integer)  inherit i of b2;

create class a1 under c1  (ia integer);

create class a2 under c2  (ia integer);


insert into c1 values (1,1);
insert into c2 values (1,1);

insert into c1 values (2,2);
insert into c2 values (2,2);

insert into c1 set ic=3;
insert into c2 set ic=3;

select * from c1 order by 1;
select * from c2 order by 1,2;


alter table b1 change i i integer not null;

alter table a1 change ia ia integer not null;

insert into c2 set ic=4;
insert into c1 set ic=4;

select * from c1 order by 1;
select * from c2  order by 1,2;


drop a2,a1;
drop c2,c1;
drop b2,b1;



