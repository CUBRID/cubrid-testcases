set system parameters 'create_table_reuseoid=no';
--+ holdcas on;
create table t(i int auto_increment) partition by hash(i) partitions 3;
insert into t(i) values (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL), (NULL);
select * from t__p__p0 order by i;
select * from t__p__p1 order by i;
select * from t__p__p2 order by i;

drop t;
create table t(i int auto_increment(3,27)) partition by hash(i) partitions 30;
insert into t values(NULL);
select t into :x from t;
update object :x set i=30;
select t into :x from t;

delete from t;
create table temp(v varchar(10));
insert into temp values(NULL);
insert into t select * from temp;
insert into temp values('9');
insert into t select * from temp;

select * from t order by 1;
select * from t__p__p13 order by 1;
select * from t__p__p17 order by 1;
select * from t__p__p26 order by 1;

drop t;
drop temp;




 
--+ holdcas off;
set system parameters 'create_table_reuseoid=yes';
