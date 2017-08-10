drop table if exists t1,t2;
create table t1 (a int, b  varchar(32));
insert into t1 values
  (4,'aaaa' ), (7,'bb'), (1,'ccc'), (4,'dd');  
insert into t1 values
  (3,'eee'), (7,'bb'), (1,'fff'), (4,'ggg');
create table t2 (c int);
insert into t2 values
  (2), (4), (5), (3);  
with recursive t as (select a from t1 where b >= 'c') 
  select * from t2,t where t2.c=t.a order by 1,2;

with recursive t as (select a from t1 where b >= 'c') 
  select t2.*,t.* from t2,t where t2.c=t.a order by 1,2;

select t2.*,t.* from t2, (select a from t1 where b >= 'c') as t where t2.c=t.a order by 1,2;

with recursive t as (select * from t1 where b >= 'c') 
  select * from t2,t where t2.c=t.a order by 1,2,3;

with recursive t as (select * from t1 where b >= 'c') 
  select t2.*,t.* from t2,t where t2.c=t.a order by 1,2,3;

with recursive t(f1,f2) as (select * from t1 where b >= 'c') 
  select * from t2,t where t2.c=t.f1 order by 1,2,3;

with recursive t as (select a, count(*) from t1 where b >= 'c' group by a) 
 select * from t2,t where t2.c=t.a order by 1,2,3;

select * from t2, (select a, count(*) from t1 where b >= 'c' group by a) as t 
 where t2.c=t.a order by 1,2,3;

with recursive t as (select a, count(*) from t1 where b >= 'c'
             group by a having count(*)=1 ) 
 select * from t2,t where t2.c=t.a order by 1,2,3;

select * from t2, (select a, count(*) from t1 where b >= 'c'
                      group by a having count(*)=1) t
 where t2.c=t.a order by 1,2,3; 

with recursive t as (select a, count(*) from t1 where b >= 'c'
             group by a having count(*)=1 ) 
 select * from t2,t order by 1,2,3; 

select * from t2, (select a, count(*) from t1 where b >= 'c'
             group by a having count(*)=1) t order by 1,2,3;

with recursive t as (select * from t2 where c <= 4) 
  select a, count(*) from t1,t where t1.a=t.c group by a having count(*)=1;  

select a, count(*) from t1, (select * from t2 where c <= 4) t 
  where t1.a=t.c group by a having count(*)=1;

with recursive t as (select * from t2 where c <= 4 ) 
  select a, count(*) from t1,t where t1.a=t.c group by a order by count(*); 

select a, count(*) from t1, (select * from t2 where c <= 4 ) t
  where t1.a=t.c group by a order by count(*); 

with recursive t as (select * from t2 where c <= 4 ) 
  select a, count(*) from t1,t
    where t1.a=t.c group by a order by count(*) desc limit 1; 

select a, count(*) from t1, (select * from t2 where c <= 4 ) t
  where t1.a=t.c group by a order by count(*) desc limit 1; 

with recursive t as (select a from t1 where a<5)
  select * from t2 where c in (select a from t) order by 1;
select * from t2 
  where c in (select a from (select a from t1 where a<5) as t) order by 1;

with recursive t as (select count(*) as c from t1 where b >= 'c' group by a)
  select * from t2 where c in (select c from t) order by 1;

select * from t2
  where c in (select c from (select count(*) as c from t1
                               where b >= 'c' group by a) as t) order by 1;

with recursive t as (select a from t1 where b >= 'c')
  select * from t as r1, t as r2 where r1.a=r2.a order by 1,2;

select * from (select a from t1 where b >= 'c') as r1,
              (select a from t1 where b >= 'c') as r2 
  where r1.a=r2.a order by 1,2;

with recursive t as (select distinct a from t1 where b >= 'c')
  select * from t as r1, t as r2 where r1.a=r2.a order by 1, 2;

select * from (select distinct a from t1 where b >= 'c') as r1,
              (select distinct a from t1 where b >= 'c') as r2 
  where r1.a=r2.a order by 1,2 ;

