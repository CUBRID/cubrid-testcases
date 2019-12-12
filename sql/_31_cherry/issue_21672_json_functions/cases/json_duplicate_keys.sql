select json_keys('{"a":{"c":1},"a":3, "c":2}');
select json_object('A', 1, 'A', 2);
SELECT JSON_OBJECT('key1', 1, 'key2', 'abc', 'key1', 'def');
SELECT JSON_EXTRACT(JSON_OBJECT('key1', 1, 'key2', 'abc', 'key1', 'def'), '/key1');
