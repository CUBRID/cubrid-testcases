drop if exists t1_8725_001,t2_8725_001; 

create table t1_8725_001(a string collate utf8_bin);
create table t2_8725_001(a string collate utf8_ko_cs);

--test: fail to create. 
create TRIGGER tri_8725_001 BEFORE UPDATE ON t1_8725_001(a) 
if new.a in (select a from t2_8725_001)
execute reject;

show tables;

insert into t1_8725_001 select rownum from db_class limit 10;

select * from t1_8725_001 order by 1;

select * from t1_8725_001 order by 1 desc;


drop if exists t1_8725_001,t2_8725_001; 

create table t1_8725_001(a string collate utf8_bin) partition by hash(a) partitions 2;
create table t2_8725_001(a string collate utf8_ko_cs) partition by hash(a) partitions 2;

--test: fail to create. 
create TRIGGER tri_8725_001 BEFORE UPDATE ON t1_8725_001(a) 
if new.a in (select a from t2_8725_001)
execute reject;


insert into t1_8725_001 select rownum from db_class limit 10;

select * from t1_8725_001 order by 1;

select * from t1_8725_001 order by 1 desc;

drop  t1_8725_001,t2_8725_001; 
