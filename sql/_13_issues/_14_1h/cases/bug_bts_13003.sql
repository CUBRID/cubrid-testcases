create table t(id int,col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
insert into t values(1,'a');
insert into t values(21,'a');
create index idx on t(mod(id,2));
select * from t where mod(id,2)=1 order by 1,2;
drop table t;
