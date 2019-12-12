drop table if exists t1;
drop view if exists v1;

create table t1 (a json NOT NULL, b json, id int );
insert into t1 values ('{"title": "hello"}', null , 1);

create view v1 as select * from t1;

update v1 set b=a;
select * from t1;

update v1 set a=NULL;

update v1 set b=cast('{ "type": "object", "properties": { "title": { "type": "string" } }}' as json);
select * from t1;

CREATE OR REPLACE view v1 AS SELECT * FROM t1 ORDER BY a desc  COMMENT 'changed view';
show create view v1;
CREATE OR REPLACE view v1 ( a COMMENT '{"aa":"bb"}', b comment 'json_array("title","hello")', id comment 'json_array("title","hello")') AS SELECT * FROM t1;
show create view v1;

insert into t1 values ('{"title": "hello"}', '["title","title","hello"]',2);
ALTER VIEW v1 ADD QUERY SELECT * FROM t1 WHERE json_type(b)='JSON_ARRAY';
update v1 set b=json_merge(a,a,b) where json_type(b)='JSON_ARRAY';

select * from v1 order by b, a desc;
select * from t1 order by b desc, a asc;

drop table if exists t1;
drop view if exists v1;

