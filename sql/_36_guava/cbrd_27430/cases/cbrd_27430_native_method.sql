/**
 *  This test case verifies CBRD-27430: the folded server (the CAS request loop and the client
 *  compiler run inside cub_server) refuses every user-defined native C method with -237.
 *
 *  Before the fold a cub_cas process loaded the method file with dlopen and reported the link
 *  outcome: -294 when the FILE environment variable was unset, -889 wrapping a link failure, or
 *  the method result when the file was good. The folded server refuses the method before any
 *  file is looked at (sm_dynamic_link_class), on the method scan path of a SELECT and on the
 *  CALL path alike, so a native method never loads code into cub_server.
 *
 *  How judged: literal expected values (no switch runs the old path). Each refusal is the
 *  Error:-237 block; the PL/CSQL function and the builtin class method are controls that must
 *  keep working, so a refusal that is too wide shows up as a changed control block. The
 *  pre-fold build prints -294 for Case 1 and Case 2 and is expected to fail them.
 *
 *  Coverage:
 *    Case 1:  native method in a SELECT list (method scan); result = Error:-237
 *    Case 2:  the same method through CALL ... ON an instance; result = Error:-237
 *    Case 3:  a method whose FILE is a plain path, not an environment variable; result = Error:-237
 *    Case 4:  control: a PL/CSQL function on the same session still evaluates; result = 2
 *    Case 5:  control: the builtin class method find_user of db_user still resolves; result = the class object (_db_user)
 */

drop table if exists tb_native, tb_native_path;

-- one instance is enough: the refusal happens when the method is linked, before any row is read
create class tb_native (a int) dont_reuse_oid method m_add (int, int) int function m_add_fn file '$CBRD_NO_SUCH_METHOD_FILE';
insert into tb_native values (1);
create class tb_native_path (a int) dont_reuse_oid method m_path (int) int function m_path_fn file 'no_such_method_file.so';
insert into tb_native_path values (1);
create or replace function f_plus_one (i int) return int as begin return i + 1; end;


evaluate 'Case 1: native method in a SELECT list; result = Error:-237';
select m_add (t, 1, 2) from tb_native t;


evaluate 'Case 2: native method through CALL ... ON an instance; result = Error:-237';
select t into :obj_native from tb_native t where a = 1;
call m_add (1, 2) on :obj_native;


evaluate 'Case 3: native method whose FILE is a plain path; result = Error:-237';
select m_path (t, 1) from tb_native_path t;


evaluate 'Case 4: control: a PL/CSQL function still evaluates; result = 2';
select f_plus_one (1) from db_root;


evaluate 'Case 5: control: a builtin class method still resolves; result = the db_user class object';
call find_user ('DBA') on class db_user;


drop function f_plus_one;
drop table tb_native, tb_native_path;
