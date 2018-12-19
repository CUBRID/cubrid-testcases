drop table if exists json_arrayagg;
create table json_arrayagg (
 json_array varchar,
 json_array_append varchar,
 json_array_insert varchar,
 json_contains varchar,
 json_contains_path varchar,
 json_depth varchar,
 json_extract varchar,
 json_get_all_paths varchar,
 json_insert varchar,
 json_keys varchar,
 json_length varchar,
 json_merge varchar,
 json_merge_patch varchar,
 json_merge_preserve varchar,
 json_objectagg varchar,
 json_object varchar,
 json_pretty varchar,
 json_quote varchar,
 json_remove varchar,
 json_replace varchar,
 json_search varchar,
 json_set varchar,
 json_table varchar,
 json_type varchar,
 json_unquote varchar,
 json_valid varchar
);

drop table if exists json_arrayagg;
create table json_arrayagg (
 i int, 
 json_array varchar,
 json_array_append varchar,
 json_array_insert varchar,
 json_contains varchar,
 json_contains_path varchar,
 json_depth varchar,
 json_extract varchar,
 json_get_all_paths varchar,
 json_insert varchar,
 json_keys varchar,
 json_length varchar,
 json_merge varchar,
 json_merge_patch varchar,
 json_merge_preserve varchar,
 json_objectagg varchar,
 json_object varchar,
 json_pretty varchar,
 json_quote varchar,
 json_remove varchar,
 json_replace varchar,
 json_search varchar,
 json_set varchar,
 json_table varchar,
 json_type varchar,
 json_unquote varchar,
 json_valid varchar
);

insert into json_arrayagg values ( 1,
json_array('a',1),
json_array_append('[]','$[0]',1,'$[1]','a'),
json_array_insert('[]','$[0]',1,'$[1]','a'),
json_contains(json_object('key',json_array(1,2)), '1'),
json_contains_path(json_object('key',json_array(1,2)), 'all',  '$.key[0]'),
json_depth(json_object('key',json_array(1,2)))
);

insert into json_arrayagg(i,json_array,json_array_append,json_array_insert,json_contains,json_contains_path,json_depth) values 
( 1,
json_array('a',1),
json_array_append('[0]','$[0]',1,'$[0]','a'),
json_array_insert('[]','$[0]',1,'$[1]','a'),
json_contains(json_object('key',json_array(1,2)), '1'),
json_contains_path(json_object('key',json_array(1,2)), 'all',  '$.key[0]'),
json_depth(json_object('key',json_array(1,2)))
);

select i,json_array,json_array_append,json_array_insert,json_contains,json_contains_path,json_depth from json_arrayagg;

set @jdoc='{"key":[1,2,"a"]}';
update json_arrayagg set json_extract=json_extract(json_object('key',json_array(1,2)), '$.key[0]') where i=1;
update json_arrayagg set json_object=json_object('obj', json_object('key',json_array(1,2,'d'))) where i=1;
update json_arrayagg set json_get_all_paths=json_get_all_paths(json_object('key',json_array(1,2))) where i=1;
update json_arrayagg set json_insert=json_insert(@jdoc, '$.key[0]','b') where i=1;
update json_arrayagg set json_keys=json_keys(json_object('key',json_array(1,2))) where i=1;
update json_arrayagg set json_length=json_length(json_insert) where i=1;
select i,json_extract,json_object,json_get_all_paths,json_insert,json_keys,json_length from json_arrayagg;

update json_arrayagg set json_merge_patch=json_merge_patch(json_object, json_array) where i=1;
update json_arrayagg set json_merge=json_merge(json_object, json_array) where i=1;
update json_arrayagg set json_merge_preserve=json_merge_preserve(json_object, json_array) where i=1;
select i,json_merge_patch,json_merge,json_merge_preserve from json_arrayagg;

update json_arrayagg set json_objectagg=json_objectagg(json_depth,json_array ) where i=1;
select json_objectagg(json_depth,json_array ) from json_arrayagg;
select json_arrayagg(json_array ) from json_arrayagg;

update json_arrayagg set json_pretty=json_pretty(@jdoc) where i=1;
update json_arrayagg set json_quote=json_quote(@jdoc) where i=1;
update json_arrayagg set json_remove=json_remove(json_object('key',json_array(1,2)), '$.key[0]') where i=1;
update json_arrayagg set json_replace=json_replace(json_object('key',json_array(1,2)), '$.key[0]', 100) where i=1;
select i,json_pretty,json_quote,json_remove,json_replace from json_arrayagg;

update json_arrayagg set json_search=json_search(json_object('key',json_array(1,2)),'one', '$.key[0]') where i=1;
update json_arrayagg set json_set=json_set(json_object('key',json_array(1,2)), '$.key[0]', 999) where i=1;
update json_arrayagg set json_table=(select jt.a from json_table(json_object('key',json_array(1,2)), '$' columns ( a json path '$.key[0]')) as jt) where i=1;
update json_arrayagg set json_type=json_type(json_object('key',json_array(1,2))) where i=1;
update json_arrayagg set json_unquote=json_unquote(json_object('key',json_array(1,2))) where i=1;
update json_arrayagg set json_valid=json_valid(json_object->'$.key[0]') where i=1;

select i,json_search,json_set,json_table,json_type,json_unquote,json_valid from json_arrayagg;

insert into json_arrayagg(i) values (2);
select * from json_arrayagg order by 2;

drop table json_arrayagg;
drop variable @jdoc;



