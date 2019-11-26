--+ holdcas on;
select json_length(json_array('a', 'b', 'c', json_object('a', 'b')));
select json_length(json_object('a', 'b', 'c', 'd'));
select json_length('123');

select json_depth(json_array('a', json_array('b', json_object('a', 'b'))));
select json_depth(json_array('a')), json_depth('["a"]');
select json_depth(1);
select json_depth(json_array('a')), json_depth(json_object('a','b'));  

select json_type('123');
select json_type('123.32');
select json_type('{"a":"b"}');
select json_type('["a"]');
select json_type('"a"');

select json_extract(json_object('a','b'), '/a');
select json_extract(json_array('a', json_array('b', json_object('a', 'b'))), '/1/1/a');
select json_extract(json_array('a', json_array('b', json_object('a', 'b'))), '/1/2/a');

select json_extract(json_array(1, 2, 123), '/0') < json_extract(json_array(1, 2, 123), '/2');
select json_extract(json_array(1, 2, 123), '/0') > json_extract(json_array(1, 2, 123), '/2');

select json_insert(json_object('a', json_array('b', 'c')), '/a/-', 'd');
select json_insert(json_object('a', json_array('b', 'c')), '/a/', 'd', '/d', json_object('aaa', '123'), '/c', 123, '/b', 345, '/a/', '0');
select json_insert(json_object('a', json_array('b', 'c')), '/a', 'd', '/d', json_object('aaa', '123'), '/c', 123, '/b', 345, '/a', '0');

select json_remove(json_array('a', 'b', 'c','d','e'), '/1', '/3');
select json_remove(json_insert(json_object('a', json_array('b', 'c')), '/a/', '"d"', '/d', json_object('aaa', '123'), '/c', '123', '/b', '345', '/a/', '0'), '/c','/d/aaa','/a/0');

drop table if exists t1;
create table t1 (a char(10), b json);
insert into t1 values ('a', '{"a":"b"}');
select concat (a,repeat(b,10),b,b,json_extract(b,'/a')) from t1;
select @a:= repeat('a',1024) ;
select json_object('a', cast(@a as varchar), a, cast ( b as varchar) ) from t1;
drop table if exists t1;
deallocate variable @a;


--+ holdcas off;
