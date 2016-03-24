--+ holdcas on;
--01_alias_group_by_having_QA_Effort_01.sql

drop table if exists t1;
create table t1(a int, b int, c int);
insert into t1 values(1,1,1);
insert into t1 values(2,null,2);
insert into t1 values(2,null,2);
insert into t1 values(2,3,2);
insert into t1 values(2,2,2);

select a, ifnull(b,null) as b from t1 group by a,b order by 1,2;
select a, ifnull(b,3) as b from t1 group by a,b order by 1,2;
select a, ifnull(b,null) b from t1 group by a,b order by 1,2;
select a, ifnull(b,3) b from t1 group by a,b order by 1,2;


select a, ifnull(b,999) as b from t1 where b=999 group by a,b;
select a, ifnull(b,999) as b from t1 group by a,b having b = 999;
select a, ifnull(b,999) as b from t1 group by b having b = 999;
select a, ifnull(b,999) b from t1 where b=999 group by a,b;
select a, ifnull(b,999) b from t1 group by a,b having b = 999;
select a, ifnull(b,999) b from t1 group by b having b = 999;


select a, ifnull(b,3) as b from t1 order by b;
select a, ifnull(b,3) as b from t1 group by b;
select a, ifnull(b,3) as b from t1 group by b order by b;

select a, ifnull(b,3) b from t1 order by b;
select a, ifnull(b,3) b from t1 group by b;
select a, ifnull(b,3) b from t1 group by b order by b;

select a, ifnull(b,3) as b, count(*) from t1 group by ifnull(b,2);
select a, ifnull(b,3) as b, count(*) from t1 group by ifnull(b,3);

select a, ifnull(b,3) as b, count(*) from t1 group by ifnull(b,a);
select a, ifnull(b,3) as b, count(*) from t1 group by ifnull(a,b);

select a, b, count(*) from t1  group by if(b is null, 2, b) order by b;
select a, b, count(*) from t1  group by if(b is null, 2, b) order by b nulls first;
select a, b, count(*) from t1  group by if(b is null, 2, b) order by b nulls last;
select a, b  from t1  order by b nulls last;
select a, ifnull(b,1) as b  from t1  order by b nulls last;
select a, ifnull(b,null) as b  from t1  order by b nulls last;
select a, ifnull(b,null) as b  from t1  order by b desc nulls last;
select a, ifnull(b,3) as b  from t1  order by b desc nulls last;
select a, ifnull(b,3) as b  from t1  group by b desc order by b;
select a, ifnull(b,3) as b  from t1  group by ifnull(b,null) desc order by b nulls last;
select a, b from t1  order by ifnull(b,null) desc;
select a, b from t1 group by ifnull(b,null) order by b desc;
select a, b from t1 group by ifnull(b,null) order by ifnull(b,3) desc;
select a, ifnull(b,-1) as b from t1 group by ifnull(b,null) order by ifnull(b,3) desc;
select a, ifnull(b,-1) as b from t1 group by ifnull(b,null) order by ifnull(b,3) asc;
select a, ifnull(b,null) as b from t1 group by ifnull(b,null) order by ifnull(b,3) asc;
select a, ifnull(b,null) as b from t1 group by ifnull(b,null) order by ifnull(b,5) asc;
select a, ifnull(b,-1) as b from t1 group by ifnull(b,null) order by ifnull(b,5) asc;
select a, b from t1 group by ifnull(b,null) order by ifnull(b,3) asc;

select a, b ,count(*) from t1 group by ifnull(b,101) desc;
select a, b ,count(*) from t1 group by ifnull(b,101) desc order by b nulls last;
select a, b  from t1 group by b desc order by b nulls last;
select a, ifnull(b,100) as b ,count(*) from t1 group by ifnull(b,101) desc;

