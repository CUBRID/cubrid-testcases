drop table if exists t1;

create table t1(a int unique default 1, b smallint default 99,c timestamp on update current_timestamp);

insert into t1(a, b) values(1, 10);

insert into t1(a, b) values(1, 3) on duplicate key update b=(select 1 from t1);

--select * from t1 order by 1;
select a,b,if(current_timestamp-c>=0 and current_timestamp -c<10,'ok','nok') from t1;

replace into t1(a,b) values(select 1 from t1, select unique 2 from t1 a, t1 b);

select * from t1 order by 1;

insert into t1 set a=(select 1 from t1), b=(select 3 from t1);

select * from t1 order by 1;

select sleep(2);
insert into t1(a, b) values(select 1 from t1, 3) on duplicate key update b=(select '100' from t1);

--select * from t1 order by 1;
select a,b,if(current_timestamp-c>=0 and current_timestamp -c<5,'ok','nok') from t1;

select sleep(2);
insert into t1(a, b) values(default, 3) on duplicate key update b=(select 22 from t1);

--select * from t1 order by 1;
select a,b,if(current_timestamp-c>=0 and current_timestamp -c<5,'ok','nok') from t1;

--CUBRIDSUS-13548
select sleep(2);
insert into t1(b) values(10) on duplicate key update b=(select 456 from t1);
--select * from t1 order by 1;
--select a,b,if(current_timestamp-c>=0 and current_timestamp -c<5,'ok','nok') from t1;

--CUBRIDSUS-13548
select sleep(2);
replace into t1(b) values(111);
--select * from t1 order by 1;

select sleep(2);
insert into t1 default on duplicate key update b=default(b);

--select * from t1 order by 1;
select a,b,if(current_timestamp-c>=0 and current_timestamp -c<5,'ok','nok') from t1;

select sleep(2);
insert into t1(a,b) select a, default(b) from t1 on duplicate key update b=default(b)+a;

--select * from t1 order by 1;
select a,b,if(current_timestamp-c>=0 and current_timestamp -c<5,'ok','nok') from t1;

drop table t1;
