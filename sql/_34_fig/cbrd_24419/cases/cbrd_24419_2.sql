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
 *   - db_collation
 *   - db_charset
 *   - db_server
 *   - db_synonym
 *
 */
set system parameters 'create_table_reuseoid=no';

create user u1;
create user u1_1 groups u1;
create user u2;
create user u2_1 groups u2;
create user u3 groups u1_1, u2_1;
create user u3_1 groups u3;


drop table if exists u1.t1;
drop view if exists u1.v1;
drop table if exists u1.t2_r;
drop table if exists u1.t2_h;
drop table if exists u1.t2_l;
drop table if exists u1.t3_d;
drop table if exists u1.t3_s;
drop table if exists u1.t3;
drop table if exists u1.t4;
drop table if exists u1.t5;
drop table if exists u1.t5_c;

drop table if exists u1_1.t1;
drop view if exists u1_1.v1;
drop table if exists u1_1.t2_r;
drop table if exists u1_1.t2_h;
drop table if exists u1_1.t2_l;
drop table if exists u1_1.t3_d;
drop table if exists u1_1.t3_s;
drop table if exists u1_1.t3;
drop table if exists u1_1.t4;
drop table if exists u1_1.t5;
drop table if exists u1_1.t5_c;

drop table if exists u2.t1;
drop view if exists u2.v1;
drop table if exists u2.t2_r;
drop table if exists u2.t2_h;
drop table if exists u2.t2_l;
drop table if exists u2.t3_d;
drop table if exists u2.t3_s;
drop table if exists u2.t3;
drop table if exists u2.t4;
drop table if exists u2.t5;
drop table if exists u2.t5_c;

drop table if exists u2_1.t1;
drop view if exists u2_1.v1;
drop table if exists u2_1.t2_r;
drop table if exists u2_1.t2_h;
drop table if exists u2_1.t2_l;
drop table if exists u2_1.t3_d;
drop table if exists u2_1.t3_s;
drop table if exists u2_1.t3;
drop table if exists u2_1.t4;
drop table if exists u2_1.t5;
drop table if exists u2_1.t5_c;

drop table if exists u3.t1;
drop view if exists u3.v1;
drop table if exists u3.t2_r;
drop table if exists u3.t2_h;
drop table if exists u3.t2_l;
drop table if exists u3.t3_d;
drop table if exists u3.t3_s;
drop table if exists u3.t3;
drop table if exists u3.t4;
drop table if exists u3.t5;
drop table if exists u3.t5_c;

drop table if exists u3_1.t1;
drop view if exists u3_1.v1;
drop table if exists u3_1.t2_r;
drop table if exists u3_1.t2_h;
drop table if exists u3_1.t2_l;
drop table if exists u3_1.t3_d;
drop table if exists u3_1.t3_s;
drop table if exists u3_1.t3;
drop table if exists u3_1.t4;
drop table if exists u3_1.t5;
drop table if exists u3_1.t5_c;

 


call login ('u1') on class db_user;
create table t1 class attribute (a1 int) (c1 int, c2 varchar(255) collate euckr_bin) comment 'u1 > t1';
create view v1 as select * from t1 as t comment 'u1 > v1';
create table t2_r (c1 int) comment 'u1 > t2_r (range)' 
  partition by range (c1) (
      partition p0 values less than (0) comment 'u1 > t2_r > p0 (range)',
      partition p1 values less than maxvalue comment 'u1 > t2_r > p1 (range)'
    );
create table t2_h (c1 int) comment 'u1 > t2_h (hash)'
  partition by hash (c1) partitions 2;
create table t2_l (c1 int) comment 'u1 > t2_l (list)' 
  partition by list (c1) (
      partition p0 values in (0) comment 'u1 > t2_l > p0 (list)',
      partition p1 values in (1) comment 'u1 > t2_l > p1 (list)'
    );
create table t3_d (c1 int) comment 'u1 > t3_d (domain)';
create table t3_s (c1 int) comment 'u1 > t3_s (super)'
  method class m0(sequence of t3_d) t3_d function f0, m1(varchar(255)) int function f1
  file '$home/method_s';