with recursive t as (select * from t1 where b >= 'c')
  select * from t as r1, t as r2 where r1.a=r2.a order by 1,2,3,4;

select * from (select * from t1 where b >= 'c') as r1,
              (select * from t1 where b >= 'c') as r2
  where r1.a=r2.a order by 1,2,3,4;

with recursive t(c) as (select a from t1 where b >= 'c')
  select * from t r1, t r2 where r1.c=r2.c order by 1;

with recursive t as (select a from t1 where b >= 'c')
  select * from t where a < 2
  union
  select * from t where a >= 4 order by 1;

select * from (select a from t1 where b >= 'c') as t
  where t.a < 2
union
select * from (select a from t1 where b >= 'c') as t
  where t.a >= 4 order by 1;

with recursive t as (select a from t1 where b >= 'f' 
           union
           select c as a from t2 where c < 4) 
  select * from t2,t where t2.c=t.a order by 1; 

select * from t2, 
              (select a from t1 where b >= 'f' 
               union
               select c as a from t2 where c < 4) as t 
 where t2.c=t.a order by 1;

--t is defined in the with recursive clause of a subquery
--CBRD-20820
select t1.a,t1.b from t1,t2
  where t1.a>t2.c and
        t2.c in (with recursive t as (select * from t1 where t1.a<5)
                   select t2.c from t2,t where t2.c=t.a) order by 1,2;

select t1.a,t1.b from t1,t2
  where t1.a>t2.c and
        t2.c in (select t2.c
                   from t2,(select * from t1 where t1.a<5) as t
                   where t2.c=t.a) order by 1,2;

with recursive t as (select c from t2 where c >= 4)
  select t1.a,t1.b from t1,t
    where t1.a=t.c and
          t.c in (with recursive t as (select * from t1 where t1.a<5)
                    select t2.c from t2,t where t2.c=t.a) order by 1,2;

select t1.a,t1.b from t1, (select c from t2 where c >= 4) as t
  where t1.a=t.c and
        t.c in (select t2.c from t2,  (select * from t1 where t1.a<5) as t
                 where t2.c=t.a) order by 1,2;

with recursive t as (select * from t1
              where a>2 and
                    b in (with recursive tt as (select * from t2 where t2.c<5)
                           select t1.b from t1,tt where t1.a=tt.c))
  select t.a, count(*) from t1,t where t1.a=t.a  group by t.a order by 1;

select t.a, count(*)
  from t1,
       (select * from t1
          where a>2 and
                b in (select t1.b
                        from t1,
                             (select * from t2 where t2.c<5) as tt
                          where t1.a=tt.c)) as t
    where t1.a=t.a  group by t.a order by 1;


select *
  from t1, 
       (with recursive t as (select a from t1 where b >= 'c') 
          select * from t2,t where t2.c=t.a) as tt
  where t1.b > 'f' and tt.a=t1.a order by 1,2,3,4; 

select *
  from t1, 
       (select * from t2,
                     (select a from t1 where b >= 'c') as t
          where t2.c=t.a) as tt
  where t1.b > 'f' and tt.a=t1.a order by 1,2,3,4; 

create view v1 as 
with recursive t as (select a from t1 where b >= 'c') 
  select * from t2,t where t2.c=t.a;
show create view v1;
select * from v1;

create view v2 as 
with recursive t as (select a, count(*) from t1 where b >= 'c' group by a) 
  select * from t2,t where t2.c=t.a;
show create view v2;
select * from v2;

create view v3 as
with recursive t(c) as (select a from t1 where b >= 'c')
select * from t r1 where r1.c=4;
show create view v3;
select * from v3;

create view v4(c,d) as
with recursive t(c) as (select a from t1 where b >= 'c')
select * from t r1, t r2 where r1.c=r2.c and r2.c=4;
show create view v4;
select * from v4;
drop view v1,v2,v3,v4;

create view v1(a) as 
with recursive t as (select a from t1 where b >= 'c') 
  select t.a from t2,t where t2.c=t.a;
update v1 set a=0 where a > 4;
drop view v1;

