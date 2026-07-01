--+ holdcas on;

drop table if exists t;

create table t (name varchar(100020), job varchar(100020));

create index idx on t(name);

insert into t values(repeat('Tom',300),repeat('account',200));

select /*+ select_btree_node_info(idx) */ bt_node_key_count,bt_node_first_key,bt_node_last_key  from t; 

select /*+ select_key_info(idx) */ key_key,key_oid_count,key_first_oid,key_overflow_key,key_overflow_oids from t;

create index idx_1 on t(name,job);

select /*+ select_btree_node_info(idx_1) */ bt_node_key_count,bt_node_first_key,bt_node_last_key from t; 

select /*+ select_key_info(idx_1) */ key_key,key_oid_count,key_first_oid,key_overflow_key,key_overflow_oids from t;

drop table t;


drop table if exists t1;

create table t1 (name varchar(100020), job char(2048),i1 int,primary key (name,job));

insert into t1 values(repeat('Tom',300),concat(md5('a1'),md5('a2'),md5('a3'),md5('a4'),md5('a5'),md5('a6'),md5('a7'),md5('a8'),md5('a9'),md5('a10'),md5('a11'),md5('a12'),md5('a13'),md5('a14'),md5('a15'),md5('a16'),md5('a17'),md5('a18'),md5('a19'),md5('a20'),md5('a21'),md5('a22'),md5('a23'),md5('a24'),md5('a25'),md5('a26'),md5('a27'),md5('a28'),md5('a29'),md5('a30'),md5('a31'),md5('a32'),md5('a33'),md5('a34'),md5('a35'),md5('a36'),md5('a37'),md5('a38'),md5('a39'),md5('a40'),md5('a41'),md5('a42'),md5('a43'),md5('a44'),md5('a45'),md5('a46'),md5('a47'),md5('a48'),md5('a49'),md5('a50'),md5('a51'),md5('a52'),md5('a53'),md5('a54'),md5('a55'),md5('a56'),md5('a57'),md5('a58'),md5('a59'),md5('a60'),md5('a61'),md5('a62'),md5('a63'),md5('a64')),1);

insert into t1 values(repeat('Tom',200),concat(md5('b1'),md5('b2'),md5('b3'),md5('b4'),md5('b5'),md5('b6'),md5('b7'),md5('b8'),md5('b9'),md5('b10'),md5('b11'),md5('b12'),md5('b13'),md5('b14'),md5('b15'),md5('b16'),md5('b17'),md5('b18'),md5('b19'),md5('b20'),md5('b21'),md5('b22'),md5('b23'),md5('b24'),md5('b25'),md5('b26'),md5('b27'),md5('b28'),md5('b29'),md5('b30'),md5('b31'),md5('b32'),md5('b33'),md5('b34'),md5('b35'),md5('b36'),md5('b37'),md5('b38'),md5('b39'),md5('b40'),md5('b41'),md5('b42'),md5('b43'),md5('b44'),md5('b45'),md5('b46'),md5('b47'),md5('b48'),md5('b49'),md5('b50'),md5('b51'),md5('b52'),md5('b53'),md5('b54'),md5('b55'),md5('b56'),md5('b57'),md5('b58'),md5('b59'),md5('b60'),md5('b61'),md5('b62'),md5('b63'),md5('b64')),2);

select /*+ select_btree_node_info(pk_t1_name_job) */ bt_node_key_count,bt_node_first_key,bt_node_last_key  from t1;

select /*+ select_key_info(pk_t1_name_job) */ key_key,key_oid_count,key_first_oid,key_overflow_key,key_overflow_oids from t1;

select i1, char_length(name), char_length(job), disk_size(name), disk_size(job) from t1 order by i1;

drop table t1;


drop table if exists t2;

create table t2(a int, b varchar) partition by hash(b) partitions 4;

insert into t2 values(1,repeat('a',300));

insert into t2 values(11,repeat('test',300));

insert into t2 values(11,repeat('master',200));

create index idx_t2 on t2(b);

--- Comment the query out since CBRD-20912 issue.
--- select /*+ select_btree_node_info(idx_t2) */ * from t2__p__p0 order by 2; 

select /*+ select_key_info(idx_t2) */ key_key,key_oid_count,key_first_oid,key_overflow_key,key_overflow_oids from t2__p__p1;

drop table t2;

--+ holdcas off;

