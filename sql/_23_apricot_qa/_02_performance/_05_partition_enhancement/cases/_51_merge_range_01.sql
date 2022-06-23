drop table if exists tt;
drop table if exists st;
drop table if exists tt__p__p0;

create table tt(si smallint,v varchar(100)) partition by range(si)(
partition p0 values less than (-100),
partition p1 values less than (200),
partition p2 values less than (400),
partition p3 values less than maxvalue);
insert into tt select rownum*100,cast(rownum*100 as varchar) from db_class limit 5;
insert into tt select -si+10,cast(-si+10 as varchar) from tt;
insert into tt select * from tt; 

select * from db_partition where class_name='tt' order by partition_name;
select * from db_class where class_name like'tt%' order by 1;

select si,count(*) from tt__p__p3 group by si;
create table st(i int,j int);
insert into st select rownum*100,rownum+100 from db_class limit 5;
insert into st select -i,j-50 from st;

merge /*+ recompile*/ into tt using st on (st.i=cast(tt.v as int))  
when matched then update set tt.si=tt.si-1000
when not matched then insert values(i,cast(j as varchar));

select distinct si,v from tt__p__p0 order by 1;
select distinct si,v from tt__p__p1 order by 1;

alter table tt promote partition p0;
alter table tt remove partitioning;
select distinct si,v from tt;

drop tt;
drop st;
drop tt__p__p0;
