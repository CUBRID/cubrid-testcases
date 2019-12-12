--+ holdcas on;
drop if exists t;
create table t(
a int primary key,
b date on update current_timestamp,
c time on update current_timestamp,
d timestamp on update current_timestamp,
e datetime on update current_timestamp,
f timestampltz on update current_timestamp,
g timestamptz on update current_timestamp,
h datetimeltz on update current_timestamp,
i datetimetz on update current_timestamp
);
insert into t(a) values(1),(2);
select * from t order by 1;
insert into t(a) values(3),(1) on duplicate key update a=4;
select if(b is not null && c is not null && d is not null && e is not null && f is not null && g is not null && h is not null && i is not null,'ok','nok') from t where a=4;
truncate table t;
insert into t(a) values(1),(2);
insert into t(a) select rownum from db_root connect by level<=10 on duplicate key update a=a-20;
select if(b is not null && c is not null && d is not null && e is not null && f is not null && g is not null && h is not null && i is not null,'ok','nok') from t where a<3;

drop if exists t;

create table t(
a int primary key,
b timestamp default current_timestamp on update current_timestamp,
c timestamp on update current_timestamp);
insert into t(a) values(1),(2);
set @a=(select b from t where a=1);
set @b=(select b from t where a=2);
select sleep(2);
insert into t(a) values(3),(1) on duplicate key update a=4;
set @c=(select b from t where a=3);
set @d=(select b from t where a=4);
select if(cast(@d as timestamp)-cast(@c as timestamp)=0 && cast(@b as timestamp)-cast(@a as timestamp)=0 &&cast(@d as timestamp)-cast(@b as timestamp)>=2,'ok','nok' );
select if( c is not null,'ok','nok' ) from t where a=4;   
drop variable @a,@b,@c,@d;
drop if exists t;

--+ holdcas off;
