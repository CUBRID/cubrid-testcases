select json_array_append('["a", "b"]', '$', 'false');
select json_array_append('{"k1":1, "k2":["a", "b"]}', '$.k2', '2');
select json_array_append('["a", ["b", "c"], "d"]', '$[0]', '2');

--error
select json_contains('[1]', '[1]', '$', '$[0]');
--error
select json_contains('', '', '$');
--result is different with MySQL
select json_contains('null', 'null', '$');  
select json_contains('"10"', '"10"', '$');
select json_contains('"10"', '10', '$');
select json_contains('10.1', '10', '$');
select json_contains('10.0', '10', '$');

select json_extract('{"key1":"asd", "key2":[2,3]}', '$.key1');
--error
select json_extract('{"key1":"asd", "key2":[2,3]}', '$.keyX');
select json_extract('{"key1":"asd", "key2":[2,3]}', '$.key1', '$.key2');
select json_extract('{"key0":true, "key1":"qwe"}', '$.key1');
select json_extract(json_object('foo', 'foobar'),'$');
--error
select json_extract('[10, 20, [30, 40]]', '$[2][*]');
--error
select json_extract('[10, 20, [{"a":3}, 30, 40]]', '$[2][*]');
select json_extract('1', '$');
select json_extract('[10, 20, [30, 40], 1, 10]', '$[1]');
select json_extract( '[{"a": [3, 4]}, {"b": 2}]', '$[0].a');
select json_extract( '[{"a": [3, 4]}, {"b": 2}]', '$[1].a');

select json_insert('{"a":1, "b":{"c":1}, "d":[1, 2]}', '$.b.k1', '"word"');
select json_insert('{"a":1, "b":{"c":1}, "d":[1, 2]}', '$.d[3]', '3');
select json_insert('{"a":1, "b":{"c":1}, "d":[1, 2]}', '$.a[2]', '2');
select json_insert('{"a":1, "b":{"c":1}, "d":[1, 2]}', '$.b.c', '"word"');

--error
select json_replace('{ "a": 1, "b": [2, 3]}', '$.a', '10', '$.c', '[true, false]');
select json_replace('{ "a": 1, "b": [2, 3]}', '$.a', '10', '$.b', '[true, false]');
select json_set('{ "a": 1, "b": [2, 3]}', '$.a', '10', '$.c', '[true, false]');

set @j = '["a", ["b", "c"], "d"]';
select json_remove(@j, '$[0]');
select json_remove(@j, '$[1]');
select json_remove(@j, '$[2]');

set @j = '{"a": 1, "b": [2, 3]}';
select json_remove(@j, '$.b');
select json_remove(@j, '$.a');
--CBRD-22651 #2
select json_object();
select json_object("ki", 1, "mi", "ya");

select json_keys('{"a":{"c":1, "d":2}, "b":2}');
select json_keys('{"a":{"c":1, "d":2}, "b":2}', '$.a');
select json_keys('{"a":{"c":1, "d":2}, "b":2}', '$.b');
select json_keys('foo');
select json_keys('{"a":{"c":1, "d":2}, "b":2, "c":1, "a":3, "b":1, "c":2}');
select json_keys('{"c1": "value 1", "c1": "value 2"}');
select json_keys('[{"c1": "value 1"}, {"c1": "value 2"}]');

--error
select json_length( '[ 1, [ 2, 3, 4 ], 5 ]', '$[2]' );

SELECT JSON_SET('{}', '$.age', '87');

select json_set('{"a":12}', '$[0]', '100');  
select json_set('{"a":12}', '$[0].a', '100'); 
select json_set('{"a":12}', '$[0][0].a', '100');
select json_set('{"a":12}', '$[0][1].a', '100');

select json_extract( '[1]', '$[0][0]' );
select json_extract( '[1]', '$[1][0]' );
select json_extract( '[1]', '$**[0]' );
--CBRD-22651 #4
select json_extract( '[1]', '$**[0][0]' );

select json_extract('1', '$');
select json_extract('1', '$[0]');
select json_extract('1', '/');
select json_extract('1', '');
select json_extract('1', '/0');

select json_insert('1', '$', '4');
select json_insert('1', '$[0]', '4');
select json_insert('1', '/', '4');
select json_insert('1', '', '4');
select json_insert('1', '/0', '4');

select json_set('1', '$', '4'); 
select json_set('1', '$[0]', '4');
select json_set('1', '/', '4');    
select json_set('1', '', '4');    
select json_set('1', '/0', '4');  

select json_replace('1', '$', '4');
select json_replace('1', '$[0]', '4'); 
select json_replace('1', '/', '4');    
select json_replace('1', '', '4');    
select json_replace('1', '/0', '4');   

