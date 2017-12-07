drop table if exists t1;
drop table if exists t1;
create table t1(i int, b json);
create table t2(i int, b json);
insert into t1 values(1, json_object('name', 'sam', 'sale', '10000')); 
insert into t1 values(2, json_object('name', 'yes', 'sale', '1200'));
insert into t2 values(2, json_object('name', 'funny', 'sale', '19200'));
insert into t2 values(2, json_object('name', 'funny', 'sale', '19200')); 
select sum(json_extract(b, '/sale')) from t2 group by json_extract(b, '/name');
select * from t1 where exists (select sum(json_extract(b, '/sale')) from t2 group by json_extract(b, '/name')) order by i desc;
insert into t1 values(3, NULL); 
insert into t2 values(3, NULL);
select * from t1 where exists (select sum(json_extract(b, '/sale')) from t2 group by json_extract(b, '/name')) order by i desc;

set @js='{
"employee":{ "name":"John", "age":30, "city":"New York" }
}';
update t1 set t1.b=(select json_merge(b, @js) from t2 where cast(json_extract(@js, '/employee/age') as integer)>20 group by json_extract(@js, '/name'));
select * from t1 order by i;
select (select sum(json_extract(b, '/sale')) from t1 group by json_extract(b, '/name')||'-'||json_extract(b, '/employee/name') order by i limit 1) as sum_sale from t2 order by i;
drop VARIABLE @js;
drop table t1;
drop table t2;