create table t3 as subclass of t3_s (c1 int, c3 t3_d, c4 sequence of t3_d) comment 'u1 > t3 (inherit)'
  method class m0(sequence of t3_d) t3_d function f0, m1(varchar(255)) int function f1
  file '$home/method'
  inherit class m0 of t3_s as m0_s, m1 of t3_s as m1_s, c1 of t3_s as c1_s;
create table t4 (c1 int primary key, c2 int, c3 varchar(255)) comment 'u1 > t4';
create index i1 on t4 (c1, c2) comment 'u1 > t4 > i1 (index)' invisible;
create index i2 on t4 (c2) where c2 = 0 comment 'u1 > t4 > i2 (filter)';
create index i3 on t4 (replace (c3, ' ', '')) comment 'u1 > t4 > i3 (function)';
create table t5 (c1 int unique, c2 int) comment 'u1 > t5';
create table t5_c (c1 int unique, c2 int) comment 'u1 > t5_c (copy )';
create trigger r_i after insert on t5 execute insert into t5_c values (obj.c1, obj.c2) comment 'u1 > r_i (insert)';
create trigger r_u after update on t5 (c2) execute update t5_c set c2 = obj.c2 where c1 = obj.c1 comment 'u1 > r_u (update)';
create trigger r_d before delete on t5 execute reject comment 'u1 > r_d (delete)';
create function j1 (arg1 int comment 'u1 > j1 > arg1 (in)', arg2 out int comment 'u1 > j1 > arg2 (out)') return int
  as language java name 'Test.j1(int) return int' comment 'u1 > j1 (function)';
create server s1 (host='localhost', port=33000, dbname=basic, user=dba, comment='u1 > s1 (dblink)');




call login ('u1_1') on class db_user;
create table t1 class attribute (a1 int) (c1 int, c2 varchar(255) collate euckr_bin) comment 'u1_1 {u1} > t1';
create view v1 as select * from t1 as t comment 'u1_1 {u1} > v1';
create table t2_r (c1 int) comment 'u1_1 {u1} > t2_r (range)' 
  partition by range (c1) (
      partition p0 values less than (0) comment 'u1_1 {u1} > t2_r > p0 (range)',
      partition p1 values less than maxvalue comment 'u1_1 {u1} > t2_r > p1 (range)'
    );
create table t2_h (c1 int) comment 'u1_1 {u1} > t2_h (hash)'
 partition by hash (c1) partitions 2;
create table t2_l (c1 int) comment 'u1_1 {u1} > t2_l (list)' 
  partition by list (c1) (
      partition p0 values in (0) comment 'u1_1 {u1} > t2_l > p0 (list)',
      partition p1 values in (1) comment 'u1_1 {u1} > t2_l > p1 (list)'
    );
create table t3_d (c1 int) comment 'u1_1 {u1} > t3_d (domain)';
create table t3_s (c1 int) comment 'u1_1 {u1} > t3_s (super)'
  method class m0(sequence of t3_d) t3_d function f0, m1(varchar(255)) int function f1
  file '$home/method_s';
create table t3 as subclass of t3_s (c1 int, c3 t3_d, c4 sequence of t3_d) comment 'u1_1 {u1} > t3 (inherit)'
  method class m0(sequence of t3_d) t3_d function f0, m1(varchar(255)) int function f1
  file '$home/method'
  inherit class m0 of t3_s as m0_s, m1 of t3_s as m1_s, c1 of t3_s as c1_s;
create table t4 (c1 int primary key, c2 int, c3 varchar(255)) comment 'u1_1 {u1} > t4';
create index i1 on t4 (c1, c2) comment 'u1_1 {u1} > t4 > i1 (index)' invisible;
create index i2 on t4 (c2) where c2 = 0 comment 'u1_1 {u1} > t4 > i2 (filter)';
create index i3 on t4 (replace (c3, ' ', '')) comment 'u1_1 {u1} > t4 > i3 (function)';
create table t5 (c1 int unique, c2 int) comment 'u1_1 {u1} > t5';
create table t5_c (c1 int unique, c2 int) comment 'u1_1 {u1} > t5_c (copy )';
create trigger r_i after insert on t5 execute insert into t5_c values (obj.c1, obj.c2) comment 'u1_1 {u1} > r_i (insert)';
create trigger r_u after update on t5 (c2) execute update t5_c set c2 = obj.c2 where c1 = obj.c1 comment 'u1_1 {u1} > r_u (update)';
create trigger r_d before delete on t5 execute reject comment 'u1_1 {u1} > r_d (delete)';
create function j1_1 (arg1 int comment 'u1_1 {u1} > j1_1 > arg1 (in)', arg2 out int comment 'u1_1 {u1} > j1_1 > arg2 (out)') return int
  as language java name 'Test.j1_1(int) return int' comment 'u1_1 {u1} > j1_1 (function)';
