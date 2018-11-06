SET @j = '{ "a": 1, "b": [2, 3]}';
SELECT JSON_REPLACE(@j, '$.a', '10', '$.c', '[true, false]');
SELECT JSON_REPLACE(@j, '$.a', 10);
SELECT JSON_REPLACE(@j, '$.a', 10, '$.b', json_array('a'));
set @s='{
  "name": "json?????",
  "v1.0": "2014-07-02 22:05 ????",
  "v2.0": "2016-11-16 14:13 ??php, go???",
  "v2.1": "2016-11-19 01:17 ??java???"
}';

set @mm='{"name": "json?????",
  "v1.0": "2014-07-02 22:05 ????",
  "v2.0": "2016-11-16 14:13 ??php, go???",
  "v2.1": "2016-11-19 01:17 ??java???"
}';

select json_replace(@s, '/v1.0', cast(@mm as json));
select json_replace(@s, '$.v1.0', @mm); 
select json_extract(@s, '$.v2.0');
select json_extract(@s, '$."v2.0"');
set @v='{
"ver.name":"hello word",
"v1.cc":"cccccc"
}';
select json_extract(@v, '$.ver.name');
select json_extract(@v, '$."ver.name"');
select json_replace((select json_replace(@s, '/v1.0', @mm) as result), '/v1.0/null', @s);
select json_replace((select json_replace(@s, '$.v1.0', @mm) as result), '$.v1.0/null', @s);
select json_replace((select json_replace(@s, '/v1.0', cast(@mm as json)) as result), '/v1.0/name', cast(@s as json));    
drop table if exists t;
create table t(id int, name json);
set @ss='{
  "url": "http://qqe2.com",
  "name": "welcome to use json tool",
  "array": {
    "JSON check": "http://jsonlint.qqe2.com/",
    "Cro generate": "http://cron.qqe2.com/",
    "JS encode": "http://edit.qqe2.com/"
  },
  "boolean": true,
  "null": null,
  "number": 123,
  "object": {
    "a": "b",
    "c": "d",
    "e": "f"
  }
}';
update t set name = json_replace(name, '$', cast(@ss as json)) where name is null;
insert into t values(1, @ss);
select * from t;
update t set name = json_set(name, '$', cast(@ss as json));
select * from t;
select json_extract(json_replace(name, '$.number', 2), '$.number') from t;
update t set id=(select json_extract(json_replace(name, '$.number', 2), '$.number') from t);
select json_replace(name, '$', cast('{"url":"www.cubrid.com"}' as json)) from t;
select json_replace(name, '$', '{"url":"www.cubrid.com"}') from t;
drop table if exists t;
drop VARIABLE @ss;
drop VARIABLE @s;
drop VARIABLE @v;
drop VARIABLE @mm;


