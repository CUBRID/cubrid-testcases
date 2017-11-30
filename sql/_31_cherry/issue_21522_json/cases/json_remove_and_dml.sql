set names utf8;
drop table if exists t10;
create table t10(id int primary key auto_increment, name varchar collate utf8_en_ci, de json default json_array('{"bar": "baz", "balance": 7.77, "active":"false"}' collate utf8_en_ci));
insert into t10(id, name) values(1, '{"bar": "baz", "balance": 7.77, "active":"false"}'); 
select json_remove(json_merge(name, de), '/0', '1') from t10;
select json_remove(json_merge(name, de), '/1') from t10;
select json_remove(json_merge(name, de), '/1', '/0') from t10;
select json_remove(json_merge(name, de), '/1', '/a', '/0') from t10;
select json_remove(json_remove(json_merge(name, de), '/1', '/0'), '/0') from t10;
select json_remove(json_remove(json_merge(name, de), '/1'), '/0/bar') from t10;
select json_remove(json_remove(json_merge(name, de), _iso88591'/1'), _iso88591'/bar') from t10;  
select json_remove(json_remove(json_merge(name, de), '/1'), '/0/'||json_extract(json_object('a', 'bar'), '/a')) from t10;
drop table if exists t10;
drop table if exists t;
create table t(a json);
show create table t;
alter table t modify a json not null;
show create table t;
create trigger tr_t  BEFORE STATEMENT INSERT ON t execute insert into t values(json_array('a'));
insert into t values(json_object('a', 'b'))
select * from t order by json_extract(a, '/a');
delete  from t where json_extract(a, '/a') is null ;
select * from t;
alter table t change a a json default json_object('c', 'c');
update t set a=default(a) where cast(json_extract(a, '/a') as varchar) = 'b' 
select * from t;

replace into t values(json_merge(default(a), json_array('a')));
select * from t order by json_extract(a, '/a');


prepare st from 'delete from t where json_extract(a, ?) is null';
execute st using '/a';
 
DROP TRIGGER tr_t
drop table t;
deallocate prepare st;
set names iso88591;
