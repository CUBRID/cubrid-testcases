create table t(i smallint) partition by hash(i+3) partitions 5;
insert into t select rownum from db_class limit 40;
create table temp(i int); 
insert into temp values(1),(2),(3),(4),(5),(6),(50); 

set autocommit off;
delete t,temp from t inner join temp on t.i=temp.i where t.i+3 in (5,13);
select * from t where i in (2);
select * from temp where i in (2);
rollback;
delete t,temp from t left join temp on t.i=temp.i where t.i+3 in (5,13);
select * from t where i=2 or i=10;
select * from temp where i=2;
rollback;
delete t,temp from t right join temp on t.i=temp.i where t.i+3 in (5,NULL);
select * from t where i=2;
select * from temp where i=2;

set autocommit on;
drop t;
drop temp;

create table t(i smallint) partition by hash(i-3) partitions 5;
insert into t select rownum from db_class limit 40;
create table temp(i int); 
insert into temp values(1),(2),(3),(4),(5),(6),(50); 
delete t,temp from t inner join temp on t.i=temp.i where t.i-3 in (5,-1);
select * from t where i in (2);
select * from temp where i in (2);
drop t;
drop temp;

create table t(i smallint) partition by hash(i*3) partitions 5;
insert into t select rownum from db_class limit 40;
create table temp(i int); 
insert into temp values(1),(2),(3),(4),(5),(6),(50); 
delete t,temp from t left join temp on t.i=temp.i where t.i*3 in (6,13);
select * from t where i in (2);
select * from temp where i in (2);
drop t;
drop temp;

create table t(i smallint) partition by hash(i/3+4) partitions 5;
insert into t select rownum from db_class limit 40;
create table temp(i int); 
insert into temp values(1),(2),(3),(4),(5),(6),(50);
delete t,temp from t right join temp on t.i=temp.i where t.i/3+4 in (4,20);
select * from t where i in (1,2);
select * from temp where i in (1,2);
drop t;
drop temp;
