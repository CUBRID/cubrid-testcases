set @j = '["a", ["b", "c"], "d"]';
select json_remove(@j, '/0');
select json_remove(@j, '/1');
select json_remove(@j, '/2');
set @j = '{"a": 1, "b": [2, 3]}';
select json_remove(@j, '/b');
select json_remove(@j, '/a');
deallocate variable @j;

select json_merge('"string"');
select json_merge('"string"', 123);
select json_merge('"string"', '123');
select json_merge ( '"string"', cast(123 as json) );
select json_merge('[1, 2]', '[true, false]');
select json_merge('{"1": 2}', '{"true": false}');
select json_merge('{"1": 2}', '{"true": false}', '{"3": 4}');
select json_merge(NULL,json_object('foo', 1));
select json_merge('a','b');
select json_merge('"a"','"b"');
select json_merge('{"a":"b"}','{"c":"d"}');
SELECT JSON_MERGE('[1, 2]', '{"id": 47}');
select json_merge('{"a":"b"}', '{"a":"c"}') ;
select json_merge('{"a":{"x":"b"}}', '{"a":"c"}') ;
select json_merge('{"a":{"u":12, "x":"b"}}', '{"a":{"x":"c"}}') ;
select json_merge('{"a":{"u":12, "x":"b", "r":1}}', '{"a":{"x":"c", "r":2}}') ;

select json_type('{"k1":123, "k2":345}');
select json_type('[123, "k2", 345]');
select json_type('"true"');
select json_type('123');
select json_type('123.12');
select json_type(sys_datetime);

select json_object('a', json_object('b', 'abcd'));
select json_object('a', '{"b": "abcd"}');
select json_object('a', json_array('{"b": "abcd"}'));

select json_depth('[[], {}]'),json_extract('[[], {}]','/0'),json_extract('[[], {}]','/1');
select json_depth('[[[1,2,3],"s"], {}, []]');
select json_depth('[10, {"a": 20}]');

select json_length('');
select json_length('{}');
select json_length('[1, 2, {"a": 3}]');
select json_length(json_extract('{"a": 1, "b": {"c": 30}}', '/b'));
select json_length('{"a": 1, "b": {"c": 30}}');
select json_length('{}{');
select json_length(json_extract( '[ 1, [ 2, 3, 4 ], 5 ]', '/1' ));
select json_length(json_extract( '[ 1, [ 2, 3, 4 ], 5 ]', '/1/0' )); 
select json_length(json_extract( '[ 1, [ 2, 3, 4 ], 5 ]', '/2/0/0/' ));
select json_length(json_extract( '[ 1, [ 2, 3, 4 ], {"a":5, "b":6} ]', '/1' )); 
select json_length(json_extract( '[ 1, [ 2, 3, 4 ], {"a":5, "b":6} ]', '/1/0' )); 
select json_length(json_extract( '[ 1, [ 2, 3, 4 ], {"a":5, "b":6} ]', '/2' ));
select json_length(json_extract( '[ 1, [ 2, 3, 4 ], {"a":5, "b":6} ]', '/2/a' ));
select json_length(json_extract( '[ 1, [ 2, 3, 4 ], {"a":5, "b":6} ]', '/2/a/0/0' ));
select json_length(json_extract( '{"a":{"b":{"d":1}}, "a":{"c":{"d":1, "j":2}}}', '/a/0/0/0/c' ));

select json_extract( '[1]', '/' );
select json_extract( '[1]', '/0/' );
select json_extract( '[1]', '/0' );
select json_extract( '[1]', '.' );

SELECT json_insert('[]', '/0', '100');   
SELECT json_insert('1', '/0/0/', '100');
SELECT json_insert('1', '/1', '100');    

select json_array(repeat('a',1024),repeat('a',1024));
select json_object("a", cast ( repeat('a',1024) as char (2000),"b", cast( repeat('a',1024) as char(2000) );
select JSON_VALID(0x36f0c8dccd83c5eac156da);

select cast('{a:1}' as text);
select cast('{a:1}' as json);
select cast('{"a":1}' as json);  
