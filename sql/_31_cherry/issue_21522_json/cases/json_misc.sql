drop table if exists users;
CREATE TABLE users (
  id INT NOT NULL auto_increment,
  username VARCHAR(32) NOT NULL,
  preferences JSON NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (username)
);
INSERT INTO users
 (id,username,preferences)
VALUES
 (NULL, 'morgan', '{"layout": "horizontal", "warn_before_delete": false, "notify_on_updates": true}'),
 (NULL, 'wes', '{"layout": "horizontal", "warn_before_delete": false, "notify_on_updates": false}'),
 (NULL, 'jasper', '{"layout": "horizontal", "warn_before_delete": false, "notify_on_updates": false}'),
 (NULL, 'gus', '{"layout": "horizontal", "warn_before_delete": false, "notify_on_updates": false}'),
 (NULL, 'olive', '{"layout": "horizontal", "warn_before_delete": false, "notify_on_updates": false}');
update users set preferences=json_insert(preferences, '/layout/^', '"www.baidu.com"') where id=5;
update users set preferences=json_insert(preferences, '/layout/^', '"wwwww.baidu.com"') where id=5;

select GREATEST(json_extract(json_array(1, 2, 123), '/0'), json_extract(json_array(1, 2, 123), '/2'));

drop table if exists t;
drop view if exists v_1;
create table t(a int, b json, c json);
insert into t values(1, json_object('a','b'), '["c", "d"]');
insert into t values(2, json_object('a','b'), '["a"]');
create view v_1 as select b, c, json_merge(b, c) as d from t;
select json_object('key', t.a, 'title', json_extract(t.c, '/0')) from t join v_1 on 1=1 group by t.b;
with cte as (select a,b, json_extract(b, '/a') as val from t) select max(a) as max_id, val from cte group by val;

select distinct b from v_1;  
select distinct json_extract(b,'/a') from t;
select distinct json_extract(d,'/0') from v_1; 
select json_extract(d,'/1') from v_1 order by 1;
select json_extract(d,'/1') from v_1 order by 1 desc;

select   json_array('a', 'b', 123, json_object('x', 'y'), 456.03, json_array('[aa]'), 'ccc');
select json_contains(json_object('f', json_object('a', 123.2, 'b', json_array('x', 'y', 'z'))), json_object('a', 123.2, 'b', json_array('y')), '/f');

select position(sys_time in json_array(TO_CHAR(sys_time)));
select position(sys_time in TO_CHAR(sys_time));
select json_array('05:41:22 PM');

drop view if exists v_1;
drop table users;
drop table t;