create server s1 (host='localhost', port=33000, dbname=basic, user=dba, comment='u1_1 {u1} > s1 (dblink)');




call login ('u2') on class db_user;
create table t1 class attribute (a1 int) (c1 int, c2 varchar(255) collate euckr_bin) comment 'u2 > t1';
create view v1 as select * from t1 as t comment 'u2 > v1';
create table t2_r (c1 int) comment 'u2 > t2_r (range)' 
  partition by range (c1) (
      partition p0 values less than (0) comment 'u2 > t2_r > p0 (range)',
      partition p1 values less than maxvalue comment 'u2 > t2_r > p1 (range)'
    );
create table t2_h (c1 int) comment 'u2 > t2_h (hash)'
  partition by hash (c1) partitions 2;
create table t2_l (c1 int) comment 'u2 > t2_l (list)' 
  partition by list (c1) (
      partition p0 values in (0) comment 'u2 > t2_l > p0 (list)',
      partition p1 values in (1) comment 'u2 > t2_l > p1 (list)'
    );
create table t3_d (c1 int) comment 'u2 > t3_d (domain)';
create table t3_s (c1 int) comment 'u2 > t3_s (super)'
  method class m0(sequence of t3_d) t3_d function f0, m1(varchar(255)) int function f1
  file '$home/method_s';
create table t3 as subclass of t3_s (c1 int, c3 t3_d, c4 sequence of t3_d) comment 'u2 > t3 (inherit)'
  method class m0(sequence of t3_d) t3_d function f0, m1(varchar(255)) int function f1
  file '$home/method'
  inherit class m0 of t3_s as m0_s, m1 of t3_s as m1_s, c1 of t3_s as c1_s;
create table t4 (c1 int primary key, c2 int, c3 varchar(255)) comment 'u2 > t4';
create index i1 on t4 (c1, c2) comment 'u2 > t4 > i1 (index)' invisible;
create index i2 on t4 (c2) where c2 = 0 comment 'u2 > t4 > i2 (filter)';
create index i3 on t4 (replace (c3, ' ', '')) comment 'u2 > t4 > i3 (function)';
create table t5 (c1 int unique, c2 int) comment 'u2 > t5';
create table t5_c (c1 int unique, c2 int) comment 'u2 > t5_c (copy )';
create trigger r_i after insert on t5 execute insert into t5_c values (obj.c1, obj.c2) comment 'u2 > r_i (insert)';
create trigger r_u after update on t5 (c2) execute update t5_c set c2 = obj.c2 where c1 = obj.c1 comment 'u2 > r_u (update)';
create trigger r_d before delete on t5 execute reject comment 'u2 > r_d (delete)';
create function j2 (arg1 int comment 'u2 > j2 > arg1 (in)', arg2 out int comment 'u2 > j2 > arg2 (out)') return int
  as language java name 'Test.j2(int) return int' comment 'u2 > j2 (function)';
create server s1 (host='localhost', port=33000, dbname=basic, user=dba, comment='u2 > s1 (dblink)');




call login ('u2_1') on class db_user;
create table t1 class attribute (a1 int) (c1 int, c2 varchar(255) collate euckr_bin) comment 'u2_1 {u2} > t1';
create view v1 as select * from t1 as t comment 'u2_1 {u2} > v1';
create table t2_r (c1 int) comment 'u2_1 {u2} > t2_r (range)' 
  partition by range (c1) (
      partition p0 values less than (0) comment 'u2_1 {u2} > t2_r > p0 (range)',
      partition p1 values less than maxvalue comment 'u2_1 {u2} > t2_r > p1 (range)'
    );
