drop table if exists t;
create table t (name varchar(20), job varchar(20));
create index idx on t(name);
insert into t values('Tom','account');
select /*+ select_btree_node_info(idx) */ bt_node_key_count,bt_node_first_key,bt_node_last_key  from t; 
select /*+ select_key_info(idx) */ key_key,key_oid_count,key_first_oid,key_overflow_key,key_overflow_oids from t;
drop table t;
