drop table if exists json;
create table json (j INT);
show create table json;
drop table if exists json;

drop table if exists [json];
create table [json] (j INT);
show create table [json];
drop table if exists [json];

drop table if exists t;
create table t ( [json] json );
show create table t;
insert into t values ('"a"'),('"b"');
select * from t order by [json];
update t set [json]='111' where [json]='"a"' order by [json];     
delete from t where [json]=111;
select * from t order by [json];
alter table t rename [json] as j;
select * from t order by [j];
delete from t where [j]='b';
delete from t where [j]='"b"';
show create table t;

drop table if exists t;
create table t ( i int , j char(10));
insert into t values (1, 'a'),(2,'b'),(3,'{"a":3}');
select json_object(j,i) from t;
select json_object(i,j) from t;
select json_array(i,j,j) from t;
drop table t;

drop table if exists t1;
create table t1 as select json_object('id', 87, 'name', 'carrot') as f;
show create table t1;
select * from t1;
drop table if exists t1;

create table t1(a json charset utf8);
drop table if exists t1;

create table t1 ( a JSON ('{"key1": "aaa\"aaa\\aaa\raaa"}'));
show create table t1; 

drop table if exists t1;
create table t1 ( a json ('{"type":"object","properties": {"num":{"type":"number"}}}')); 
show create table t1;

drop table if exists t1;
create table t1(a json default '{"a":1}');
create table t1(a json default json_object('a','1'));
show create table t1;

drop table if exists t1;
create table t1(a json not null check (json_valid(a)));
show create table t1;
insert t1 values ('[]');
insert t1 values ('a');
insert t1 values ('"a"');

drop table if exists t1;
create table t1(a json default json_object('now',to_char(now())) );
drop table if exists t1;

select cast('{a:1}' as text);
select cast('{a:1}' as json);
select cast('{"a":1}' as json);
