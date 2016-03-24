autocommit off;
create class x (xint int, xstr string);
create class y (yint int, ystr string);
create vclass union_xy (vunion_int int, vunion_str string)
	as (select xint, xstr from x where xint > 1 
            union
            select yint, ystr from y where yint < 40);
create vclass diff_xy (vdiff_int int, vdiff_str string)
	as (select xint, xstr from x where xint > 1
            difference
            select yint, ystr from y where yint < 40);
create vclass inter_xy (vinter_int int, vinter_str string)
	as (select xint, xstr from x where xint > 1 
            intersection
            select yint, ystr from y where yint < 40);
insert into x values (1, 'string 1');
insert into x values (2, 'string 2');
insert into x values (3, 'string 3');
insert into x values (4, 'string 4');
insert into x values (5, 'string 5');
insert into x values (2, 'string 2');
insert into x values (3, 'string 3');
insert into x values (4, 'string 4');
insert into x values (5, 'string 5');
insert into y values (10, 'string 10');
insert into y values (2, 'string 20');
insert into y values (3, 'string 3');
insert into y values (40, 'string 40');
insert into y values (5, 'string 5');
select * from union_xy;
select * from diff_xy;
select * from inter_xy;
rollback;