select a, b from t1 group by b desc;
select a, b from t1 group by b asc;
select a, b from t1 group by ifnull(b,3) desc;
select a, ifnull(b,100) from t1 group by ifnull(b,null) desc;
select a, ifnull(b,100) ,count(*) from t1 group by ifnull(b,null) desc;
select a, ifnull(b,100) as b ,count(*) from t1 group by ifnull(b,null) desc;
select a, ifnull(b,100) as b ,count(*) from t1 group by ifnull(b,101) desc;
select a, ifnull(b,100) ,count(*) from t1 group by b desc;
select a, b from (select a,ifnull(b,3) as b from t1) group by ifnull(b,3) desc;
select a, b from (select a,ifnull(b,null) as b from t1) group by ifnull(b,3) desc;
select a, b from t1 group by ifnull(b,3) order by ifnull(b,null) desc;
select a, b from t1 group by ifnull(b,3) order by ifnull(b,null) desc;
select a, b from t1 group by ifnull(b,3) order by ifnull(b,null) asc;

select a, b from t1 group by ifnull(b,null) order by ifnull(b,null) desc;
select a, ifnull(b,a) as b  from t1  order by ifnull(b,a) desc nulls last;
select a, ifnull(b,a) as b  from t1  order by ifnull(b,null) desc nulls last;

select a, ifnull(b,3) as b, count(*) from t1 group by if(b is null, 2, b);

select a, if(b is null, 2, b) as b, count(*) from t1 group by if(b is null, 2, b);
select a, if(b is null, 10, b) as b, count(*) from t1 group by if(b is null, 10, b);
select a, if(b is null, null, b) as b, count(*) from t1 group by if(b is null, 10, b);

select a, ifnull(b,3) as b, count(*) from t1 group by ifnull(b,2) having if(b is null, 999, b) = 999;
select a, b, count(*) from t1 group by ifnull(b,2) having if(b is null, 999, b) = 999;

select a, ifnull(b,3) as b, count(*) from t1 group by ifnull(b,2) having if(b is null, a, b) = 3;

select a, b as bxx from t1 group by bxx having bxx is not null;

select a, ifnull(b,3) as b, count(*) from t1 group by if(b is null, power(a,2), power(b,2));

select a as axx, ifnull(b,3) as bxx, count(*) from t1 group by if(bxx is null, power(axx,2), power(bxx,2)) having power(axx, 2) > 1;

select * from t1 where b in (select ifnull(b,2) as b from t1 group by b);
select ifnull(b,4) as b from t1 where b in (select ifnull(b,null) as b from t1 group by b) order by 1;

select a, b as bxx from t1 ;
select a, b as bxx from t1 group by bxx = 1;
select a, b as bxx from t1 group by b = 1;
select a, ifnull(b,1) as bxx from t1 group by b = 1;
select a, ifnull(b,1) as bxx from t1 group by bxx = 1;
select a, ifnull(b,1) as bxx from t1 group by b = 1 having b = 1;
select a, ifnull(b,2) as bxx from t1 group by b = 1 having b = 1;
select a, ifnull(b,1) as b from t1 group by b = 1 having b = 1;
select a, ifnull(b,1),count(*) as b from t1 group by b = 1 having b = 1;

--errer--

select a, b as bxx from t1 where bxx = 1;
select a, b from t1 group by bxx = 1;

-- pt_name --
select a , count(*) from t1 group by b;
select a as b, count(*) from t1 group by b;
select a as bxx, count(*) from t1 group by bxx;
select a as bxx, count(*) from t1 group by bx;

-- pt_dot --
select a, b, count(*) from t1 group by t1.a;
select t1.a as b, count(*) from t1 group by t1.b;
select t1.a as bxx, count(*) from t1 group by b;
select t1.a as bxx, count(*) from t1 group by bxx;
select a as bxx, count(*) from t1 group by bxx;
select a as bxx, count(*) from t1 group by b;
select a as bxx, ifnull(b,3) as b,count(*) from t1 group by b;
select t1.a as bxx, count(*) from t1 group by t1.bxx;

-- pt_expr --
select a, ifnull(b, 2) as b from t1 group by b;
select a, ifnull(b, 2) as b from t1 group by t1.b;
select a, ifnull(t1.b, 2) as b from t1 group by b;
select a, ifnull(b, 2) as b from t1 group by power(b, 2);
select a, ifnull(b, 2) as txx from t1 group by power(txx,2);
select a, ifnull(b, 2) as b from t1 group by power(txx,2);

-- pt_sort_spec --
select a, ifnull(b, 2) as b from t1 group by 2;
select a, b from t1 group by 2;
select a, b from t1 group by 3;
select a as 2, b from t1 group by 2;

drop table if exists t1;

--+ holdcas off;
commit;