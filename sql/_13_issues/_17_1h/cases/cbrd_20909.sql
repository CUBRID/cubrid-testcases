--+ holdcas on;

drop table if exists t;

create table t (name varchar(100020), job varchar(100020));

create index idx on t(name);

insert into t values(repeat('Tom',300),repeat('account',300));

select /*+ select_btree_node_info(idx) */ bt_node_key_count,bt_node_first_key,bt_node_last_key  from t; 

select /*+ select_key_info(idx) */ key_key,key_oid_count,key_first_oid,key_overflow_key,key_overflow_oids from t;

create index idx_1 on t(name,job);

select /*+ select_btree_node_info(idx_1) */ bt_node_key_count,bt_node_first_key,bt_node_last_key from t; 

select /*+ select_key_info(idx_1) */ key_key,key_oid_count,key_first_oid,key_overflow_key,key_overflow_oids from t;

drop table t;


drop table if exists t1;

create table t1 (name varchar(100020), job char(100020),i1 int,primary key (name,job));

insert into t1 values(repeat('Tom',300),repeat('account',300),1);

insert into t1 values(repeat('Tom',200),repeat('account',200),2);

select /*+ select_btree_node_info(pk_t1_name_job) */ bt_node_key_count,bt_node_first_key,bt_node_last_key  from t1;

select /*+ select_key_info(pk_t1_name_job) */ key_key,key_oid_count,key_first_oid,key_overflow_key,key_overflow_oids from t1;

drop table t1;


drop table if exists t2;

create table t2(a int, b varchar) partition by hash(b) partitions 4;

insert into t2 values(1,repeat('a',300));

insert into t2 values(11,repeat('test',300));

insert into t2 values(11,repeat('master',300));

create index idx_t2 on t2(b);

--- Comment the query out since CBRD-20912 issue.
--- select /*+ select_btree_node_info(idx_t2) */ * from t2__p__p0 order by 2; 

select /*+ select_key_info(idx_t2) */ key_key,key_oid_count,key_first_oid,key_overflow_key,key_overflow_oids from t2__p__p1;

drop table t2;

--+ holdcas off;

