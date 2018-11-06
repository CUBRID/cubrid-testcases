select json_set('"x"', '/0', '"a"');
select json_set('"x"', '$', '"a"');
select json_set('"x"', '$', 'a');
select json_keys('{"a": 1, "b": {"c": 30}}');
select json_type(json_keys('{"a": 1, "b": {"c": 30}}'));
select json_keys('{"a": 1, "b": {"c": 30}}', '$.b.c'),json_keys('{"a": 1, "b": {"c": 30}}', '$.b');
select json_keys('null');
select json_get_all_paths('{"a": 1, "b": {"c": 30}}');
select json_get_all_paths('["a", "b", {"a": 1, "b": 2, "c": {"d": 4}}]');
select json_get_all_paths(json_extract('{"a": 1, "b": {"c": 30}}','$.b'));
select json_object('a','b','c',1,'d',json_array('1','a')) as "json_object",
json_get_all_paths(json_object('a','b','c',1,'d',json_array('1','a'))) all_paths,
json_type(json_get_all_paths(json_object('a','b','c',1,'d',json_array('1','a')))) type,
json_length(json_get_all_paths(json_object('a','b','c',1,'d',json_array('1','a')))) length,
json_depth(json_get_all_paths(json_object('a','b','c',1,'d',json_array('1','a')))) as "depth";
select json_extract(json_get_all_paths(json_object('a','b','c',1,'d',json_array('1','a'))),'$[0]');

set @j = '["a", ["b", "c"], "d"]';
select json_keys(json_array_append(@j, '/1', '1','/0', '2', '/2', '4','/2/0', '5'));
select json_array_append(@j, '/1', '1','/0', '2', '/2', '3','/', '4');
select json_array_append(@j, '/1', '1','/0', '2', '/2', '3','', '4');
select json_array_append(@j, '/1', '1','/0', '2', '/2', '3','$', '4'); 
select json_array_append(@j, '/1', '1');
select json_array_append(@j, '/0', '2');
select json_array_append(@j, '/1/0', '3');
select json_array_append(@j, '/1', '1','/0', '2', '/1/0', '3');
select json_array_append(@j, '/1', '1','/0', '2', '/1/0', '3', '/1/0', '4');
--error
select json_array_append(@j, '/1', '1','/0', '2', '/3', '3', '/3/','"x"');
select json_array_append(@j, '/1', '1','$[0]', '2', '/2', '3');
select json_array_append(@j, '/1', '1','/0', '2', '/2', '{"aaa":"12344"}');
select json_array_append(@j, '/1', '1','/0', '2', '/2', '3','/', '4');
select json_array_append(@j, '/1', null);
select json_array_append(@j, '/0', '{"key":[9,8,"a"]}', '/0/1/key', '"x"');
select json_array_append(@j, '/0', cast('{"key":[9,8,"a"]}' as json), '/0/1/key', 'x');
set @j = null;
select json_array_append(@j, '/1', '1');
select json_array_append(@j, '/', null); 

SET @j = '{"a": 1, "b": [2, 3], "c": 4}';
select json_array_append(@j, '/', '"z"');
select json_array_append(@j, '', '"z"'); 
select json_array_append(@j, '$', '"z"'); 
select json_array_append(@j, '/b', '"x"');
select json_array_append(@j, '/c', '"y"');
select json_array_append(@j, '/b', '"x"','/b', '"x"');
select json_array_append(@j, '/b', '"x"','/b/2','"y"'); 


SET @j = '["a", {"b": [true, false]}, [10, 20]]';
select json_set(@j, '/1/b/0', '1', '/2/2', '2');
select json_insert(@j, '/1/b/0-', '1', '/2/2-', '2');
select json_insert(@j, '/1/b/-0', '1', '/2/2/-', '2');
select json_insert(@j, '/1/b/-', '1', '/2/-', '2');
select json_insert(@j, '/1/b/-', '1', '/2-', '2');
select json_replace(@j, '/1/b/0', '1', '/2/1', '2');
select json_replace(@j, '/1/b/0', '1', '/2', '2');
select json_replace(@j, '/1/b', '[1,2,3]', '/2', '2');
select json_replace(@j, '/1/b', '[1,2,3]', '/1/b/1', '"a"');
select json_replace(@j, '/1/b', cast('[1,2,3]' as json), '/1/b/1', 'a');

set @j = '{ "a": 1, "b": [2, 3]}';
--error
select json_replace(@j, '/a', '10', '/c', '[true, false]');
--error
SELECT json_replace(@j, '$.a', '10', '$.c', '[true, false]');
--error
select json_remove(@j, '/2', '/1/b/1', '/1/b/1');

drop table if exists json_test;
create table json_test(id int, emp json);  
insert into json_test values (1,'{
"programmers": [
    {"fName": "aa","lName": "ccc","email": "aaaa@aaa.aa"}, 
    {"fName": "bb","lName": "ccc","email": "bbbb@aaa.aa"}, 
    {"fName": "ee","lName": "eee","email": "cccc@aaa.aa"}],
"authors": [
    {"fName": "ff","lName": "fff","works": "sss@aaa.aa"},
    {"fName": "gg","lName": "ggg","works": "fff@aaa.aa"}, 
    {"fName": "ss","lName": "sss","works": "ccc@aaa.aa"}],
"musicians": [
    {"fName": "rr","lName": "rrr","songs": "gg@aaa.aa"}, 
    {"fName": "yy","lName": "yyy","songs": "pp@aaa.aa"}]}
');
select json_keys(emp) from json_test;
select json_keys(emp,'/authors') from json_test;
select json_keys(emp,'$.authors[1]') from json_test;
select json_get_all_paths(emp) from json_test;

select json_extract(authors,'/lName') name, authors,json_get_all_paths(authors) from (  
  select id,json_extract(emp,'/authors/0') authors from json_test  
  union all  
  select id,json_extract(emp,'/authors/1') authors from json_test  
  union all  
  select id,json_extract(emp,'/authors/2') authors from json_test  
) as t1 order by name desc;
select json_extract(authors,'/lName') name, authors,json_keys(authors)  from (  
   select id,json_extract(emp,'/authors/0') authors from json_test  
   union all  
   select id,json_extract(emp,'/authors/1') authors from json_test  
   union all  
   select id,json_extract(emp,'/authors/2') authors from json_test  
) as t1 order by name desc;

select  
  json_extract(authors,'/fName') fName,  
  json_extract(authors,'/lName') lName,  
  json_extract(authors,'/works') works
from (  
  select id,json_extract(emp,'/authors/0') authors from json_test  
) as t;

update json_test set emp = json_remove(emp,'/authors');
select * from json_test; 
drop table if exists json_test;
drop VARIABLE @j;
