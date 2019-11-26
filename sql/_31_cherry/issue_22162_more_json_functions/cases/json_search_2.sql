--+ holdcas on;

--CBRD-22486 
SELECT JSON_SEARCH('"abc"', 'one', 'abc', '','');

-- CBRD-22488 
SET @j = '["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]';
SELECT JSON_SEARCH(@j, 'all', '%b%', '', '$');
SELECT JSON_SEARCH(@j, 'all', '%b%', '', '$[1]');
SELECT JSON_SEARCH(@j, 'all', '%b%', '', '$[2]');
SELECT JSON_SEARCH(@j, 'all', '_b%', '', '$');
SELECT JSON_SEARCH(@j, 'all', '_b%', '', '$[1]');
SELECT JSON_SEARCH(@j, 'all', '_b%', '', '$[2]');
SELECT JSON_SEARCH(@j, 'all', 'b__', '', '$');
SELECT JSON_SEARCH(@j, 'all', 'b__', '', '$[1]');
SELECT JSON_SEARCH(@j, 'all', 'b__', '', '$[3]');

SELECT JSON_SEARCH(@j, 'all', '%b%', NULL, '$');
SELECT JSON_SEARCH(@j, 'all', '%b%', NULL, '$[1]');
SELECT JSON_SEARCH(@j, 'all', '%b%', NULL, '$[2]');
SELECT JSON_SEARCH(@j, 'all', '_b%', NULL, '$');
SELECT JSON_SEARCH(@j, 'all', '_b%', NULL, '$[1]');
SELECT JSON_SEARCH(@j, 'all', '_b%', NULL, '$[2]');
SELECT JSON_SEARCH(@j, 'all', 'b__', NULL, '$');
SELECT JSON_SEARCH(@j, 'all', 'b__', NULL, '$[1]');
SELECT JSON_SEARCH(@j, 'all', 'b__', NULL, '$[3]');

SELECT 'David_' LIKE 'David_' ESCAPE '';

--CBRD-22539
select json_array_insert('["a","b"]', '$[4]', 'x');

--CBRD-22490
SET @j = '["abc", [{"k": 10}, "def"], {"x":"abc"}, {"y":"bcd"}]';
SELECT JSON_SEARCH(@j, 'onee', 'abc');

drop variable @j;


--+ holdcas off;
