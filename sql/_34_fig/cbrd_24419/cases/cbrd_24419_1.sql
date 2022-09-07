/*
 * This is a test case to verify the CBRD-24419 issue.
 *
 * The result should be the same as before.
 *   - db_class
 *   - db_direct_super_class
 *   - db_vclass
 *   - db_attribute
 *   - db_attr_setdomain_elm
 *   - db_method
 *   - db_meth_arg
 *   - db_meth_arg_setdomain_elm
 *   - db_meth_file
 *   - db_index
 *   - db_index_key
 *   - db_auth
 *   - db_trig
 *   - db_partition
 *   - db_stored_procedure
 *   - db_stored_procedure_args
 *   - db_server
 *   - db_synonym
 *   - skip checking db_charset, db_collation doesnt have owner_name attribute.
 */
set system parameters 'create_table_reuseoid=no';

create user u0 groups dba;


drop table if exists u0.t1;
drop view if exists u0.v1;
drop table if exists u0.t2_r;
drop table if exists u0.t2_h;
drop table if exists u0.t2_l;
drop table if exists u0.t3_d;
drop table if exists u0.t3_s;
drop table if exists u0.t3;
drop table if exists u0.t4;
drop table if exists u0.t5;
drop table if exists u0.t5_c;

 

call login ('u0') on class db_user;
create table t1 class attribute (a1 int) (c1 int, c2 varchar(255) collate euckr_bin) comment 'u0 {dba} > t1';
create view v1 as select * from t1 as t comment 'u0 {dba} > v1';
create table t2_r (c1 int) comment 'u0 {dba} > t2_r (range)' 
  partition by range (c1) (
      partition p0 values less than (0) comment 'u0 {dba} > t2_r > p0 (range)',
      partition p1 values less than maxvalue comment 'u0 {dba} > t2_r > p1 (range)'
    );
create table t2_h (c1 int) comment 'u0 {dba} > t2_h (hash)'
  partition by hash (c1) partitions 2;
create table t2_l (c1 int) comment 'u0 {dba} > t2_l (list)' 
  partition by list (c1) (
      partition p0 values in (0) comment 'u0 {dba} > t2_l > p0 (list)',
      partition p1 values in (1) comment 'u0 {dba} > t2_l > p1 (list)'
    );
create table t3_d (c1 int) comment 'u0 {dba} > t3_d (domain)';
create table t3_s (c1 int) comment 'u0 {dba} > t3_s (super)'
  method class m0(sequence of t3_d) t3_d function f0, m1(varchar(255)) int function f1
  file '$home/method_s';
create table t3 as subclass of t3_s (c1 int, c3 t3_d, c4 sequence of t3_d) comment 'u0 {dba} > t3 (inherit)'
  method class m0(sequence of t3_d) t3_d function f0, m1(varchar(255)) int function f1
  file '$home/method'
  inherit class m0 of t3_s as m0_s, m1 of t3_s as m1_s, c1 of t3_s as c1_s;
create table t4 (c1 int primary key, c2 int, c3 varchar(255)) comment 'u0 {dba} > t4';
create index i1 on t4 (c1, c2) comment 'u0 {dba} > t4 > i1 (index)' invisible;
create index i2 on t4 (c2) where c2 = 0 comment 'u0 {dba} > t4 > i2 (filter)';
create index i3 on t4 (replace (c3, ' ', '')) comment 'u0 {dba} > t4 > i3 (function)';
create table t5 (c1 int unique, c2 int) comment 'u0 {dba} > t5';
create table t5_c (c1 int unique, c2 int) comment 'u0 {dba} > t5_c (copy)';
create trigger r_i after insert on t5 execute insert into t5_c values (obj.c1, obj.c2) comment 'u0 {dba} > r_i (insert)';
create trigger r_u after update on t5 (c2) execute update t5_c set c2 = obj.c2 where c1 = obj.c1 comment 'u0 {dba} > r_u (update)';
create trigger r_d before delete on t5 execute reject comment 'u0 {dba} > r_d (delete)';
create function j0 (arg1 int comment 'u0 {dba} > j0 > arg1 (in)', arg2 out int comment 'u0 {dba} > j0 > arg2 (out)') return int
  as language java name 'test.j0(int) return int' comment 'u0 {dba} > j0 (function)';
create server s1 (host='localhost', port=33000, dbname=basic, user=dba, comment='u0 {dba} > s1 (dblink)');




call login ('u0') on class db_user;
select * from db_class where is_system_class = 'NO' order by owner_name, class_name;
select * from db_direct_super_class order by owner_name, class_name;
select * from db_partition order by owner_name, partition_class_name;
select * from db_vclass where vclass_name in ('v1') order by owner_name, vclass_name;
select * from db_attribute where class_name in (select class_name from db_class where is_system_class = 'NO') order by owner_name, class_name, attr_name;
select * from db_attr_setdomain_elm where class_name in (select class_name from db_class where is_system_class = 'NO') order by owner_name, class_name, attr_name;
select * from db_auth where class_name in (select class_name from db_class where is_system_class = 'NO') order by owner_name, grantor_name, grantee_name, class_name, auth_type;
select * from db_index where class_name in (select class_name from db_class where is_system_class = 'NO') order by owner_name, class_name, index_name;
select * from db_index_key where class_name in (select class_name from db_class where is_system_class = 'NO') order by owner_name, class_name, index_name;
select * from db_trig order by owner_name, trigger_name;
select * from db_stored_procedure order by sp_name;
select * from db_stored_procedure_args order by sp_name;
select * from db_method where class_name in (select class_name from db_class where is_system_class = 'NO') order by owner_name, class_name, meth_name;
select * from db_meth_arg where class_name in (select class_name from db_class where is_system_class = 'NO') order by owner_name, class_name, meth_name;
select * from db_meth_arg_setdomain_elm order by owner_name, class_name, meth_name;
select * from db_meth_file order by owner_name, class_name, path_name, from_owner_name, from_class_name;
select * from db_synonym order by synonym_owner_name, synonym_name;
select * from db_server order by owner, link_name;




call login ('dba') on class db_user;
drop table u0.t1;
drop view u0.v1;
drop table u0.t2_r;
drop table u0.t2_h;
drop table u0.t2_l;
drop table u0.t3_d;
drop table u0.t3_s;
drop table u0.t3;
drop table u0.t4;
drop table u0.t5;
drop table u0.t5_c;
drop function j0;
drop server u0.s1;

drop user u0;
