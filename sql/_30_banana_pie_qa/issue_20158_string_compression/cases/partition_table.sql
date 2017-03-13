--+ holdcas on;

drop table if exists t2;

create table t2(id int auto_increment,s1 string,s2 varchar) partition by hash(s1) partitions 5;

insert into t2 values(1,'abc',null);

insert into t2 values(2,repeat('abc',100),'abc');

insert into t2 values(3,repeat('h',100),repeat('abc',100));    

insert into t2 values(4,repeat('master',100),repeat('h',100)); 

select length(s1),disk_size(s1),s1 from t2__p__p3; 
 
create index idx_t2 on t2(s1,s2);
 
select * from t2__p__p1 a,t2__p__p3 b where a.s2 > b.s2 group by a.s1 having a.s1>'a' using index a.idx_t2 order by b.id desc limit 10;

select connect_by_root s1,level,s1,s2 from t2 connect by nocycle s1 = prior s2 start with s1 > 'a' order by id ,s1,s2 limit 1; 

-- bug: http://jira.cubrid.org/browse/CBRD-20616
-- select connect_by_root s1,level,s1,s2 from t2 connect by s1 = prior s2 start with s1 > 'a' group by s2 order by s2 limit 1;

select * from t2 where s2 >'a' connect by prior s1=s2 and level > 4 order by s2 desc limit 1;


insert into t2 values(5,repeat('e',100),repeat('abc',100)); 

drop table if exists t1;

create table t1 as select * from t2;

select id,disk_size(s1),disk_size(s2),s1,s2 from t1 order by id;  

alter table t2 remove PARTITIONING;

select id,length(s1),disk_size(s1),s1 from t2 order by id;

drop t2;

drop t1;

--+ holdcas off;