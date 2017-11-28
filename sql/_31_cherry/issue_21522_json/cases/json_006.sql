select json_valid('[1, 2]');
select json_valid('"string"}');
select json_valid('{"key1":1, "key2":[2,3]}');
select json_valid('[false, true, null]');
select json_valid(repeat('[', 1000));
select json_valid(repeat('{"a":', 1000));

select json_array();
select json_array(1);
select json_array('1');
select json_array(1, "text", false, null);
select json_array('1', '"text"', 'false', 'null');
select json_array(1, '"text"', false, null);  

select json_insert('["a", {"b": [1, 2]}, [3, 4]]', '/1-', '"x"');
select json_insert('["a", {"b": [1, 2]}, [3, 4]]', '/2/', '"x"');
select json_insert('["a", {"b": [1, 2]}, [3, 4]]', '/3', '"x"');
select json_insert('["a", {"b": [1, 2]}, [3, 4]]', '/4', '"x"');
select json_insert('["a", {"b": [1, 2]}, [3, 4]]', '/1/b/0/', '"x"');
select json_insert('true', '/', '1');
select json_insert('["a", {"b": [1, 2]}, [3, 4]]', '/2/1/', '"y"');

select json_insert('{"a":1, "b":{"c":1}, "d":[1, 2]}', '/b/k/1', 'word');
select json_insert('{"a":1, "b":{"c":1}, "d":[1, 2]}', '/d/3', '3');
select json_insert('{"a":1, "b":{"c":1}, "d":[1, 2]}', '/a/2', '2');  
select json_insert('{"a":1, "b":{"c":1}, "d":[1, 2]}', '/b/c/', '"word"'); 
