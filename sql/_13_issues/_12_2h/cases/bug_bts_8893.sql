create table t1(a char(1));
insert into t1(a) values('Y');
insert into t1(a) values('N');
select a,UPPER(nvl(a, 'N')) from t1 ;

create table t2(a char(10));
insert into t2(a) values('null');
insert into t2(a) values('NULL');
select a,UPPER(nvl(a, 'N')) from t2 ;


create table t3(a int, b char(10));
insert into t3(a) values(1);
insert into t3(b) values('null');
select a, UPPER(nvl(a,'10')) from t3;
select b, UPPER(nvl(b,'10')) from t3;

drop t1;
drop t2;
drop t3;