create table t2_h (c1 int) comment 'u2_1 {u2} > t2_h (hash)'
  partition by hash (c1) partitions 2;
create table t2_l (c1 int) comment 'u2_1 {u2} > t2_l (list)' 
  partition by list (c1) (
      partition p0 values in (0) comment 'u2_1 {u2} > t2_l > p0 (list)',
      partition p1 values in (1) comment 'u2_1 {u2} > t2_l > p1 (list)'
    );
create table t3_d (c1 int) comment 'u2_1 {u2} > t3_d (domain)';
create table t3_s (c1 int) comment 'u2_1 {u2} > t3_s (super)'
  method class m0(sequence of t3_d) t3_d function f0, m1(varchar(255)) int function f1
  file '$home/method_s';
create table t3 as subclass of t3_s (c1 int, c3 t3_d, c4 sequence of t3_d) comment 'u2_1 {u2} > t3 (inherit)'
  method class m0(sequence of t3_d) t3_d function f0, m1(varchar(255)) int function f1
  file '$home/method'
  inherit class m0 of t3_s as m0_s, m1 of t3_s as m1_s, c1 of t3_s as c1_s;
create table t4 (c1 int primary key, c2 int, c3 varchar(255)) comment 'u2_1 {u2} > t4';
create index i1 on t4 (c1, c2) comment 'u2_1 {u2} > t4 > i1 (index)' invisible;
create index i2 on t4 (c2) where c2 = 0 comment 'u2_1 {u2} > t4 > i2 (filter)';
create index i3 on t4 (replace (c3, ' ', '')) comment 'u2_1 {u2} > t4 > i3 (function)';
create table t5 (c1 int unique, c2 int) comment 'u2_1 {u2} > t5';
create table t5_c (c1 int unique, c2 int) comment 'u2_1 {u2} > t5_c (copy )';
create trigger r_i after insert on t5 execute insert into t5_c values (obj.c1, obj.c2) comment 'u2_1 {u2} > r_i (insert)';
create trigger r_u after update on t5 (c2) execute update t5_c set c2 = obj.c2 where c1 = obj.c1 comment 'u2_1 {u2} > r_u (update)';
create trigger r_d before delete on t5 execute reject comment 'u2_1 {u2} > r_d (delete)';
create function j2_1 (arg1 int comment 'u2_1 {u2} > j2_1 > arg1 (in)', arg2 out int comment 'u2_1 {u2} > j2_1 > arg2 (out)') return int
  as language java name 'Test.j2_1(int) return int' comment 'u2_1 {u2} > j2_1 (function)';
create server s1 (host='localhost', port=33000, dbname=basic, user=dba, comment='u2_1 {u2} > s1 (dblink)');




call login ('u3') on class db_user;
create table t1 class attribute (a1 int) (c1 int, c2 varchar(255) collate euckr_bin) comment 'u3 {u1_1, u2_1} > t1';
create view v1 as select * from t1 as t comment 'u3 {u1_1, u2_1} > v1';
create table t2_r (c1 int) comment 'u3 {u1_1, u2_1} > t2_r (range)' 
  partition by range (c1) (
      partition p0 values less than (0) comment 'u3 {u1_1, u2_1} > t2_r > p0 (range)',
      partition p1 values less than maxvalue comment 'u3 {u1_1, u2_1} > t2_r > p1 (range)'
    );
create table t2_h (c1 int) comment 'u3 {u1_1, u2_1} > t2_h (hash)'
  partition by hash (c1) partitions 2;
create table t2_l (c1 int) comment 'u3 {u1_1, u2_1} > t2_l (list)' 
  partition by list (c1) (
      partition p0 values in (0) comment 'u3 {u1_1, u2_1} > t2_l > p0 (list)',
      partition p1 values in (1) comment 'u3 {u1_1, u2_1} > t2_l > p1 (list)'
    );
