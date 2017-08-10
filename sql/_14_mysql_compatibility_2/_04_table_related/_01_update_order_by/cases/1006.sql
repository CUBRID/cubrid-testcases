-- tables with partitions

create table tab1 (i1 integer ,i2 integer, i3 integer ) partition by hash(i1) partitions 2;

insert into tab1 values (4,4,0), (1,1,0) , (2,2,0), (3,3,0), (6,6,0), (5,5,0), (7,7,0);
select * from tab1 order by i2;
select * from tab1__p__p0 order by i2;
select * from tab1__p__p1 order by i2;


update tab1 set i1=i1+1, i3=i2+2 order by i3,i2 limit 2;

select * from tab1 order by i2;
select * from tab1__p__p0 order by i2;
select * from tab1__p__p1 order by i2;

update tab1 set i1=i2,i3=0;
select * from tab1 order by i2;
select * from tab1__p__p0 order by i2;
select * from tab1__p__p1 order by i2;

-- same query as before, but cached
update tab1 set i1=i1+1, i3=i2+2 order by i3,i2 limit 2;
select * from tab1 order by i2;
select * from tab1__p__p0 order by i2;
select * from tab1__p__p1 order by i2;

drop tab1; 