prepare stmt1 from '
with recursive t as (select a from t1 where b >= ?) 
  select * from t2,t where t2.c=t.a order by 1';
execute stmt1 using 'c';
deallocate prepare stmt1;

prepare stmt1 from '
with recursive t as (select a, count(*) from t1 where b >= ? group by a) 
 select * from t2,t where t2.c=t.a order by 1,2,3';
execute stmt1 using 'c';
deallocate prepare stmt1;

prepare stmt1 from '
with recursive t as (select * from t1 where b >= ?)
  select * from t as r1, t as r2 where r1.a=r2.a order by 1,2,3,4';
execute stmt1 using 'c';
deallocate prepare stmt1;

--error
with recursive t(f) as (select * from t1 where b >= 'c') 
  select * from t2,t where t2.c=t.f1 order by 1;

with recursive t(f1,f1) as (select * from t1 where b >= 'c') 
  select * from t2,t where t2.c=t.f1 order by 1;

with recursive t as (select * from t2 where c>3),
     t as (select a from t1 where a>2)
 select * from t,t1 where t1.a=t.c order by 1;

with recursive t as (select a from s where a<5),
     s as (select a from t1 where b>='d')
  select * from t,s where t.a=s.a order by 1;

with recursive recursive
     t as (select a from s where a<5),
     s as (select a from t1 where b>='d')
  select * from t,s where t.a=s.a order by 1;

with recursive recursive t as (select * from s where a>2),
               s as (select a from t1,r where t1.a>r.c), 
               r as (select c from t,t2 where t.a=t2.c) 
  select * from r where r.c<7 order by 1;

with recursive recursive
     t as (select * from s where a>2),
     s as (select a from t1,r where t1.a>r.c), 
     r as (select c from t,t2 where t.a=t2.c) 
  select * from r where r.c<7 order by 1;

with recursive recursive
     t as (select * from t1
             where a in (select c from s where b<='ccc') and  b>'b'),
     s as (select * from t1,t2
             where t1.a=t2.c and t1.c in (select a from t where a<5))
 select * from s where s.b>'aaa' order by 1;

with recursive t as (select count(*) from t1 where d>='f' group by a)
  select t1.b from t2,t1 where t1.a = t2.c order by 1;

with recursive t(d) as (select count(*) from t1 where b<='ccc' group by b),
     s as (select * from t1 where a in (select t2.d from t2,t where t2.c=t.d))
  select t1.b from t1,t2 where t1.a=t2.c order by 1;

with recursive t(d) as (select count(*) from t1 where b<='ccc' group by b),
     s as (select * from t1 where a in (select t2.c from t2,t where t2.c=t.c))
  select t1.b from t1,t2 where t1.a=t2.c order by 1;

with recursive t(d) as (select count(*) from t1 where b<='ccc' group by b),
     s as (select * from t1 where a in (select t2.c from t2,t where t2.c=t.d))
  select t1.b from t1,t2 where t1.a=t2.c order by 1;

with recursive t(f) as (select * from t1 where b >= 'c') 
  select t1.b from t2,t1 where t1.a = t2.c order by 1;

with recursive t(f1,f1) as (select * from t1 where b >= 'c') 
  select t1.b from t2,t1 where t1.a = t2.c order by 1;

with recursive t as (select a, count(*) from t1 where b >= 'c' group by a)
  select t1.b from t2,t1 where t1.a = t2.c order by 1;

with recursive t as (select c from t2 where c >= 4)
select t1.a,t1.b from t1,t where t1.a=t.c and
t.c in (with recursive t as (select * from t1 where t1.a<5)
select t2.c from t2,t where t2.c=t.a) order by 1,2;

select t1.a,t1.b from t1,t2
where t1.a>t2.c and
t2.c in (with recursive t as (select * from t1 where t1.a<5)
select t2.c from t2,t where t2.c=t.a) order by 1,2;

with recursive t as (select * from t1 where a>2 and 
b in ( with recursive tt as ( select * from t2 where t2.c<5 )
select t1.b from t1,tt where t1.a=tt.c)
) select t.a, count(*) from t1,t where t1.a=t.a  group by t.a order by 1,2;

