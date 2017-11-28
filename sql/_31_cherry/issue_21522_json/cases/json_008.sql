

select json_contains('{"k1":123, "k2":345}', '123', '/k1');
select json_contains('"you"', '"you"');
select json_contains('"youth"', '"you"');
select json_contains('[1]', '[1]', '/', '/0');
select json_contains('', '', '');
select json_contains('null', 'null', '');
select json_contains('"null"', '"null"', '');
select json_contains('"10"', '"10"', '');
select json_contains('"10"', '10', '');
select json_contains('10.1', '10', '');
select json_contains('"10.0"', '"10"', '');
select json_contains('10.0', '10', ''), json_type('10.0'),json_type('10');

select json_contains('[1]', '1');
select json_contains('[2, 1]', '1');
select json_contains('[2, [2, 3], 1]', '1');
select json_contains('[4, [2, 3], 1]', '2');
select json_contains('[2, 1]', '[1, 2]');
select json_contains('[2, 1]', '[1, 0, 2]');
select json_contains('[2, 0, 3, 1]', '[1, 2]');
select json_contains('{"b":[1,2], "a":1}', '{"a":1, "b":2}');
select json_contains('{"a":1}', '{}');
select json_contains('[1, {"a":1}]', '{}');
select json_contains('[1, {"a":1}]', '{"a":1}');
select json_contains('[{"abc":"def", "def":"abc"}]', '["foo","bar"]');
select json_contains('[{"abc":"def", "def":"abc"}, "bar"]', '["bar", {}]');
select json_contains('[{"a":"b"},{"c":"d"}]','{"c":"d"}');

select json_extract('{"key1":"asd", "key2":[2,3]}', '/key1');
select json_extract('{"key1":"asd", "key2":[2,3]}', '/keyX', '/keyY');
select json_extract('{"key1":"asd", "key2":[2,3]}', '/key1', '/key2');
select json_extract('{"key1":"asd", "key2":[2,3]}', '/key1');
select json_extract('{"key1":"asd", "key2":[2,3]}', '/key2');
select json_extract('{"key1":5, "key2":[2,3]}', '/key1');
select json_extract('{"key0":true, "key1":"qwe"}', '/key1');
select json_extract(json_object('foo', 'foobar'),'');
select json_extract('[10, 20, [30, 40]]', '/2');
select json_extract('[10, 20, [{"a":3}, 30, 40]]', '/2');
select json_extract('1', '');
select json_extract('[10, 20, [30, 40], 1, 10]', '/1');
select json_extract('[10, 20, [30, 40], 1, 10]', '/2/1');
select json_extract( '[{"a": [3, 4]}, {"b": 2}]', '/1/a');
select json_extract( '[{"a": [3, 4]}, {"b": 2}]', '/0/a');

