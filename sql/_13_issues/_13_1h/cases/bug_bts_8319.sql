drop if exists t1,t2,t3,t4,t5; 
CREATE TABLE t1( "a" character varying(20), "b" character varying(20), "c" character varying(200), "d" character varying(500), "e" smallint, "f" character varying(20), "g" character varying(20), "h" character varying(20), "i" character varying(20), "j" character varying(1), "k" character varying(8), "l" datetime, "m" character varying(8), "n" datetime, "o" character varying(300), "p" character varying(300), "q" character varying(300), "r" character varying(300) ); 

select sum(a) over(partition by b) as sumover, rank() over(partition by g order by a)  from t1 where a='S003';

select sum(a) over(partition by a) as sumover, rank() over(partition by r order by a)  from t1 where a='S003';

select a, row_number() over(order by a) from t1 group by a;

select a, row_number() over(partition by b order by c)  from t1    group by d with rollup;;

select a, row_number() over(partition by b order by c)  from t1    group by d with rollup;

select b, row_number() over(order by 1) from t1 group by d;

select b, row_number() over(order by 1) from t1 group by b;

select t1.*, row_number() over(partition by l order by n)  from t1 group by l;


CREATE TABLE t2( "a" character varying(8), "b" character varying(2), "c" character varying(2), "d" character varying(4), "e" character varying(10), "f" bigint, "g" bigint, "h" bigint, "i" bigint, "j" bigint, "k" bigint, "l" bigint, "m" datetime, "n" bigint DEFAULT 0, "o" bigint DEFAULT 0, "p" bigint );

insert into t2 select rownum,rownum,rownum,rownum,rownum,rownum,rownum,rownum,rownum,rownum,rownum,rownum,null,rownum,rownum,rownum from db_class limit 10;

select sum(a) over(partition by b) as sumover, rank() over(partition by g order by a)  from t2 where a='S003';

select sum(a) over(partition by a) as sumover, rank() over(partition by b order by a)  from t2 where a='S003';

select a, row_number() over(order by a) from t2 group by a;

select a, row_number() over(partition by b order by c)  from t2    group by d with rollup;;

select a, row_number() over(partition by b order by c)  from t2    group by d with rollup;

select b, row_number() over(order by 1) from t2 group by d;

select b, row_number() over(order by 1) from t2 group by b;

select t2.*, row_number() over(partition by a order by n)  from t2 group by l;

CREATE TABLE "t3"( "a" character varying(8), "b" character varying(2), "c" character varying(10), "d" character varying(3), "e" bigint, "f" bigint, "g" bigint, "h" bigint, "i" bigint, "j" bigint, "k" bigint, "l" bigint, "m" bigint, "n" bigint, "o" bigint, "p" bigint, "q" bigint, "r" bigint, "s" bigint, "t" bigint, "u" character varying(10), "v" datetime, "w" character varying(20), "x" datetime, "y" character varying(20) );

select sum(a) over(partition by b) as sumover, rank() over(partition by g order by a)  from t3 where a='S003';

select sum(a) over(partition by a) as sumover, rank() over(partition by r order by a)  from t3 where a='S003';

select a, row_number() over(order by a) from t3 group by a;

select a, row_number() over(partition by b order by c)  from t3    group by d with rollup;;

select a, row_number() over(partition by b order by c)  from t3    group by d with rollup;

select b, row_number() over(order by 1) from t3 group by d;

select b, row_number() over(order by 1) from t3 group by b;

select t3.*, row_number() over(partition by l order by n)  from t3 group by l;


select t1.b,nvl(sum(t1.b),0) as a, nvl(sum(b),0) as b,nvl(sum(c),0) as counsreqcnt from t1 group by t1.b;

select t1.b,nvl(sum(t1.b),0) as a, nvl(sum(b),0) as b,nvl(sum(c),0) as counsreqcnt from t1 group by t1.b,t1.a;

select t1.b,t1.a, nvl(sum(t1.b),0) as a, nvl(sum(b),0) as b,nvl(sum(c),0) as counsreqcnt from t1 group by t1.b,t1.a;

select t1.b,t1.a, nvl(sum(t1.b),0) as a, nvl(sum(b),0) as b,nvl(sum(c),0) as counsreqcnt from t1 group by t1.b,t1.a;

create table t4 as select * from t2;

create table t5 as select * from t3;

select t1.b, t1.a, nvl(sum(t1.b),0) as a, nvl(sum(t1.b),0) as b,nvl(sum(t1.c),0) as counsreqcnt from t1,t2,t3,t4,t5 group by t1.b,t1.a ;

select t1.b, t1.a, nvl(sum(t1.b),0) as a, nvl(sum(t1.b),0) as b,nvl(sum(t1.c),0) as counsreqcnt from t1,(select * from t2),(select * from t3),(select * from t4),(select * from t5) group by t1.b,t1.a ;

select t1.b, t1.a, nvl(sum(t1.b),0) as a, nvl(sum(t1.b),0) as b,nvl(sum(t1.c),0) as counsreqcnt from t1,(select * from t2),(select * from t3),(select * from t4),(select * from t5) group by t1.c,t2.a ;

select t1.b, t1.a, nvl(sum(t1.b),0) as a, nvl(sum(t1.b),0) as b,nvl(sum(t1.c),0) as counsreqcnt from t1,(select * from t2),(select * from t3),(select * from t4),(select * from t5) group by t1.c,t2.a ;

select t1.b, t1.a, nvl(sum(t1.b),0) as a, nvl(sum(t1.b),0) as b,nvl(sum(t1.c),0) as counsreqcnt, row_number() over(partition by t1.a) as a, rank() over(partition by t1.r order by t1.a)   from t1,(select * from t2),(select * from t3),(select * from t4),(select * from t5) group by t1.c,t2.a ;

select t1.b, t1.a, nvl(sum(t1.b),0) as a, nvl(sum(t1.b),0) as b,nvl(sum(t1.c),0) as counsreqcnt, row_number() over(partition by t1.a) as a, rank() over(partition by t1.r order by t1.a)   from t1,(select * from t2),(select * from t3),(select * from t4),(select * from t5) group by t1.c,t2.a ;

drop if exists t1,t2,t3,t4,t5; 