create table t3_d (c1 int) comment 'u3 {u1_1, u2_1} > t3_d (domain)';
create table t3_s (c1 int) comment 'u3 {u1_1, u2_1} > t3_s (super)'
  method class m0(sequence of t3_d) t3_d function f0, m1(varchar(255)) int function f1
  file '$home/method_s';
create table t3 as subclass of t3_s (c1 int, c3 t3_d, c4 sequence of t3_d) comment 'u3 {u1_1, u2_1} > t3 (inherit)'
  method class m0(sequence of t3_d) t3_d function f0, m1(varchar(255)) int function f1
  file '$home/method'
  inherit class m0 of t3_s as m0_s, m1 of t3_s as m1_s, c1 of t3_s as c1_s;
create table t4 (c1 int primary key, c2 int, c3 varchar(255)) comment 'u3 {u1_1, u2_1} > t4';
create index i1 on t4 (c1, c2) comment 'u3 {u1_1, u2_1} > t4 > i1 (index)' invisible;
create index i2 on t4 (c2) where c2 = 0 comment 'u3 {u1_1, u2_1} > t4 > i2 (filter)';
create index i3 on t4 (replace (c3, ' ', '')) comment 'u3 {u1_1, u2_1} > t4 > i3 (function)';
create table t5 (c1 int unique, c2 int) comment 'u3 {u1_1, u2_1} > t5';
create table t5_c (c1 int unique, c2 int) comment 'u3 {u1_1, u2_1} > t5_c (copy )';
create trigger r_i after insert on t5 execute insert into t5_c values (obj.c1, obj.c2) comment 'u3 {u1_1, u2_1} > r_i (insert)';
create trigger r_u after update on t5 (c2) execute update t5_c set c2 = obj.c2 where c1 = obj.c1 comment 'u3 {u1_1, u2_1} > r_u (update)';
create trigger r_d before delete on t5 execute reject comment 'u3 {u1_1, u2_1} > r_d (delete)';
create function j3 (arg1 int comment 'u3 {u1_1, u2_1} > j3 > arg1 (in)', arg2 out int comment 'u3 {u1_1, u2_1} > j3 > arg2 (out)') return int
  as language java name 'Test.j3(int) return int' comment 'u3 {u1_1, u2_1} > j3 (function)';
create server s1 (host='localhost', port=33000, dbname=basic, user=dba, comment='u3 {u1_1, u2_1} > s1 (dblink)');




call login ('u3_1') on class db_user;
create table t1 class attribute (a1 int) (c1 int, c2 varchar(255) COLLATE euckr_bin) comment 'u3_1 {u3} > t1';
create view v1 as select * from t1 as t comment 'u3_1 {u3} > v1';
create table t2_r (c1 int) comment 'u3_1 {u3} > t2_r (range)' 
  partition by range (c1) (
      partition p0 values less than (0) comment 'u3_1 {u3} > t2_r > p0 (range)',
      partition p1 values less than maxvalue comment 'u3_1 {u3} > t2_r > p1 (range)'
    );
create table t2_h (c1 int) comment 'u3_1 {u3} > t2_h (hash)'
  partition by hash (c1) partitions 2;
create table t2_l (c1 int) comment 'u3_1 {u3} > t2_l (list)' 
  partition by list (c1) (
      partition p0 values in (0) comment 'u3_1 {u3} > t2_l > p0 (list)',
      partition p1 values in (1) comment 'u3_1 {u3} > t2_l > p1 (list)'
    );
create table t3_d (c1 int) comment 'u3_1 {u3} > t3_d (domain)';
create table t3_s (c1 int) comment 'u3_1 {u3} > t3_s (super)'
  method class m0(sequence of t3_d) t3_d function f0, m1(varchar(255)) int function f1
  file '$home/method_s';
create table t3 as subclass of t3_s (c1 int, c3 t3_d, c4 sequence of t3_d) comment 'u3_1 {u3} > t3 (inherit)'
  method class m0(sequence of t3_d) t3_d function f0, m1(varchar(255)) int function f1
  file '$home/method'
  inherit class m0 of t3_s as m0_s, m1 of t3_s as m1_s, c1 of t3_s as c1_s;
