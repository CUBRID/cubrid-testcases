-- create reverse unique index on which create table using varchar,char,and int  and then query min and max values and using "=",">" operator

create table xoo (a int, b char(5), c varchar(10));
create reverse unique index ru_idx_a on xoo (a);
create reverse unique index ru_idx_b on xoo (b);
create reverse unique index ru_idx_c on xoo (c);

insert into xoo values(1,'a','a');
insert into xoo values(2,'b','b');
insert into xoo values(3,'c','c');
insert into xoo values(4,'d','d');
insert into xoo values(5,'e','e');
insert into xoo values(6,'f','f');
insert into xoo values(7,'g','g');
insert into xoo values(8,'h','h');
insert into xoo values(9,'i','i');
insert into xoo values(10,'j','j');

select min(a), max(a) from xoo;
select min(b), max(b) from xoo;
select min(c), max(c) from xoo;

select * from xoo where a in (select max(a) from xoo);
select * from xoo where a = (select max(a) from xoo);
select * from xoo where a = (select min(a) from xoo);
select * from xoo where a < (select max(a) from xoo) order by 1;

drop class xoo;
