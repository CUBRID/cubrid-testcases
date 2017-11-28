set @js :='{"a":"0.5", "b":"0.75"}';
SELECT JSON_EXTRACT(@js, '/b') - JSON_EXTRACT(@js, '/a') AS val;
select typeof(@js), json_type(@js);
drop table if exists t1;
create table t1(id int primary key auto_increment, name json);
insert into t1(name) select @js a;
select * from t1;
insert into t1(name) select json_merge(name, @js) from t1;
select * from t1 order by id;

SELECT AVG(JSON_EXTRACT(@js, '/b'));
select avg(if(json_type(json_extract(name, '/b'))='JSON_ARRAY', 0.25, json_extract(name, '/b'))) from t1;
SELECT CAST(JSON_EXTRACT(@js, '/b') AS decimal (3,2)) - CAST(JSON_EXTRACT(@js, '/a') AS decimal (3,2)) AS val;

drop VARIABLE @js;
drop table if exists t1;
