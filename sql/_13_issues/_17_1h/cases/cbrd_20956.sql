--+ holdcas on;

drop table if exists t;

create table t (i1 varchar, i2 varchar);

create index i_t_123 on t(i1, i2);

insert into t values ('a', repeat('a',300));
insert into t values ('b', repeat('a',300));
insert into t values ('c', repeat('a',300));

select * from t where i1 in('a','b','c') order by i2 limit 2;

select * from t where i1='a' and i2 like 'a%' order by i1,i2 limit 2; 
 


drop table if exists t1;

create table t1 (i2 varchar, i3 varchar);

create index i_t1_123 on t1(i2, i3);

insert into t1 values ('a', repeat('a',300));
insert into t1 values ('b', repeat('a',300));
insert into t1 values ('c', repeat('a',300));

select * from t,t1 where t1.i2 in('a','b','c') and t.i1=t1.i2 order by t1.i3 limit 2;  

drop t;

drop t1;



drop table if exists t2;

create table t2 (i1 varchar, i2 varchar, i3 int, i4 nchar varying, primary key(i1,i2,i3,i4));

insert into t2 values ('a', repeat('a',300),1,n'a');
insert into t2 values ('b', repeat('b',300),2,n'b');
insert into t2 values ('c', repeat('c',300),3,n'c');
insert into t2 values ('d', repeat('d',300),4,n'd');
insert into t2 values (repeat('a',300), repeat('a',300),5,repeat(n'a',300));
insert into t2 values (repeat('b',300), repeat('a',300),6,repeat(n'b',300));
insert into t2 values (repeat('c',300), repeat('a',300),7,repeat(n'c',300));
insert into t2 values (repeat('d',300), repeat('a',300),8,repeat(n'd',300));

select * from t2 where i1 in('a','b','c') order by i2 limit 2;

select * from t2 where i1='a' and i2 like 'a%' and i3 in(1,2,3) and i4 like n'a%' order by i1,i2,i3,i4 limit 3; 


drop t2;


--+ holdcas off;