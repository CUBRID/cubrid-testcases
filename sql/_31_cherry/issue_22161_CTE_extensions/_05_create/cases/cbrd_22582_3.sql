drop table if exists t1,foo;

create table t1 (id int, fname varchar(20), lname varchar(10), grade int);
create unique index idx1 on t1(id,fname);
insert into t1 values(100,'Jack','Li',98),(110,'Tom','Zhang',79);

create table foo (i int) 
partition by range(i) 
(partition p1 values less  than(100),
partition p2 values less  than(2000)
)  as WITH cte AS
(
select /*+ select_btree_node_info(idx1) */ bt_node_type,bt_node_key_count,bt_node_first_key,bt_node_last_key from t1
)
select count(*) as [count(*)]from cte;
select * from foo order by 1,2;

drop table foo;

WITH cte AS
(
select /*+ select_key_info(idx1) */ key_slotid,key_key,key_oid_count,key_first_oid,key_overflow_key,key_overflow_oids from t1
)
select count(*) as [count(*)] from cte;

create table foo (i int) 
as WITH cte AS
(
select /*+ select_key_info(idx1) */ key_slotid,key_key,key_oid_count,key_first_oid,key_overflow_key,key_overflow_oids from t1
)
select count(*) as [count(*)] from cte;
select * from foo order by 1,2;

drop table foo;
create table foo (i int) 
partition by range(i) 
(partition p1 values less  than(100),
partition p2 values less  than(2000)
)  as WITH cte AS
(
select /*+ select_key_info(idx1) */ key_slotid,key_key,key_oid_count,key_first_oid,key_overflow_key,key_overflow_oids from t1
)
select count(*) as cnt from cte;
select * from foo order by 1,2;

drop table if exists t1,foo;
