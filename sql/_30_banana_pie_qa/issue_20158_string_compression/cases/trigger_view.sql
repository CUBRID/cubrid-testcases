--+ holdcas on;

-- trigger
drop table if exists t1;

drop table if exists t2;

create table t1(i1 int,s1 varchar);

create table t2(s1 varchar);

create trigger tri_ti before statement insert on t2 execute insert into t1 values(1,repeat('bcd',200));

insert into t2 values('aa');

select length(s1),disk_size(s1),s1 from t1;

drop trigger tri_ti;

drop t1,t2;


-- view
drop table if exists t3;

create table t3(ID integer,name varchar(500),primary key(ID));

CREATE index idx on t3(id,name);

create reverse index idx_t3_id_name on t3(id,name);

insert into t3 values(1,repeat('abcef',100));

insert into t3 values(2,repeat('defag',100));

create view v_t3 as select * from t3;

select id,length(name),disk_size(name),name from v_t3 order by id;

alter view v_t3 add query select * from t3 where id in(1,2) group by name limit 2;  

select distinct id,length(name),disk_size(name),name from v_t3 order by id; 

drop view v_t3;  

drop t3;


drop table if exists tbl1,tbl2;

drop view if exists vw;

create table tbl1(k1 string,k2 string, k3 string, k4 string);

insert into tbl1 values('a','b','c','d');

insert into tbl1 values(repeat('a',300),repeat('b',300),repeat('c',300),repeat('d',300));

CREATE INDEX idx ON tbl1 (k1, k2, k3);

create table tbl2(k1 varchar,k2 varchar);

insert into tbl2 values('a','b');

insert into tbl2 values(repeat('a',300),repeat('b',300));

create view vw as SELECT tbl1.k1, tbl1.k2 from tbl2 inner join tbl1 ON tbl2.k1 = tbl1.k1 AND tbl2.k2 = tbl1.k2 GROUP BY tbl1.k1, tbl1.k2;
  
select /*+ recompile */* from vw where k1>'a';

drop view vw;

drop tbl1,tbl2;


--+ holdcas off;