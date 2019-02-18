
select json_array_append('[             ]', '$', '"aue"');
SELECT JSON_MERGE('[1]', '[]');
SELECT JSON_MERGE_PRESERVE('[1]', '[]');
SELECT JSON_MERGE_PATCH('[1]', '[]');
select json_quote('"string"');

drop table if exists t1;
create table t1 as select json_quote('foo');
select * from t1;
show create table t1;
drop table t1;

select json_array_insert('["a", {"b": [1, 2]}, [3, 4]]', '$[1]', '"x"');
select json_array_insert('["a", {"b": [1, 2]}, [3, 4]]', '$[2]', '"x"');
select json_array_insert('["a", {"b": [1, 2]}, [3, 4]]', '$[3]', '"x"');
--http://jira.cubrid.org/browse/CBRD-22539 (by design) 
select json_array_insert('["a", {"b": [1, 2]}, [3, 4]]', '$[4]', '"x"');
select json_array_insert('["a", {"b": [1, 2]}, [3, 4]]', '$[1].b[0]', '"x"');
select json_array_insert('true', '$', 1);

--http://jira.cubrid.org/browse/CBRD-22453 (fix)
select json_array_insert('true', '$', '1');

select json_array_insert('["a", {"b": [1, 2]}, [3, 4]]', '$[2][1]', '"y"');

--http://jira.cubrid.org/browse/CBRD-22452 (fix)
--http://jira.cubrid.org/browse/CBRD-22518 (fix)
select json_contains_path('{"foo":"bar"}', 'one', '$[]');
select json_contains_path('{"key1":1, "key2":[2,3]}', 'oNE', '$.key2[1]');
select json_contains_path('{"key1":1, "key2":[2,3]}', 'oNE', '$.key2[10]');
select json_contains_path('{"key1":1, "key2":[2,3]}', 'oNE', '$.ma');
select json_contains_path('{"key1":1, "key2":[2,3]}', 'one', '$.key1');
select json_contains_path('{"key1":1, "key2":[2,3]}', 'one', '$.key1', '$.ma');
select json_contains_path('{"key1":1, "key2":[2,3]}', 'aLl', '$.key1', '$.ma');
select json_contains_path('{"key1":1, "key2":[2,3]}', 'aLl', '$.key1', '$.key2');
select json_contains_path('{ "a": true }', NULL, '$.a' );
select json_contains_path('{ "a": true }', 'all', NULL );

--http://jira.cubrid.org/browse/CBRD-22540 (fix)
select json_contains_path('{"a":{"b":"c"}}', 'one', '$.a.*');
select json_contains_path('{"a":[{"c":[1,{"a":[0,1,2]},3]}], "b":[1,2,3]}', 'one', "$**.a[2]");
select json_contains_path('{"a":[{"c":[1,{"a":[0,1,2]},3]}], "b":[1,2,3]}', 'one', "$**.a[3]");
select json_contains_path('{"a":[{"c":[1,{"a":[0,1,2]},3]}], "b":[1,2,3]}', 'one', '$**.a[2]');
select json_contains_path('{"a":[{"c":[1,{"a":[0,1,2]},3]}], "b":[1,2,3]}', 'one', '$**.a[3]');

--http://jira.cubrid.org/browse/CBRD-22452 (fix)
select json_search('["A", [{"B": "1"}], {"C": "AB"}, {"D": "BC"}]', 'one', 'AB');
SET @`json` := '["A", [{"B": "1"}], {"C": "AB"}, {"D": "BC"}]', @`value` := 'AB';
SELECT json_search(@`json`, 'one', @`value`);
drop variable @`json` , @`value`;

SELECT json_search( '{"": "a"}', '"one"', 'a');
--http://jira.cubrid.org/browse/CBRD-22544 (fix)
SELECT json_search( '{"": "a"}', 'one', 'a');
SELECT JSON_EXTRACT('{"": "a"}', '$.');
SELECT JSON_EXTRACT('{"": "a"}', '$.\"\"');
set system parameters 'no_backslash_escapes=no'; 
SELECT JSON_EXTRACT('{"": "a"}', '$.\"\"');
set system parameters 'no_backslash_escapes=yes'; 

SET @j = '["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]';
select json_search(@j, 'one', 'abc');
select json_search(@j, 'all', 'abc');
select json_unquote(json_search(@j, 'all', 'abc'));

select typeof(json_search(@j, 'all', 'abc'));
select typeof(json_unquote(json_search(@j, 'all', 'abc')));

select json_search(@j, 'all', 'abc', NULL, '$[2]');
select json_search(@j, 'all', 'abc', NULL, '$');
select json_search(@j, 'all', '10', NULL, '$');

drop table if exists t1;
create table t1( json_col string );
insert into t1 values
('{ "a": "foobar" }'),
('{ "a": "foobar", "b": "focus", "c": [ "arm", "foot", "shoulder" ] }');
select json_search( json_col, 'all', 'foot' ) from t1 order by 1;
drop table t1;


SET @str = 'bar', @path = '$';
SELECT json_search('{"foo":"bar"}', 'all' , @str, '%', @path);

select json_unquote('"abc"');
--http://jira.cubrid.org/browse/CBRD-22545 (by design)
select json_unquote('abc');

drop table if exists t1;
create table t1( s varchar(10), d json );
insert into t1 values ('"abc"','"abc"');
insert into t1 values ('abc','abc');
insert into t1 values ('abc',null);
insert into t1 values ('"abc"','""');
select s, d, json_unquote(d) from t1 order by 1,2 desc,3 desc;

drop table if exists t1;
drop variable @str, @path, @j;