drop table if exists t1,t2,t3;

create table t1 (a int, b  varchar(32));
insert into t1 values (4,'aaaa' ), (7,'bb'), (1,'ccc'), (4,'dd');  
insert into t1 values (3,'eee'), (7,'bb'), (1,'fff'), (4,'ggg');
create table t2 (c int);
insert into t2 values (2), (4), (5), (3);
create table t3(i int);
insert into t3 
  (with recursive t as (select * from t1 where t1.a<5)
                    select t2.c from t2,t where t2.c=t.a);
select * from t3 order by 1;
                 
with recursive t as (select c from t2 where c >= 4)
  select t1.a,t1.b from t1,t
    where t1.a=t.c and
          t.c in (with recursive t as (select * from t1 where t1.a<5)
                    select t2.c from t2,t where t2.c=t.a) order by 1,2;
					
with recursive t as (select c from t2 where c >= 4)
  select t1.a,t1.b from t1,t
    where t1.a=t.c and
          t.c in (select * from t3) order by 1,2;
		  
with recursive t as (select c from t2 where c >= 4)
  select t1.a,t1.b from t1,t
    where t1.a=t.c and
          t.c in (4,4,4,3);
 
with recursive t as (select * from t1 where t1.a<5)
  select t2.c from t2,t where t2.c=t.a order by 1;

drop table if exists t1,t2,t3;

create table t1 (a int, b  char(32));
insert into t1 values(4,'aaaa' );
insert into t1 values (7,'bb');
insert into t1 values (1,'ccc');
insert into t1 values (4,'dd');  
insert into t1 values(3,'eee');
insert into t1 values (7,'bb');
insert into t1 values (1,'fff');
insert into t1 values(4,'ggg');

create table t2 (c int);
insert into t2 values(2);
insert into t2 values(4);
insert into t2 values(5);
insert into t2 values(3);
                   
with  t as (select c from t2 where c >= 4)
  select t1.a,t1.b from t1,t
    where t1.a=t.c and
          t.c in (with  t as (select * from t1 where t1.a<5)
                    select t2.c from t2,t where t2.c=t.a) order by 1,2;
drop table if exists t1,t2,t3;

create table t1 (a int, b  char(32));
insert into t1 values(4,'aaaa' );
insert into t1 values (7,'bb');
insert into t1 values (1,'ccc');
insert into t1 values (4,'dd');  
insert into t1 values(3,'eee');
insert into t1 values (7,'bb');
insert into t1 values (1,'fff');
insert into t1 values(4,'ggg');

create table t2 (c int);
insert into t2 values(2);
insert into t2 values(4);
insert into t2 values(5);
insert into t2 values(3);

create table t3(i int);

insert into t3 (with recursive t as (
    select * from t1 where t1.a<5
) select t2.c from t2,t where t2.c=t.a);

select * from t3 order by 1;
                 
with  t as (select c from t2 where c >= 4)
  select t1.a,t1.b from t1,t
    where t1.a=t.c and
          t.c in (with  t as (select * from t1 where t1.a<5)
                    select t2.c from t2,t where t2.c=t.a) order by 1,2;

drop table if exists t1,t2,t3;
create table t1 (a int, b  char(32));
insert into t1 values(4,'aaaa' );
insert into t1 values (7,'bb');
insert into t1 values (1,'ccc');
insert into t1 values (4,'dd');  
insert into t1 values(3,'eee');
insert into t1 values (7,'bb');
insert into t1 values (1,'fff');
insert into t1 values(4,'ggg');
create table t2 (c int);
insert into t2 values(2);
insert into t2 values(4);
insert into t2 values(5);
insert into t2 values(3);
                   
with  t as (select c from t2 where c >= 4)
  select t1.a,t1.b from t1,t
    where t1.a=t.c and
          t.c in (with  t as (select * from t1 where t1.a<5)
                    select t2.c from t2,t where t2.c=t.a) order by 1,2;

drop if exists t1,t2,t3;
					