create table t4 (c1 int primary key, c2 int, c3 varchar(255)) comment 'u3_1 {u3} > t4';
create index i1 on t4 (c1, c2) comment 'u3_1 {u3} > t4 > i1 (index)' invisible;
create index i2 on t4 (c2) where c2 = 0 comment 'u3_1 {u3} > t4 > i2 (filter)';
create index i3 on t4 (replace (c3, ' ', '')) comment 'u3_1 {u3} > t4 > i3 (function)';
create table t5 (c1 int unique, c2 int) comment 'u3_1 {u3} > t5';
create table t5_c (c1 int unique, c2 int) comment 'u3_1 {u3} > t5_c (copy )';
create trigger r_i after insert on t5 execute insert into t5_c values (obj.c1, obj.c2) comment 'u3_1 {u3} > r_i (insert)';
create trigger r_u after update on t5 (c2) execute update t5_c set c2 = obj.c2 where c1 = obj.c1 comment 'u3_1 {u3} > r_u (update)';
create trigger r_d before delete on t5 execute reject comment 'u3_1 {u3} > r_d (delete)';
create function j3_1 (arg1 int comment 'u3_1 {u3} > j3_1 > arg1 (in)', arg2 out int comment 'u3_1 {u3} > j3_1 > arg2 (out)') return int
  as language java name 'Test.j3_1(int) return int' comment 'u3_1 {u3} > j3_1 (function)';
create server s1 (host='localhost', port=33000, dbname=basic, user=dba, comment='u3_1 {u3} > s1 (dblink)');




call login ('u1') on class db_user;
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




call login ('u1_1') on class db_user;
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




call login ('u2') on class db_user;
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




call login ('u2_1') on class db_user;
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




call login ('u3') on class db_user;
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




call login ('u3_1') on class db_user;
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
select * from db_charset;
select * from db_collation;

drop table u1.t1;
drop view u1.v1;
drop table u1.t2_r;
drop table u1.t2_h;
drop table u1.t2_l;
drop table u1.t3_d;
drop table u1.t3_s;
drop table u1.t3;
drop table u1.t4;
drop table u1.t5;
drop table u1.t5_c;
drop function j1;
drop server u1.s1;

drop table u1_1.t1;
drop view u1_1.v1;
drop table u1_1.t2_r;
drop table u1_1.t2_h;
drop table u1_1.t2_l;
drop table u1_1.t3_d;
drop table u1_1.t3_s;
drop table u1_1.t3;
drop table u1_1.t4;
drop table u1_1.t5;
drop table u1_1.t5_c;
drop function j1_1;
drop server u1_1.s1;

drop table u2.t1;
drop view u2.v1;
drop table u2.t2_r;
drop table u2.t2_h;
drop table u2.t2_l;
drop table u2.t3_d;
drop table u2.t3_s;
drop table u2.t3;
drop table u2.t4;
drop table u2.t5;
drop table u2.t5_c;
drop function j2;
drop server u2.s1;

drop table u2_1.t1;
drop view u2_1.v1;
drop table u2_1.t2_r;
drop table u2_1.t2_h;
drop table u2_1.t2_l;
drop table u2_1.t3_d;
drop table u2_1.t3_s;
drop table u2_1.t3;
drop table u2_1.t4;
drop table u2_1.t5;
drop table u2_1.t5_c;
drop function j2_1;
drop server u2_1.s1;

drop table u3.t1;
drop view u3.v1;
drop table u3.t2_r;
drop table u3.t2_h;
drop table u3.t2_l;
drop table u3.t3_d;
drop table u3.t3_s;
drop table u3.t3;
drop table u3.t4;
drop table u3.t5;
drop table u3.t5_c;
drop function j3;
drop server u3.s1;

drop table u3_1.t1;
drop view u3_1.v1;
drop table u3_1.t2_r;
drop table u3_1.t2_h;
drop table u3_1.t2_l;
drop table u3_1.t3_d;
drop table u3_1.t3_s;
drop table u3_1.t3;
drop table u3_1.t4;
drop table u3_1.t5;
drop table u3_1.t5_c;
drop function j3_1;
drop server u3_1.s1;

drop user u1;
drop user u1_1;
drop user u2;
drop user u2_1;
drop user u3;
drop user u3_1;
