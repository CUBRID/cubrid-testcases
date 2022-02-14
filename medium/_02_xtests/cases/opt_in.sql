autocommit off;
create table y(a int);
insert into y values(1);
insert into y values(2);
insert into y values(3);
create index i_y_a on y(a);
create view yv as 
select * from y
where a in {2, 2};
select * from yv;
select * from y
where a in {2, 2};
rollback;
