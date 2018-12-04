SET SYSTEM PARAMETERS 'intl_number_lang="en_US"';
drop table if exists t;
create table t(i int auto_increment,j varchar(50),k varchar(50));
insert into t(k) values('12000.123456');
with cte1(a) as
(
 SELECT FORMAT(k, 3) from t
) update t set j=(select a from cte1);
select * from t ;

with cte1(a) as
(
 SELECT FORMAT(k, 0) from t
) update t set j=(select a from cte1);
select * from t ;


SET SYSTEM PARAMETERS 'intl_number_lang="de_DE"';

with cte1(a) as
(
 SELECT FORMAT(k, 3) from t
) update t set j=(select a from cte1);
select * from t ;

 SELECT FORMAT(k, 3) from t;

with cte1(a) as
(
 SELECT FORMAT(k, 0) from t
) update t set j=(select a from cte1);
select * from t ;

 SELECT FORMAT(k, 0) from t;
drop table if exists t;
SET SYSTEM PARAMETERS 'intl_number_lang="en_US"';
