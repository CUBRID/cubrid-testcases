-- UPDATE .. ORDER BY on table with constraints

-- UPDATE .. ORDER BY ...  for table with foreign key constraints
create table r (i1 integer , primary key (i1));

insert into r values (1),(2),(3),(4),(5);

create table tab1 (i1 integer ,i2 integer, foreign key (i1) references r(i1) );
insert into tab1 values (4,4), (1,1) , (2,2), (3,3), (5,5);

select * from tab1 order by i2;

-- should fail : constraint invalid
update tab1 set i1=0 limit 2;

select * from tab1 order by i2;

drop table tab1;
drop table r;


-- UPDATE .. ORDER BY ...  for table with foreign key constraints
create table r (i1 integer , primary key (i1));

insert into r values (1),(2),(3),(4),(5);

create table tab1 (i1 integer ,i2 integer, foreign key (i1) references r(i1) );

insert into tab1 values (4,4), (1,1) , (2,2), (3,3), (5,5);

select * from tab1 order by i2;
-- should fail : constraint invalid
update tab1 set i1=0 order by i2 limit 2;

drop table tab1;
drop table r;


-- UPDATE .. ORDER BY .. LIMIT   for table with unique column
create table tab1 (i1 integer unique,i2 integer, i3 integer );

insert into tab1 values (4,4,0), (1,1,0) , (2,2,0), (3,3,0), (5,5,0);

-- should fail : constraint unique
update tab1 set i1=i1+1,i3=-1 limit 2;
select * from tab1 order by i2;

drop tab1;



-- UPDATE .. ORDER BY .. LIMIT   for table with unique column
create table tab1 (i1 integer unique,i2 integer, i3 integer );

insert into tab1 values (4,4,0), (1,1,0) , (2,2,0), (3,3,0), (5,5,0);

-- should fail : constraint unique
update tab1 set i1=i1+1,i3=-1 order by i2 limit 2;
select * from tab1 order by i2;

drop tab1;


-- UPDATE .. .. LIMIT   for table with unique column
create table tab1 (i1 integer unique,i2 integer, i3 integer );

insert into tab1 values (4,4,0), (1,1,0) , (2,2,0), (6,6,0), (5,5,0);

-- order is random ,  should fail : constraint unique
update tab1 set i1=i1+1,i3=-1 limit 2;
select * from tab1 order by i2;

drop tab1;


-- UPDATE .. ORDER BY .. LIMIT   for table with unique column
create table tab1 (i1 integer unique,i2 integer, i3 integer );

insert into tab1 values (4,4,0), (1,1,0) , (2,2,0), (6,6,0), (5,5,0);

-- should work : update for i2=1,2
update tab1 set i1=i1+1,i3=-1 order by i2 asc limit 2;
select * from tab1 order by i2;

drop tab1;


-- UPDATE .. ORDER BY .. LIMIT   for table with unique column
create table tab1 (i1 integer unique,i2 integer, i3 integer );

insert into tab1 values (4,4,0), (1,1,0) , (2,2,0), (6,6,0), (5,5,0);

-- should work :  update for i2=6,5
update tab1 set i1=i1+1,i3=-1 order by i2 desc limit 2;
select * from tab1 order by i2;

drop tab1;

-- UPDATE ORDER BY ... with recurrent trigger -> crash 2.
--create table tab1 (i1 integer ,i2 integer, i3 integer );

--insert into tab1 values (4,4,0), (1,1,0) , (2,2,0), (3,3,0), (5,5,0);
--select * from tab1 order by i2;

--create trigger tr1 after update on tab1
--execute update tab1 set i3=1;

-- WARN  : should fail, but it completely crashes
--update tab1 set i1=i1+1 order by i2 limit 2;    -- stack overflow

--select * from tab1 order by i2;

--drop tab1;

-- TODO : test with trigger


