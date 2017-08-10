create table src(i int, j int);
create table dst(i int, j int);

insert into src values(1, 100);
insert into src values(2, 200);
insert into src values(3, 300);
insert into src values(4, 400);

insert into dst values(1, 1);
insert into dst values(2, 2);
insert into dst values(3, 3);


merge into dst d using src s on (d.i=s.i and d.j=s.j) when matched then update set d.j=s.j;

merge into dst d using src s on (d.i=s.i and (d.j=s.j or d.j=s.j)) when matched then update set d.j=s.j;

merge into dst d using src s on (d.i=s.i or d.j=s.j) when matched then update set d.j=s.j;


select * from dst order by 1;

drop table src, dst;
