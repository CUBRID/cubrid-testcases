
-- json document is expected.
select json_depth(1);
select json_depth('1');

select json_length(1);
select json_length('1');

select json_array_append(1, '$[0]', 2); 
--CBRD-22623
--select json_array_append('1', '$[0]', 2); 

select json_array_insert(1, '$[0]', 2); 
--CBRD-22623
--select json_array_insert('1', '$[0]', 2); 

select json_insert(1, '$[0]', 2); 
--CBRD-22623
--select json_insert('1', '$[0]', 2); 

select json_merge(1,2); 
select json_merge('1',2); 
select json_merge(1,'2'); 
select json_merge('1','2'); 

select json_merge_preserve(1,2); 
select json_merge_preserve('1',2); 
select json_merge_preserve(1,'2'); 
select json_merge_preserve('1','2'); 

select json_merge_patch(1,2); 
select json_merge_patch('1','2'); 

select json_remove(1, '$[0]'); 
--CBRD-22623
--select json_remove('1', '$[0]'); 
select json_remove(1, '$'); 
--CBRD-22651
--select json_remove('1', '$'); 

select json_replace(1, '$[0]', 2); 
--CBRD-22623
--select json_replace('1', '$[0]', 2); 
select json_replace(1, '$', 2);
select json_replace('1', '$', 2);

select json_set(1, '$[0]', 2); 
--CBRD-22623
--select json_set('1', '$[0]', 2); 
select json_set(1, '$', 2);
select json_set('1', '$', 2);

select json_contains(1,1); 
select json_contains('1',1); 
select json_contains('1','1'); 

select json_contains_path(1,'all','$'); 
select json_contains_path('1','all','$'); 

select json_extract(1,'$'); 
select json_extract('1','$'); 

select json_keys(1); 
select json_keys('1'); 

select json_search(1,'all',1); 
select json_search('1','all',1); 
select json_search('1','all','1'); 

select json_get_all_paths(1); 
select json_get_all_paths('1'); 

select * from json_table(1, '$' columns( col varchar(20) path '$')) as jt; 
select * from json_table('1', '$' columns( col varchar(20) path '$')) as jt; 


-- json value is expected.
--CBRD-22651
--select json_quote(1); 
select json_quote('1'); 

select json_unquote(1); 
select json_unquote('1'); 

select json_pretty(1); 
select json_pretty('1'); 

--CBRD-22646
select json_valid(1); 
select json_valid('1'); 

select json_type(1); 
select json_type('1'); 

select json_array(1,2); 
select json_array('1','2'); 
select json_array('1',2); 

select json_arrayagg(1); 
select json_arrayagg('1'); 

select json_object(1,2); 
select json_object('1','2'); 
select json_object('1',2); 

select json_objectagg(1,2); 
select json_objectagg('1','2'); 
select json_objectagg('1',2); 


drop table if exists t_json,t_numeric;
create table t_numeric(
  id            int auto_increment,
  c_sint        smallint,
  c_int         int,
  c_bigint      bigint,
  c_numeric     numeric(38,10),
  c_float       float,
  c_real        real,
  c_doublepre   double precision
);
insert into t_numeric values ( null, 
-32768, -2147483648, -9223372036854775808, 9876543210987654321012345678.0123456789, 
987654.321, 987654321.987654321,9876.1);

create table t_json( i int , j json);
insert into t_json(i,j) select 1,c_int       from t_numeric;     
insert into t_json(i,j) select 2,c_bigint    from t_numeric;     
insert into t_json(i,j) select 3,c_numeric   from t_numeric; 
insert into t_json(i,j) select 4,c_doublepre from t_numeric;     
--CBRD-22646
--insert into t_json(i,j) select 5,c_sint      from t_numeric;     
--insert into t_json(i,j) select 6,c_float     from t_numeric;     
--insert into t_json(i,j) select 7,c_real      from t_numeric;     

select * from t_json order by i;
drop table if exists t_json,t_numeric;

