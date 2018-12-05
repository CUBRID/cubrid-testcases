drop table if exists t;
create table t(i int auto_increment,j varchar(50),k datetime);
insert into t(k) values('2009-10-04 22:23:00');
with cte1(a) as
(
 SELECT DATE_FORMAT(k, '%W %M %Y') from t
) update t set j=(select a from cte1);
select * from t ;

with cte1(a) as
(
 SELECT DATE_FORMAT(k, '%H:%i:%s') from t
) update t set j=(select a from cte1);
select * from t ;

with cte1(a) as
(
 SELECT DATE_FORMAT(k, '%D %y %a %d %m %b %j') from t
) update t set j=(select a from cte1);
select * from t ;

with cte1(a) as
(
 SELECT DATE_FORMAT(k, '%X %V') from t
) update t set j=(select a from cte1);
select * from t ;

SET SYSTEM PARAMETERS 'intl_date_lang="de_DE"';
with cte1(a) as
(
 SELECT DATE_FORMAT(k, '%W %M %Y') from t
) update t set j=(select a from cte1);
select * from t ;


with cte1(a) as
(
 SELECT DATE_FORMAT(k, '%H:%i:%s %p') from t
) update t set j=(select a from cte1);
select * from t ;
SELECT DATE_FORMAT(k, '%H:%i:%s %p') from t;

with cte1(a) as
(
 SELECT DATE_FORMAT(k, '%D %y %a %d %m %b %j') from t
) update t set j=(select a from cte1);
select * from t ;


SET SYSTEM PARAMETERS 'intl_date_lang="en_US"';
drop table t;

