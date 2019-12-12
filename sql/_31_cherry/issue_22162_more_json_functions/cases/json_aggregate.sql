
--CBRD-22494
drop table if exists t1;
create table t1 (id int , col varchar(10));
insert into t1 values (2, NULL), (2, NULL);
select id, JSON_ARRAYAGG(col) from t1 group by id order by 1;
select id, JSON_OBJECTAGG(id,col) from t1 group by id order by 1;
drop table if exists t1;

select * from json_table(NULL, NULL, NULL);

--CBRD-22451
drop table if exists t3;
create table t3 ( id int , col1 varchar(10), col2 varchar(10));
insert into t3 values (2, 'a', 'A');
insert into t3 values (2, 'b','B');
insert into t3 values (3, 'a', 'C');
insert into t3 values (3,'c','D');
insert into t3 values (4,NULL,NULL);
insert into t3 values (4,100,NULL);
insert into t3 values (NULL,NULL,NULL);

select JSON_ARRAYAGG(col1) from (select * from t3 order by 1,2,3)  order by 1;
select id, JSON_ARRAYAGG(id) from (select * from t3 order by 1,2,3)  order by 1;
select id, JSON_ARRAYAGG(id) from (select * from t3 order by 1,2,3) group by id order by 1;
select id, JSON_ARRAYAGG(col1) from (select * from t3 order by 1,2,3) group by id order by 1;
select id, JSON_ARRAYAGG(col2) from (select * from t3 order by 1,2,3) group by id order by 1;
select id, JSON_ARRAYAGG(col1,col2) from (select * from t3 order by 1,2,3) group by id order by 1;
select id, JSON_ARRAYAGG(col1+col2) from (select * from t3 order by 1,2,3) group by id order by 1;
select id, JSON_ARRAYAGG(col1-col2) from (select * from t3 order by 1,2,3) group by id order by 1;
select id, JSON_ARRAYAGG(id-id) from (select * from t3 order by 1,2,3) group by id order by 1;

select JSON_OBJECTAGG(col1, col2) from (select * from t3 order by 1,2,3) where col1 is not NULL order by 1;
select JSON_OBJECTAGG(col1, col2) from (select * from t3 order by 1,2,3) where col1 is not NULL group by id order by 1;     
select id, JSON_OBJECTAGG(id, col2) from (select * from t3 where col1 is not NULL order by 1,2,3) group by id order by 1;     
select id, JSON_OBJECTAGG(repeat(col2,2),json_arrayagg(id)) from (select * from t3 where col1 is not NULL order by 1,2,3) group by id order by 1; 

drop table if exists t3;




