drop table if exists t1;
create table t1 (id int, fname varchar(20), lname varchar(10), grade int);
create unique index idx1 on t1(id,fname);
insert into t1 values(100,'Jack','Li',98),(110,'Tom','Zhang',79);
select /*+ select_btree_node_info(idx1) */ bt_node_type,bt_node_key_count,bt_node_first_key,bt_node_last_key from t1;
select /*+ select_key_info(idx1) */ key_slotid,key_key,key_oid_count,key_first_oid,key_overflow_key,key_overflow_oids from t1;
drop table t1;
