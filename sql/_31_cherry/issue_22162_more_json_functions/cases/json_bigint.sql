--CBRD-21869
drop table if exists t1;
CREATE TABLE t1 (a json);
insert into t1(a) values ( '1'),( '9223372036854775805');
select * from t1 order by a;
select typeof(9223372036854775805);   

select  * from t1,  
json_table( a, '$'        
columns (                 
id for ordinality,        
b bigint path '$',        
c json path '$'           
))as t2 where a=b and b=c order by 1,2,3,4;

drop table if exists t1;
