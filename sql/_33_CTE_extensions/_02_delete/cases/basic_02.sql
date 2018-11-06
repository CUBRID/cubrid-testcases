
drop table if exists t1,t_d_1,t_d_2;
create table t_d_1(i int);
create table t_d_2(i int);
create table t1 (a int, b int);
insert into t1 values(1,2),(3,4);

insert into t_d_1
WITH cte_4AujmP314 AS
(
select count(distinct a) from t1 group by a with rollup
) select * from cte_4AujmP314; 

insert into t_d_2
WITH cte_4AujmP314 AS
(
select count(distinct a) from t1 group by a with rollup
) select * from cte_4AujmP314;


replace into t_d_1
WITH cte_4AujmP314 AS
(
select count(distinct a) from t1 group by a with rollup
) select * from cte_4AujmP314;

replace into t_d_2
WITH cte_4AujmP314 AS
(
select count(distinct a) from t1 group by a with rollup
) select * from cte_4AujmP314;



WITH cte_4AujmP314 AS
(
select count(distinct b) from t1 group by a with rollup
)
delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i <=(select count(*) from cte_4AujmP314);



drop table t1;

create table c(
col_varchar_10_key character varying(10),
col_int integer,
col_int_key integer,
col_varchar_10 character varying(10),
col_varchar_1024_key character varying(1024),
pk integer primary key,
col_varchar_1024 character varying(1024));

create table bb(
col_int_key integer,
col_varchar_1024 character varying(1024),
col_varchar_10_key character varying(10),
col_varchar_1024_key character varying(1024),
pk integer primary key,
col_int integer,
col_varchar_10 character varying(10));

CREATE INDEX col_varchar_10_key_idx ON c (col_varchar_10_key);
CREATE INDEX col_int_key_idx ON c (col_int_key);
CREATE INDEX col_varchar_1024_key_idx ON c (col_varchar_1024_key);
CREATE INDEX col_int_key_idx ON bb (col_int_key);
CREATE INDEX col_varchar_10_key_idx ON bb (col_varchar_10_key);
CREATE INDEX col_varchar_1024_key_idx ON bb (col_varchar_1024_key);

insert into c values('w',1494482944,89653248,NULL,'t',1,'l');
insert into c values('h',-2015756288,1371078656,'v',NULL,2,'m');
insert into c values('n',49741824,-515833856,'k','d',3,'a');
insert into c values(NULL,-818413568,19645,'e',NULL,4,'p');
insert into c values('t',NULL,11013,'z','w',5,'h');
insert into c values('e',-1151074304,13683,'t','r',6,'p');
insert into c values(NULL,-261226496,-2848,'e','j',7,NULL);

with mycte as
(
SELECT  COUNT(DISTINCT OUTR.col_int ) AS X FROM c AS OUTR
WHERE OUTR.col_varchar_1024_key IN ( SELECT  INNR.col_varchar_10 AS Y FROM bb AS INNR WHERE INNR.col_int IS NULL  )
AND OUTR.col_int_key > 5 AND OUTR.col_varchar_10_key <> 'l'
) select * from mycte;

insert into t_d_1 select rownum from db_root connect by level<=5;
insert into t_d_2 select rownum from db_root connect by level<=5;
with mycte as
(
SELECT  COUNT(DISTINCT OUTR.col_int ) AS X FROM c AS OUTR
WHERE OUTR.col_varchar_1024_key IN ( SELECT  INNR.col_varchar_10 AS Y FROM bb AS INNR WHERE INNR.col_int IS NULL  )
AND OUTR.col_int_key > 5 AND OUTR.col_varchar_10_key <> 'l'
) delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i <=(select X from mycte);

with mycte as
(
 SELECT  COUNT(DISTINCT OUTR.col_int ) AS X FROM c AS OUTR
WHERE OUTR.col_varchar_1024_key IN ( SELECT  INNR.col_varchar_10 AS Y FROM bb AS INNR WHERE INNR.col_int IS NULL  )
AND OUTR.col_int_key > 5 AND OUTR.col_varchar_10_key <> 'l'
GROUP BY OUTR.col_int WITH ROLLUP
HAVING X <= 8 ORDER BY OUTR.col_int , OUTR.pk
) select * from mycte;


with mycte as
(
 SELECT  COUNT(DISTINCT OUTR.col_int ) AS X FROM c AS OUTR
WHERE OUTR.col_varchar_1024_key IN ( SELECT  INNR.col_varchar_10 AS Y FROM bb AS INNR WHERE INNR.col_int IS NULL  )
AND OUTR.col_int_key > 5 AND OUTR.col_varchar_10_key <> 'l'
GROUP BY OUTR.col_int WITH ROLLUP
HAVING X <= 8 ORDER BY OUTR.col_int , OUTR.pk
) update t_d_2 set i=2 where i=1;

with mycte as
(
 SELECT  COUNT(DISTINCT OUTR.col_int ) AS X FROM c AS OUTR
WHERE OUTR.col_varchar_1024_key IN ( SELECT  INNR.col_varchar_10 AS Y FROM bb AS INNR WHERE INNR.col_int IS NULL  )
AND OUTR.col_int_key > 5 AND OUTR.col_varchar_10_key <> 'l'
GROUP BY OUTR.col_int WITH ROLLUP
) update t_d_2 set i=2 where i=1;


WITH cte_RKEbuiPR9 AS
(
SELECT  COUNT(DISTINCT OUTR.col_int ) AS X FROM c AS OUTR 
WHERE OUTR.col_varchar_1024_key IN ( SELECT  INNR.col_varchar_10 AS Y FROM bb AS INNR WHERE INNR.col_int IS NULL  ) 
AND OUTR.col_int_key > 5 AND OUTR.col_varchar_10_key <> 'l' 
GROUP BY OUTR.col_int WITH ROLLUP 
HAVING X <= 8 ORDER BY OUTR.col_int , OUTR.pk
)delete t_d_1 from t_d_1,t_d_2 where t_d_1.i=t_d_2.i and t_d_1.i <=(select count(*) from cte_RKEbuiPR9);



--drop table c;

--drop table bb;


