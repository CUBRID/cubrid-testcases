--+ holdcas on;

drop table if exists tb;

create table tb(a string);

create index i_tb_a on tb(a);

insert into tb values(repeat('a',100));

insert into tb values(repeat('abc',100));

select x.a,y.a from tb x,tb y where x.a>1 and y.a>1 order by 1, 2;

select x.a,y.a from tb x,tb y where x.a=y.a and (x.a>1) order by 1, 2;


drop table if exists t1;

create table t1(s1 string,s2 varchar,s3 char(1000));

create reverse index ri_t_s1_s2_s3 on t1(s1,s2,s3);  
    
insert into t1 values(repeat('abc',100),'test','chartest');

insert into t1 values('test',repeat('abc',100),'chartest'); 

insert into t1 values(repeat('test',100),repeat('abc',100),repeat('chartest',50));

select s3,count(*) from t1 where s1>'0' group by s1 desc having count(*) >0 order by 1, 2; 


drop table if exists t;

create table t (a string, b varchar);

insert into t values('abc',repeat('abc',200));

insert into t values(repeat('abc',200),'abc');

insert into t values(repeat('def',200),repeat('def',200));   
   
create index i_t_a_b on t (a,b);

create index i_t_b_a on t (b,a);

select * from t a,t b where a.a=b.b using index a.i_t_a_b order by 1, 2, 3, 4;

select * from (select * from t where a>0 using index i_t_a_b keylimit 0,3) x, (select * from t where b>'0' using index i_t_b_a keylimit 0,2) y where x.a=y.a order by 1, 2, 3, 4;

drop table tb;

drop table t1;

drop table t;

--+ holdcas off;
