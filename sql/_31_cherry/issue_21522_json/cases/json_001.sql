drop table if exists t1;
create table t1 (id int AUTO_INCREMENT , a json);
insert into T1(a) values ('123');
insert into T1(a) values (123);
insert into T1(a) values ('"123"');
insert into T1(a) values ('"aaa"');
insert into T1(a) values ('123.12');
insert into T1(a) values (123.12);
insert into T1(a) values (json_array('a','b'));
insert into T1(a) values (json_object('a','b'));     
insert into T1(a) values ('{"key1":"value1"}');
insert into T1(a) values ('["value2","value3"]');       
insert into T1(a) values ('["a","b","c"]');
insert into T1(a) values ('{"a":["b","c"]}');

--invalid json data
insert into T1(a) values ('aaa');
insert into T1(a) values ('12.12f');
insert into T1(a) values ('["a":"b"]');
insert into T1(a) values ('{"a":"b","c"}');

select a, json_type(a), id from t1 order by 1,2,3;
select * from t1 where a=123 order by 2,1;
select * from t1 where a='123' order by 2,1;
select * from t1 where a="123" order by 2,1;
select * from t1 where a='"123"' order by 2,1;

select 
  json_type(a), 
  group_concat(id order by id), 
  group_concat(cast ( a as string) order by cast ( a as string) ) 
from t1 
group by json_type(a) 
order by 1,2;

drop table if exists t1;

