-- UPDATE ORDER BY ... with LIMIT   with constants   + test of AUTO PARAMETRIZATION of constants for XASL cached queries
-- TODO : for this test, XASL cache should be enabled

-- 1 - one value to SET 
create table tab1 (i1 integer ,i2 integer, i3 integer );

insert into tab1 values (4,4,0), (1,1,0) , (2,2,0), (3,3,0), (5,5,0);
select * from tab1 order by i2;

update tab1 set i1=0 order by i3,i2 limit 2;

select * from tab1 order by i2;

update tab1 set i1=i2;
select * from tab1 order by i2;

-- same query as before, but cached
update tab1 set i1=0 order by i3,i2 limit 2;
select * from tab1 order by i2;

drop tab1;



-- 2 - two values to SET
create table tab1 (i1 integer ,i2 integer, i3 integer );

insert into tab1 values (4,4,0), (1,1,0) , (2,2,0), (3,3,0), (5,5,0);
select * from tab1 order by i2;

update tab1 set i1=i1+1, i3=-i2+2 order by i3,i2 limit 2;

select * from tab1 order by i2;

update tab1 set i1=i2,i3=0;
select * from tab1 order by i2;

-- same query as before, but cached
update tab1 set i1=i1+1, i3=-i2+2 order by i3,i2 limit 2;
select * from tab1 order by i2;

drop tab1;


-- 3 - one row to update
create table tab1 (i1 integer ,i2 integer, i3 integer );

insert into tab1 values (4,4,0), (1,1,0) , (2,2,0), (3,3,0), (5,5,0);
select * from tab1 order by i2;

update tab1 set i1=0,i3=-1 order by i1 limit 1;

select * from tab1 order by i2;

update tab1 set i1=i2,i3=0;
select * from tab1 order by i2;

-- same query as before, but cached
update tab1 set i1=0,i3=-1 order by i1 limit 1;
select * from tab1 order by i2;

drop tab1;


-- 4 -  one row in the table
create table tab1 (i1 integer ,i2 integer, i3 integer );

insert into tab1 values (4,4,0);
select * from tab1 order by i2;

update tab1 set i1=0,i3=-1 order by i2;

select * from tab1 order by i2;

update tab1 set i1=i2,i3=0;
select * from tab1 order by i2;

-- same query as before, but cached
update tab1 set i1=0,i3=-1 order by i2;
select * from tab1 order by i2;

drop tab1;

-- 5 -  one row in the table + limit
create table tab1 (i1 integer ,i2 integer, i3 integer );

insert into tab1 values (4,4,0);
select * from tab1 order by i2;

update tab1 set i1=0,i3=-1 order by i2 limit 4;

select * from tab1 order by i2;

update tab1 set i1=i2,i3=0;
select * from tab1 order by i2;

-- same query as before, but cached
update tab1 set i1=0,i3=-1 order by i2 limit 4;
select * from tab1 order by i2;

drop tab1;


