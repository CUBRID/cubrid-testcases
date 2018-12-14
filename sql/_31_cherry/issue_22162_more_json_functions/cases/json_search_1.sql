set @jdoc='{"A":"a", "B":["b","c"]}';
select json_search(@jdoc, 'one', 'c');

set @jdoc='{"A":"a", "B":["b","a","c"]}'; 
select json_search(@jdoc, 'one', 'a');

--CBRD-22452
SELECT JSON_SEARCH('{"Name": "Bart", "Age": 10}', 'one', 'Bart') ; 

SET @doc = '{"Name": "Bart", "Hobbies": ["Skateboarding", "Mischief"]}';
--CBRD-22473
SELECT JSON_SEARCH(@doc, 'one', 'Mischief') ; 
SELECT JSON_SEARCH(@doc, 'one', 'Homer') ; 
SELECT JSON_SEARCH(@doc, 'one', 'Skate%') ; 
SELECT JSON_SEARCH(@doc, 'one', 'Skate_') ; 
--CBRD-22482
SELECT JSON_SEARCH(@doc, 'one', 'Bar_') ; 

SET @doc = '{"Name": "Bart", "Friends": ["Bart", "Milhouse"]}';
--CBRD-22482
SELECT JSON_SEARCH(@doc, 'one', 'Bart') ; 
SELECT JSON_SEARCH(@doc, 'all', 'Bart') ; 

SET @doc = '{"userid": "bart_simpson", "pwd1": "pass%word", "pwd2": "pass%BLAH-BLAH-BLAH-word"}';
SELECT JSON_SEARCH(@doc, 'all', 'pass%word') ;
SELECT JSON_SEARCH(@doc, 'all', 'pass\%word') ;
SELECT JSON_SEARCH(@doc, 'all', 'pass\%word', '\') ;
SELECT JSON_SEARCH(@doc, 'one', 'bart_simpson')  ;
SELECT JSON_SEARCH(@doc, 'all', 'bart\_simpson');
SELECT JSON_SEARCH(@doc, 'all', 'bart\_simpson','\');

SET @jv = '{  
    "Person": {    
       "Name": "Bart", 
       "Age": 10,
       "Friends": ["Bart", "Milhouse"]  
    }
 }';
SELECT JSON_SEARCH(@jv, 'all', 'Bart', NULL, '$.Person.Friends') ; 
SELECT JSON_SEARCH(@jv, 'all', 'Bart') ; 
--CBRD-22482
SELECT JSON_SEARCH(@jv, 'one', 'Bart') ; 
SELECT JSON_SEARCH('{}', 'all', 'Bart') ; 

SET @j = '["abc", [{"k": 10}, "def"], {"x":"abc"}, {"y":"bcd"}, {"e":"-"}]';
SELECT JSON_SEARCH(@j, 'all', 'ab-', '-', '$' );

SET @j = '["abc", [{"k": 10}, "def"], {"x":"abc"}, {"y":"bcd"}]';
SELECT JSON_SEARCH(@jj, 'all', '10');   
SELECT JSON_SEARCH(NULL, 'all', '10');   
SELECT JSON_SEARCH(@j, NULL, '10');   
SELECT JSON_SEARCH(@j, 'all', NULL);   
SELECT JSON_SEARCH(@j, 'all', 10);
--CBRD-22483
SELECT JSON_SEARCH(@j, 'ALL', '10');   
SELECT JSON_SEARCH(@j, 'ONE', '10');   
--CBRD-22485
SELECT JSON_SEARCH(@j, 'all', 'abc', 'def');
SELECT JSON_SEARCH(@j, 'all', 'abc', NULL, '$.k' );
SELECT JSON_SEARCH(@j, 'all', 'abcdef' );

SELECT JSON_SEARCH('abc', 'one', 'abc');
SELECT JSON_SEARCH('"abc"', 'one', 'abc');
--CBRD-22485
SELECT JSON_SEARCH('"abc"', 'one', 'abc', '.');
-- CBRD-22651, CBRD-22488
SELECT JSON_SEARCH('"abc"', 'one', 'abc', '','$[1]');
SELECT JSON_SEARCH('["abc","abc"]', 'one', 'abc', '','$[1]');
SELECT JSON_SEARCH('["abc","abc"]', 'one', 'abc', null,'$[1]');
SELECT JSON_SEARCH('["abc","abc"]', 'one', 'abc', NULL,'$[1]');

SET @j = '["abc", [{"k": "10"}, "def"], {"x":"abc"}, {"y":"bcd"}]';
SELECT JSON_SEARCH(@j, 'one', 'abc');
SELECT JSON_SEARCH(@j, 'one', 'abc');
SELECT JSON_SEARCH(@j, 'all', 'abc');
SELECT JSON_SEARCH(@j, 'all', 'ghi');
SELECT JSON_SEARCH(@j, 'all', '10');
SELECT JSON_SEARCH(@j, 'all', '10', NULL, '$');
SELECT JSON_SEARCH(@j, 'all', '10', NULL, '$[1]');
SELECT JSON_SEARCH(@j, 'all', '10', NULL, '$[1][0]');
SELECT JSON_SEARCH(@j, 'all', 'abc', NULL, '$[2]');
SELECT JSON_SEARCH(@j, 'all', '%a%');
SELECT JSON_SEARCH(@j, 'all', '%b%');
SELECT JSON_SEARCH(@j, 'all', '%b%', NULL, '$[0]');
SELECT JSON_SEARCH(@j, 'all', '%b%', NULL, '$[2]');
SELECT JSON_SEARCH(@j, 'all', '%b%', NULL, '$[1]');
SELECT JSON_SEARCH(@j, 'all', '%b%', NULL, '$[3]');
SELECT JSON_SEARCH(@j, 'all', '%b%', '', '$[3]');
-- CBRD-22487
SELECT JSON_SEARCH(@j, 'all', '10', NULL, '$[*]');
-- CBRD-22487
SELECT JSON_SEARCH(@j, 'all', '10', NULL, '$**.k');
-- CBRD-22487
SELECT JSON_SEARCH(@j, 'all', '10', NULL, '$[*][0].k');

SELECT JSON_SEARCH(@j, 'all', '%b%', NULL, '$');

drop variable @jv, @doc, @j, @jdoc;

