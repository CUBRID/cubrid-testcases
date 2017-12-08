set names utf8;
SELECT json_valid('{"bar": "baz", "balance": 7.77, "active":false}');
SELECT json_merge('{"bar": "baz", "balance": 7.77, "active":false}', json_extract('{"bar": "baz", "balance": 7.77, "active":false}', '/active'));

SELECT json_insert('{"bar": "baz", "balance": 7.77, "active":false}','/status', json_extract('{"bar": "baz", "balance": 7.77, "active":false}', '/active'));
select json_extract('{"bar": "baz", "balance": 7.77, "active":false}', '/active') = FALSE;
select json_extract('{"bar": "baz", "balance": 7.77, "active":false}', '/active') = cast(FALSE as json);
select json_extract('{"bar": "baz", "balance": 7.77, "active":false}' collate utf8_en_ci, '/active');
select json_extract('{"bar": "baz", "balance": 7.77, "active":"false"}' collate utf8_en_ci, '/active') = json_extract(json_object('name', 'false' collate utf8_en_ci), '/name');
select json_extract('{"bar": "baz", "balance": 7.77, "active":"false"}' collate utf8_en_ci, '/active') = json_extract(json_object('name', 'FALSE' collate utf8_en_ci), '/name');
drop table if exists t10;
create table t10(id int primary key auto_increment, name varchar collate utf8_en_ci, de json default json_array('{"bar": "baz", "balance": 7.77, "active":"false"}' collate utf8_en_ci));
show create table t10;
insert into t10(id, name) values(1, '{"bar": "baz", "balance": 7.77, "active":"false"}');
select * from t10;
select json_merge(name, de) from t10;
select json_depth(json_merge(name, de)) from t10;  
select json_length(json_merge(name, de)) from t10; 
select json_remove(json_merge(name, de), '/0', '/1') from t10;


set names iso88591;
drop table if exists t10;
