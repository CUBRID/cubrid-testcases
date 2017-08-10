-- join
drop table if exists x;
drop table if exists y;
drop table if exists z;
create table x(a int, b int);
create table y(a int, b int);
create table z(a int, b int);

create index a_x_index on x(a desc);
create index a_y_index on y(a desc);
create index a_z_index on z(a desc);
create index b_x_index on x(b desc);
create index b_y_index on y(b desc);
create index b_z_index on z(b desc);


insert into x values(1,1);
insert into x values(2,1);
insert into x values(3,1);
insert into x values(4,1);
insert into x values(5,1);
insert into x values(6,1);
insert into x values(7,1);
insert into x values(8,1);
insert into x values(9,1);
insert into x values(10,1);
insert into x values(11,2);
insert into x values(12,2);
insert into x values(13,2);
insert into x values(14,2);
insert into x values(15,2);
insert into x values(16,2);
insert into x values(17,2);
insert into x values(18,2);

insert into y values(1,1);
insert into y values(2,1);
insert into y values(3,1);
insert into y values(4,1);
insert into y values(5,1);
insert into y values(6,1);
insert into y values(7,1);
insert into y values(8,1);
insert into y values(9,1);
insert into y values(10,1);
insert into y values(11,2);
insert into y values(12,2);
insert into y values(13,2);
insert into y values(14,2);
insert into y values(15,2);
insert into y values(16,2);
insert into y values(17,2);
insert into y values(18,2);

insert into z values(1,1);
insert into z values(2,1);
insert into z values(3,1);
insert into z values(4,1);
insert into z values(5,1);
insert into z values(6,1);
insert into z values(7,1);
insert into z values(8,1);
insert into z values(9,1);
insert into z values(10,1);
insert into z values(11,2);
insert into z values(12,2);
insert into z values(13,2);
insert into z values(14,2);
insert into z values(15,2);
insert into z values(16,2);
insert into z values(17,2);
insert into z values(18,2);

select a from x order by a limit 0, 10;
select median(a) from x order by a limit 0, 10;
select avg(a) from x order by a limit 0, 10;

-- cross join
select median(x.a), median(y.b) from x cross join y;
select median(x.a), median(y.b) from x cross join y limit 0, 100;
select median(x.a), median(y.a), median(y.b) from x cross join y group by x.a order by y.b limit 1, 100;
select median(x.a), median(y.a), median(y.b) from x cross join y order by y.b limit 0, 100;

-- inner join
select median(x.a), median(y.b) from x ,y where x.a = y.a  group by x.a order by y.a limit 1, 10;
select median(x.a), median(y.b) from x inner join y on x.a = y.a  group by x.a order by y.a limit 1, 10;

-- left outer join
select median(x.a), median(y.a), median(y.b) from x left outer join y on x.a = y.a  group by x.a order by y.a limit 1, 10;

-- right outer join
select median(x.a), median(y.a), median(y.b) from x right outer join y on x.a = y.a  group by x.a order by y.a limit 1, 10;

drop table if exists x;
drop table if exists y;
drop table if exists z;