select json_set('1', '$[1]', '4');  
select json_replace('1', '$[1]', '4');  
SELECT json_insert('[]', '$[0][0]', '100');
SELECT json_insert('1', '$[0][0]', '100');
SELECT json_replace('1', '$[0][0]', '100');
SELECT json_replace('[]', '$[0][0]', '100');
SELECT json_set('[]', '$[0][0]', '100');
SELECT json_set('[]', '$[0][0][0]', '100');

drop table if exists t1;
create table t1 as select json_object('id', 87, 'name', 'carrot') as f;
show create table t1;
select * from t1;

drop table if exists t1;
create table t1(a double not null);
insert into t1 values (2),(1);
select 1 from t1 where json_extract(a,'$','$[81]');
select 1 from t1 where json_extract(a,'$[81]');
select json_extract(a,'$'),json_extract(a,'$[81]'), json_type(a) from t1 order by 1;


drop table if exists t1;
create table t1(j string, p string, i int);
insert into t1 values
    ('{"a":1,"b":2,"c":3}','$.a',0),
    ('{"a":1,"b":2,"c":3}','$.b',0),
      ('{"a":1,"b":2,"c":3}','$.c',0);
select j, p, json_remove(j, p) from t1;
SELECT JSON_KEYS(j) FROM t1 ORDER BY 1;
SELECT JSON_KEYS(p) FROM t1 ORDER BY 1;
SELECT JSON_KEYS(i) FROM t1 ORDER BY 1;
SELECT JSON_valid(i) FROM t1 ;
SELECT JSON_valid(i) FROM t1 ;
SELECT json_type(cast(i as json)) FROM t1 ;
SELECT json_type(cast(i as json)) FROM t1 ;
SELECT json_get_all_paths(cast (i as json)) FROM t1 ;
SELECT json_keys(cast (i as json)) FROM t1 ;
drop table if exists t1;

SELECT JSON_EXTRACT( '{"foo":"bar"}', '$[*].*' );
SELECT JSON_EXTRACT( '{"foo":"bar"}', '$[*]' );
select JSON_EXTRACT('{"name":"value"}', '$.name') , JSON_EXTRACT('{"name":"value"}', '$.name') = '"value"';
select JSON_EXTRACT('{"asdf":true}', '$.asdf'), JSON_EXTRACT('{"asdf":true}', '$.asdf') = 'true';
select JSON_EXTRACT('{"asdf":true}', '$.asdf'), JSON_EXTRACT('{"asdf":true}', '$.asdf') = 'false';
select JSON_EXTRACT('{"asdf":true}', '$.asdf'), JSON_EXTRACT('{"asdf":true}', '$.asdf') = '1';
select JSON_EXTRACT('{"asdf":true}', '$.asdf'), JSON_EXTRACT('{"asdf":true}', '$.asdf') = 1;
select JSON_EXTRACT('{"input1":"\u00f6"}', '$.input1'); 
select JSON_EXTRACT('{"input1":"\\u00f6"}', '$.input1');

--error 
select JSON_EXTRACT('{"foo": "bar" foobar foo invalid ', '$.foo');
select JSON_EXTRACT('{"foo": "\"bar\" foobar foo invalid "}', '$.foo');
select cast( JSON_EXTRACT('{"foo": "\"bar\" foobar foo invalid "}', '$.foo') as string);

SELECT JSON_OBJECT('foo', '`');
SELECT JSON_OBJECT('foo', 'bar`bar');

set @str = '{"\u00e4\u00f6":"yes"}';
set @path = '$."\u00e4\u00f6"';
select @str, json_get_all_paths(@str);
select @str, json_keys(@str);
select @str, @path, JSON_EXTRACT(@str, JSON_EXTRACT(json_get_all_paths(@str), '/0'));
select @str, @path, JSON_EXTRACT(@str, JSON_EXTRACT(json_get_all_paths(@str), '/1'));

set @str = '{"\u00e4":"yes"}';
set @path = '$."\u00e4"';
select @str, @path, JSON_EXTRACT(@str, @path);
select @str, json_get_all_paths(@str);
select @str, json_keys(@str);


SELECT JSON_ARRAY('1. ě 2. š 3. č 4. ř 5. ž 6. ý 7. á 8. í 9. é 10. ů 11. ú') AS json_data;
SELECT JSON_OBJECT('user','Jožko Mrkvičká') as json_data;

select JSON_VALID(0x36f0c8dccd83c5eac156da);

SELECT JSON_VALID('{"id": 1, "name": "Monty"}') AS json_valid;
SELECT JSON_CONTAINS('{"A": 0, "B": {"C": 1}, "D": 2}', '2', '$.A') AS json_contains;
drop VARIABLE @j, @str, @path;
