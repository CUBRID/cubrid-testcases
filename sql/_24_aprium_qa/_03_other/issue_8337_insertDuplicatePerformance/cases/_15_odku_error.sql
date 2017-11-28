drop table if exists tt, t,t1,t2;
create table t(i int default 0, j SMALLINT not null default 0, k NUMERIC(5,0) not null default 0 ,l FLOAT not null default 0,m date not null default '11/30/1960' ,n char(200) not null default '0');
create unique index u_t_i on t(i);
alter table t add constraint primary key(i,j);

insert into t select rownum, rownum, rownum, rownum, '11/30/2012', rownum from _db_class limit 5;

create table t1(i bigint, j SMALLINT, k NUMERIC(5,0),l FLOAT,m date,n char(200) );

insert into t1 select rownum, rownum, rownum, rownum, '11/30/2012', rownum from _db_class limit 5;

select * from t order by 1;
select * from t1 order by 1;
create serial s1;

--test error
insert into t select * from t1 on duplicate key update t.m=t1.m-1,t1.m=ADDDATE(SYSDATE, -1);
insert into t select * from t1 on duplicate key update t.m=s1.next_value;
insert into t select * from t1 on duplicate key update t.i=null;

ALTER unique INDEX u_t_i on t REBUILD;

--test error
insert into t select * from t1 on duplicate key update t.m=t1.m-1,t1.m=ADDDATE(SYSDATE, -1);
insert into t select * from t1 on duplicate key update t.m=s1.next_value;
insert into t select * from t1 on duplicate key update t.i=t1.i + 111111111111111- 111111111111111;

drop unique index u_t_i on t;

insert into t select * from t1 on duplicate key update t.i=t1.i + 111111111111111- 111111111111111;

select * from t order by 1;

insert into t(j,i,k,l,m,n) select * from t1 on duplicate key update t.i= default;

create unique index u_t_i on t(i);

insert into t(j,i,k,l,m,n) select * from t1 on duplicate key update t.i= default;

insert into t(j,i,k,l,m,n) select * from t1 on duplicate key update t.j=t1.i + 11,t.i=t.i,t.k=t1.k,t.l=t.i,t.m='11/30/1111',t.n=t.i;

insert into t(j,i,k,l,m,n) select * from t1 on duplicate key update t.i= s1.next_value,t.j= s1.next_value,t.k= default ,t.l= default ,t.m= default,t.n= default;

select * from t order by i,k,j,l,m,n;

insert into t(j,i,k,l,m,n) select * from t1 on duplicate key update t.i= s1.next_value,t.j= s1.next_value,t.k= default ,t.l= default ,t.m= default,t.n= default;

select * from t order by i,k,j,l,m,n;
drop table if exists  tt, t,t1,t2,t3;
drop serial s1;

drop table if exists t,t2;

