drop table if exists t;
create table t ( p int primary key, st string);
select * from t using index pk_t_p order by p union select * from t using index pk_t_p order by p;
(select * from t using index pk_t_p order by p) union (select * from t using index pk_t_p order by p);

drop table if exists t;

drop table if exists tbl1,tbl2;
create table tbl1 ( a int primary key, st string);
create table tbl2 ( b int primary key, st string);
SELECT * FROM tbl1 ORDER BY a UNION SELECT * FROM tbl2 ORDER BY b; 
(SELECT * FROM tbl1 ORDER BY a) UNION (SELECT * FROM tbl2 ORDER BY b); 
drop table if exists tbl1,tbl2;
