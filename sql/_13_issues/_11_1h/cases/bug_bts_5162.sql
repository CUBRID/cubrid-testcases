create table f(a int, b int, c int);
create index idx on f(a,b,c);
insert into f values(1,1,1),(1,1,2),(1,1,3);

update f set b=-1 where b=1 order by a,b;
select * from f order by a,b,c;

drop f;



create table f(a int, b int, c int);
create index idx on f(a,b,c);
insert into f values(1,1,1),(1,1,2),(1,1,3);

update f set a=-b where b=1 order by a,b;
select * from f order by a,b,c;

drop f;


create table f(a int, b int, c int);
create index idx on f(a,b,c);
insert into f values(1,1,1),(1,1,2),(1,1,3);

update f set b=-1 where b=1 order by a,b;
select * from f order by a,b,c;

drop f;


-- no index
create table f(a int, b int, c int);

insert into f values(1,1,1),(1,1,2),(1,1,3);

update f set b=-1 where b=1 order by a,b;
select * from f order by a,b,c;

drop table f;


create table f(a int, b int, c int);
insert into f values(1,1,-1),(1,1,-1),(1,1,-1);

select * from f order by a,b,c;
update f set b=-1, c=a where b=1 order by a,b,a;

select * from f order by a,b,c;

drop table f;



create table f(a int, b int, c int);
insert into f values(1,1,-1),(1,1,-1),(1,1,-1);

select * from f order by a,b,c;
update f set b=-1, c=a where b=1 order by a,b,a;

select * from f order by a,b,c;

drop table f;

-- semantic check for values
create table f(a int, b int, c int);
insert into f values(1,1,-1),(1,1,-1),(1,1,-1);

select * from f order by a,b,c;
update f set b=-1 where b=1 order by 1;

select * from f order by a,b,c;

drop table f;