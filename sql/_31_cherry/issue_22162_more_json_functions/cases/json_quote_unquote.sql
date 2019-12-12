--+ holdcas on;
-- https://database.guide/json_quote-how-to-escape-characters-in-strings-used-as-json-values-in-mysql/

SELECT JSON_ARRAY('Hot', 'Warm', 'Cold') ; 
SELECT JSON_QUOTE('"Hot","Warm","Cold"') ; 
SELECT JSON_QUOTE(JSON_ARRAY('Hot', 'Warm', 'Cold')) ; 

SELECT JSON_ARRAY(1, 2, 3) ; 
SELECT JSON_QUOTE('[1,2,3]') ; 
SELECT JSON_QUOTE(JSON_ARRAY(1, 2, 3)) ; 

SELECT JSON_ARRAY(JSON_QUOTE('[1, 2, 3]'), 8, 9);
SELECT JSON_QUOTE(JSON_ARRAY(JSON_QUOTE('[1, 2, 3]'), 8, 9));

SELECT JSON_OBJECT('Key', JSON_QUOTE('[1,2,3]')) ; 
SELECT JSON_OBJECT('Key', JSON_QUOTE(JSON_ARRAY(1, 2, 3))) ; 
SELECT JSON_OBJECT('Key', JSON_QUOTE(JSON_ARRAY('Hot', 'Warm', 'Cold'))) ; 

SET @jv1 = JSON_ARRAY(1,2,3);
SELECT @jv1 , JSON_EXTRACT(@jv1, '$[0]');

SET @jv2 = JSON_ARRAY(JSON_QUOTE('[1, 2, 3]'));
SELECT @jv2, JSON_EXTRACT(@jv2, '$[0]');
 
drop variable @jv1,@jv2 ;
 
-- https://database.guide/json_unquote-remove-quotes-from-a-json-document-in-mysql/
SET @jv = '"Homer Simpson"';
--CBRD-22457  
SELECT @jv , JSON_UNQUOTE(@jv);

SET @jv = '"Homer \t Simpson"';
SELECT @jv , JSON_UNQUOTE(@jv);

SET @jv = '"Homer \\t Simpson"';
SELECT @jv , JSON_UNQUOTE(@jv);

SET SYSTEM PARAMETERS 'no_backslash_escapes=no';
SET @jv = '"Homer \t Simpson"';
SELECT @jv , JSON_UNQUOTE(@jv);

SET @jv = '"Homer \\t Simpson"';
SELECT @jv , JSON_UNQUOTE(@jv);
 
SET SYSTEM PARAMETERS 'no_backslash_escapes=yes';
drop variable @jv1,@jv2,@jv ;

-- https://dev.mysql.com/doc/refman/8.0/en/json-creation-functions.html#function_json-quote
SELECT JSON_QUOTE('null'), JSON_QUOTE('"null"');
SET @j = '[1, 2, 3]';
SELECT @j, JSON_UNQUOTE(@j);
SELECT JSON_UNQUOTE('"\t\u0032"');
SELECT JSON_UNQUOTE('"\\t\\u0032"');
SET SYSTEM PARAMETERS 'no_backslash_escapes=no';
SELECT JSON_UNQUOTE('"\\t\\u0032"');
SET SYSTEM PARAMETERS 'no_backslash_escapes=yes';
drop variable @j ;



--+ holdcas off;
