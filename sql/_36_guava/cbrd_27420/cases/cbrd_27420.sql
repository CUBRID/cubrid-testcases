/**
 *  This test case verifies CBRD-27420: CREATE [OR REPLACE] SENSITIVITY LABEL
 *  ON COLUMN and DROP SENSITIVITY LABEL ON COLUMN, ON ALL COLUMNS IN TABLE and
 *  IN SCHEMA.
 *
 *  Each case labels or unlabels columns of its own tables and then reads
 *  db_sensitivity_label for those tables. A refused statement is followed by
 *  the same read, which shows that it changed no label.
 *
 *  Coverage:
 *    Case 1:  CREATE labels only the named column, with GRADE alone or with
 *             INFO_TYPE and SOURCE
 *    Case 2:  the items can be written in any order, and a registered name
 *             matches in any letter case
 *    Case 3:  CREATE OR REPLACE creates a label or replaces the whole label,
 *             and CREATE on a labelled column fails
 *    Case 4:  a column list labels every listed column, and a schema prefix
 *             picks the owner
 *    Case 5:  DROP ON COLUMN removes the labels of the listed columns only
 *    Case 6:  DROP ON ALL COLUMNS IN TABLE removes the labels of the listed
 *             tables only
 *    Case 7:  DROP ON ALL COLUMNS IN SCHEMA removes the labels of the listed
 *             owners only
 *    Case 8:  DROP ON COLUMN of an unlabelled column fails, DROP of a table or
 *             schema with no label succeeds, and a missing table or schema
 *             fails
 *    Case 9:  a system class, a view, a synonym, a SHARED and a CLASS
 *             attribute cannot be labelled
 *    Case 10: a partition column cannot be labelled or unlabelled, while the
 *             partitioned table can, and DROP ON ALL COLUMNS IN TABLE of a
 *             partition succeeds and keeps the label of the partitioned table
 *    Case 11: each item takes only a registered name of its own kind
 *    Case 12: a repeated item, a missing GRADE and a repeated column are
 *             refused
 *    Case 13: one failing target fails the whole statement, and ROLLBACK
 *             undoes a label statement
 *    Case 14: ALTER ON SENSITIVITY LABEL held directly or through DBA
 *             membership allows every label statement, a grant to a group or
 *             to PUBLIC allows CREATE, and CREATE fails after REVOKE
 *    Case 15: a table owner without ALTER ON SENSITIVITY LABEL cannot run any
 *             label statement
 *    Case 16: labeled_by and updated_time follow the last CREATE or CREATE OR
 *             REPLACE while created_time stays, and dropping that user keeps
 *             the label
 *    Case 17: LIKE, AS SELECT, UNDER and PROMOTE PARTITION copy no label
 *    Case 18: an inherited column is labelled per class, and INHERIT OF and
 *             DROP SUPERCLASS remove its label
 *    Case 19: RENAME COLUMN, MODIFY, OWNER TO, PARTITION BY and REMOVE
 *             PARTITIONING keep the labels
 *    Case 20: DROP COLUMN and DROP TABLE remove the labels with object
 *             privileges only
 *    Case 21: a referenced grade, info_type or source cannot be dropped, and a
 *             label shows its new name after a rename
 *    Case 22: the labels and the registered names of this test are gone after
 *             cleanup
 */
--+ holdcas on;
drop table if exists t_create, t_order, t_replace, t_list, t_list2, t_owner, t_dcol, t_dcol2, t_dtab, t_dtab2, t_dtab3, t_dtab4;
drop table if exists t_dsch, t_none, t_view, t_part, t_reg, t_dup, t_atom, t_atom2, t_atom_log;
drop table if exists t_by, t_src, t_like, t_as, t_prom, t_prom__p__p0, t_ren, t_mod, t_own19, t_pby, t_rmp, t_rmp_empty;
drop table if exists t_dcol20, t_dtab20, t_pdrop20, t_ref;
drop view if exists v_label;
drop synonym if exists s_label;
drop class if exists x_shared, c_before, c_after, p_src, c_inh, p_inh, q_inh, c_drop_super, p_drop_super;

create sensitivity label grade 'g1' level 1;
create sensitivity label grade 'g2' level 2;
create sensitivity label info_type 'i1';
create sensitivity label source 's1';
-- the owner of the tables named like DBA tables in Case 4 to Case 6
create user u_other;

evaluate 'Case 1: CREATE labels only the named column, with GRADE alone or with INFO_TYPE and SOURCE';
create table t_create (a int, b int, c int, d int, e int);
create sensitivity label on column t_create.a (grade = 'g1');
create sensitivity label on column t_create.b (grade = 'g1', info_type = 'i1', source = 's1');
create sensitivity label on column t_create.c (grade = 'g1', info_type = 'i1');
create sensitivity label on column t_create.d (grade = 'g1', source = 's1');
select owner_name, class_name, attr_name, grade, info_type, source, labeled_by from db_sensitivity_label where class_name = 't_create' order by 1, 2, 3;

evaluate 'Case 2: the items can be written in any order, and a registered name matches in any letter case';
create table t_order (a int, b int, c int, d int);
create sensitivity label on column t_order.a (info_type = 'i1', grade = 'g1');
create sensitivity label on column t_order.b (source = 's1', info_type = 'i1', grade = 'g1');
create sensitivity label on column t_order.c (source = 's1', grade = 'g1');
create sensitivity label on column t_order.d (grade = 'G1', info_type = 'I1', source = 'S1');
select owner_name, class_name, attr_name, grade, info_type, source, labeled_by from db_sensitivity_label where class_name = 't_order' order by 1, 2, 3;

evaluate 'Case 3: CREATE OR REPLACE creates a label or replaces the whole label, and CREATE on a labelled column fails';
create table t_replace (a int, b int);
create or replace sensitivity label on column t_replace.a (grade = 'g1');
create sensitivity label on column t_replace.b (grade = 'g1', info_type = 'i1', source = 's1');
create or replace sensitivity label on column t_replace.b (grade = 'g2');
-- expected error: t_replace.a already has a label
create sensitivity label on column t_replace.a (grade = 'g2');
select owner_name, class_name, attr_name, grade, info_type, source, labeled_by from db_sensitivity_label where class_name = 't_replace' order by 1, 2, 3;

evaluate 'Case 4: a column list labels every listed column, and a schema prefix picks the owner';
create table t_list (a int, b int, c int);
create table t_list2 (a int);
create sensitivity label on column t_list.a, t_list.b, t_list2.a (grade = 'g1');
create table t_owner (a int);
create table u_other.t_owner (a int);
create sensitivity label on column u_other.t_owner.a (grade = 'g1');
select owner_name, class_name, attr_name, grade, info_type, source, labeled_by from db_sensitivity_label where class_name in ('t_list', 't_list2', 't_owner') order by 1, 2, 3;

evaluate 'Case 5: DROP ON COLUMN removes the labels of the listed columns only';
create table t_dcol (a int, b int);
create table t_dcol2 (a int, b int);
create table u_other.t_dcol (a int);
create sensitivity label on column t_dcol.a, t_dcol.b, t_dcol2.a, t_dcol2.b, u_other.t_dcol.a (grade = 'g1');
drop sensitivity label on column t_dcol.a;
select owner_name, class_name, attr_name from db_sensitivity_label where class_name in ('t_dcol', 't_dcol2') order by 1, 2, 3;
drop sensitivity label on column t_dcol.b, t_dcol2.a;
select owner_name, class_name, attr_name from db_sensitivity_label where class_name in ('t_dcol', 't_dcol2') order by 1, 2, 3;
drop sensitivity label on column u_other.t_dcol.a;
select owner_name, class_name, attr_name from db_sensitivity_label where class_name in ('t_dcol', 't_dcol2') order by 1, 2, 3;

evaluate 'Case 6: DROP ON ALL COLUMNS IN TABLE removes the labels of the listed tables only';
create table t_dtab (a int, b int);
create table t_dtab2 (a int);
create table t_dtab3 (a int);
create table t_dtab4 (a int);
create table u_other.t_dtab2 (a int);
create sensitivity label on column t_dtab.a, t_dtab.b, t_dtab2.a, t_dtab3.a, t_dtab4.a, u_other.t_dtab2.a (grade = 'g1');
drop sensitivity label on all columns in table t_dtab;
select owner_name, class_name, attr_name from db_sensitivity_label where class_name in ('t_dtab', 't_dtab2', 't_dtab3', 't_dtab4') order by 1, 2, 3;
drop sensitivity label on all columns in table u_other.t_dtab2;
select owner_name, class_name, attr_name from db_sensitivity_label where class_name in ('t_dtab', 't_dtab2', 't_dtab3', 't_dtab4') order by 1, 2, 3;
drop sensitivity label on all columns in table t_dtab2, t_dtab3;
select owner_name, class_name, attr_name from db_sensitivity_label where class_name in ('t_dtab', 't_dtab2', 't_dtab3', 't_dtab4') order by 1, 2, 3;

evaluate 'Case 7: DROP ON ALL COLUMNS IN SCHEMA removes the labels of the listed owners only';
create user u_sch1;
create user u_sch2;
create user u_sch3;
create table t_dsch (a int);
create table u_sch1.t_dsch (a int);
create table u_sch1.t_dsch2 (a int);
create table u_sch2.t_dsch (a int);
create table u_sch3.t_dsch (a int);
create sensitivity label on column t_dsch.a, u_sch1.t_dsch.a, u_sch1.t_dsch2.a, u_sch2.t_dsch.a, u_sch3.t_dsch.a (grade = 'g1');
drop sensitivity label on all columns in schema u_sch1;
select owner_name, class_name, attr_name from db_sensitivity_label where class_name in ('t_dsch', 't_dsch2') order by 1, 2, 3;
drop sensitivity label on all columns in schema u_sch2, u_sch3;
select owner_name, class_name, attr_name from db_sensitivity_label where class_name in ('t_dsch', 't_dsch2') order by 1, 2, 3;

evaluate 'Case 8: DROP ON COLUMN of an unlabelled column fails, DROP of a table or schema with no label succeeds, and a missing table or schema fails';
create user u_nolabel;
create user u_labelled;
create table t_none (a int, b int);
create table u_labelled.t_none (a int);
create sensitivity label on column t_none.a, u_labelled.t_none.a (grade = 'g1');
-- expected error: t_none.b has no label
drop sensitivity label on column t_none.b;
select owner_name, class_name, attr_name from db_sensitivity_label where class_name = 't_none' order by 1, 2, 3;
drop sensitivity label on column t_none.a;
drop sensitivity label on all columns in table t_none;
drop sensitivity label on all columns in schema u_nolabel;
-- expected errors: no table t_missing, no user u_missing
drop sensitivity label on all columns in table t_missing;
drop sensitivity label on all columns in schema u_missing;
select owner_name, class_name, attr_name from db_sensitivity_label where class_name = 't_none' order by 1, 2, 3;
drop sensitivity label on all columns in schema u_labelled;
select owner_name, class_name, attr_name from db_sensitivity_label where class_name = 't_none' order by 1, 2, 3;

evaluate 'Case 9: a system class, a view, a synonym, a SHARED and a CLASS attribute cannot be labelled';
create table t_view (a int, b int);
create view v_label as select a, b from t_view;
create synonym s_label for t_view;
create sensitivity label on column t_view.b (grade = 'g1');
create class x_shared class attribute (c int) (a int, s int shared 1);
-- expected errors: a system class, a view, a synonym
create sensitivity label on column _db_class.class_name (grade = 'g1');
create sensitivity label on column v_label.a (grade = 'g1');
drop sensitivity label on column v_label.b;
create sensitivity label on column s_label.a (grade = 'g1');
-- the synonym itself resolves to t_view
select count(*) from s_label;
-- expected errors: a SHARED attribute and a CLASS attribute
create sensitivity label on column x_shared.s (grade = 'g1');
drop sensitivity label on column x_shared.s;
create sensitivity label on column x_shared.c (grade = 'g1');
create sensitivity label on column x_shared.a (grade = 'g1');
select owner_name, class_name, attr_name from db_sensitivity_label where class_name in ('_db_class', 't_view', 'v_label', 's_label', 'x_shared') order by 1, 2, 3;

evaluate 'Case 10: a partition column cannot be labelled or unlabelled, while the partitioned table can, and DROP ON ALL COLUMNS IN TABLE of a partition succeeds and keeps the label of the partitioned table';
create table t_part (a int, b int) partition by range (a) (partition p0 values less than (10), partition p1 values less than (100));
insert into t_part values (1, 1), (50, 50);
-- expected error: a partition
create sensitivity label on column t_part__p__p0.a (grade = 'g1');
create sensitivity label on column t_part.b (grade = 'g1');
-- expected error: a partition
drop sensitivity label on column t_part__p__p1.b;
drop sensitivity label on all columns in table t_part__p__p0;
select owner_name, class_name, attr_name from db_sensitivity_label where class_name in ('t_part', 't_part__p__p0', 't_part__p__p1') order by 1, 2, 3;

evaluate 'Case 11: each item takes only a registered name of its own kind';
create table t_reg (a int, b int);
create sensitivity label on column t_reg.b (grade = 'g1', info_type = 'i1', source = 's1');
-- expected errors: s1 is a source, g1 is a grade, i1 is an info_type, zz is not registered
create sensitivity label on column t_reg.a (grade = 's1');
create sensitivity label on column t_reg.a (grade = 'g1', info_type = 'g1');
create sensitivity label on column t_reg.a (grade = 'g1', source = 'i1');
create sensitivity label on column t_reg.a (grade = 'zz');
select owner_name, class_name, attr_name, grade, info_type, source from db_sensitivity_label where class_name = 't_reg' order by 1, 2, 3;

evaluate 'Case 12: a repeated item, a missing GRADE and a repeated column are refused';
create user u_dup;
create table t_dup (a int);
create table u_dup.t_dup (a int);
-- expected errors: GRADE, INFO_TYPE and SOURCE twice, then no GRADE
create sensitivity label on column t_dup.a (grade = 'g1', grade = 'g1');
create sensitivity label on column t_dup.a (grade = 'g1', info_type = 'i1', info_type = 'i1');
create sensitivity label on column t_dup.a (grade = 'g1', source = 's1', source = 's1');
create sensitivity label on column t_dup.a (info_type = 'i1');
-- expected errors: the same column twice, also with the owner written out and in upper case
create sensitivity label on column t_dup.a, t_dup.a (grade = 'g1');
create sensitivity label on column t_dup.a, dba.t_dup.a (grade = 'g1');
create sensitivity label on column t_dup.a, T_DUP.A (grade = 'g1');
select owner_name, class_name, attr_name, grade, info_type, source from db_sensitivity_label where class_name = 't_dup' order by 1, 2, 3;
-- two owners make two columns
create sensitivity label on column u_dup.t_dup.a, t_dup.a (grade = 'g1', info_type = 'i1', source = 's1');
-- expected errors: the same column twice
create or replace sensitivity label on column t_dup.a, t_dup.a (grade = 'g2');
drop sensitivity label on column t_dup.a, t_dup.a;
select owner_name, class_name, attr_name, grade, info_type, source from db_sensitivity_label where class_name = 't_dup' order by 1, 2, 3;

evaluate 'Case 13: one failing target fails the whole statement, and ROLLBACK undoes a label statement';
create table t_atom (a int, b int);
create table t_atom2 (a int, b int);
-- each failing statement below runs after an insert into t_atom_log, which its COMMIT keeps
create table t_atom_log (n int);
create sensitivity label on column t_atom.b, t_atom2.a (grade = 'g1');
autocommit off;
insert into t_atom_log values (1);
-- expected error: t_atom has no column nosuch
create sensitivity label on column t_atom.a, t_atom.nosuch (grade = 'g1');
commit;
insert into t_atom_log values (2);
-- expected error: t_atom2.b has no label
drop sensitivity label on column t_atom2.a, t_atom2.b;
commit;
insert into t_atom_log values (3);
-- expected error: no table t_missing
drop sensitivity label on all columns in table t_atom2, t_missing;
commit;
insert into t_atom_log values (4);
-- expected error: no user u_missing
drop sensitivity label on all columns in schema dba, u_missing;
commit;
select n from t_atom_log order by n;
select owner_name, class_name, attr_name from db_sensitivity_label where class_name in ('t_atom', 't_atom2') order by 1, 2, 3;
create sensitivity label on column t_atom.a (grade = 'g2');
drop sensitivity label on column t_atom.b;
select owner_name, class_name, attr_name, grade from db_sensitivity_label where class_name in ('t_atom', 't_atom2') order by 1, 2, 3;
rollback;
select owner_name, class_name, attr_name, grade from db_sensitivity_label where class_name in ('t_atom', 't_atom2') order by 1, 2, 3;
autocommit on;

evaluate 'Case 14: ALTER ON SENSITIVITY LABEL held directly or through DBA membership allows every label statement, a grant to a group or to PUBLIC allows CREATE, and CREATE fails after REVOKE';
create user u_priv_owner;
create user u_priv_schema;
create user u_alter;
create user m_alter groups dba;
create user g_alter;
create user u_alter_member groups g_alter;
create user u_public;
create table u_priv_owner.t_priv (a int, b int, c int, d int, e int);
create table u_priv_owner.t_priv_tab (a int);
create table u_priv_schema.t_priv (a int);
grant alter on sensitivity label to u_alter;
grant alter on sensitivity label to g_alter;
create sensitivity label on column u_priv_owner.t_priv_tab.a, u_priv_schema.t_priv.a (grade = 'g1');
-- u_alter holds no privilege on the tables of u_priv_owner and u_priv_schema
call login('u_alter', '') on class db_user;
create sensitivity label on column u_priv_owner.t_priv.a (grade = 'g1');
create sensitivity label on column u_priv_owner.t_priv.b (grade = 'g1');
create or replace sensitivity label on column u_priv_owner.t_priv.b (grade = 'g2');
create sensitivity label on column u_priv_owner.t_priv.c (grade = 'g1');
drop sensitivity label on column u_priv_owner.t_priv.c;
drop sensitivity label on all columns in table u_priv_owner.t_priv_tab;
drop sensitivity label on all columns in schema u_priv_schema;
call login('dba', '') on class db_user;
select owner_name, class_name, attr_name, grade, labeled_by from db_sensitivity_label where owner_name in ('U_PRIV_OWNER', 'U_PRIV_SCHEMA') order by 1, 2, 3;
drop sensitivity label on all columns in table u_priv_owner.t_priv;
create sensitivity label on column u_priv_owner.t_priv_tab.a, u_priv_schema.t_priv.a (grade = 'g1');
call login('m_alter', '') on class db_user;
create sensitivity label on column u_priv_owner.t_priv.a (grade = 'g1');
create sensitivity label on column u_priv_owner.t_priv.b (grade = 'g1');
create or replace sensitivity label on column u_priv_owner.t_priv.b (grade = 'g2');
create sensitivity label on column u_priv_owner.t_priv.c (grade = 'g1');
drop sensitivity label on column u_priv_owner.t_priv.c;
drop sensitivity label on all columns in table u_priv_owner.t_priv_tab;
drop sensitivity label on all columns in schema u_priv_schema;
call login('dba', '') on class db_user;
select owner_name, class_name, attr_name, grade, labeled_by from db_sensitivity_label where owner_name in ('U_PRIV_OWNER', 'U_PRIV_SCHEMA') order by 1, 2, 3;
call login('u_alter_member', '') on class db_user;
create sensitivity label on column u_priv_owner.t_priv.c (grade = 'g1');
call login('dba', '') on class db_user;
grant alter on sensitivity label to public;
call login('u_public', '') on class db_user;
create sensitivity label on column u_priv_owner.t_priv.d (grade = 'g1');
call login('dba', '') on class db_user;
revoke alter on sensitivity label from public;
revoke alter on sensitivity label from u_alter;
call login('u_alter', '') on class db_user;
-- expected error: u_alter lost the privilege
create sensitivity label on column u_priv_owner.t_priv.e (grade = 'g1');
call login('dba', '') on class db_user;
select owner_name, class_name, attr_name, grade, labeled_by from db_sensitivity_label where owner_name in ('U_PRIV_OWNER', 'U_PRIV_SCHEMA') order by 1, 2, 3;

evaluate 'Case 15: a table owner without ALTER ON SENSITIVITY LABEL cannot run any label statement';
create user u_table_owner;
create table u_table_owner.t_own15 (a int, b int);
create sensitivity label on column u_table_owner.t_own15.a (grade = 'g1');
call login('u_table_owner', '') on class db_user;
-- expected errors: no ALTER ON SENSITIVITY LABEL
create sensitivity label on column t_own15.b (grade = 'g1');
create or replace sensitivity label on column t_own15.a (grade = 'g2');
drop sensitivity label on column t_own15.a;
drop sensitivity label on all columns in table t_own15;
drop sensitivity label on all columns in schema u_table_owner;
call login('dba', '') on class db_user;
select owner_name, class_name, attr_name, grade, labeled_by from db_sensitivity_label where class_name = 't_own15' order by 1, 2, 3;

evaluate 'Case 16: labeled_by and updated_time follow the last CREATE or CREATE OR REPLACE while created_time stays, and dropping that user keeps the label';
create user u_by;
create user m_by groups dba;
create table t_by (a int, b int);
grant alter on sensitivity label to u_by;
set @create_start = sys_datetime;
create sensitivity label on column t_by.a (grade = 'g1');
set @create_end = sys_datetime;
select attr_name, labeled_by, updated_time between @create_start and @create_end from db_sensitivity_label where class_name = 't_by' order by 1;
call login('u_by', '') on class db_user;
set @replace_start = sys_datetime;
create or replace sensitivity label on column dba.t_by.a (grade = 'g2');
set @replace_end = sys_datetime;
call login('m_by', '') on class db_user;
create sensitivity label on column dba.t_by.b (grade = 'g1');
call login('dba', '') on class db_user;
drop user m_by;
select attr_name, grade, labeled_by from db_sensitivity_label where class_name = 't_by' order by 1;
select created_time between @create_start and @create_end, updated_time between @replace_start and @replace_end from db_sensitivity_label where class_name = 't_by' and attr_name = 'a';
drop variable @create_start, @create_end, @replace_start, @replace_end;

evaluate 'Case 17: LIKE, AS SELECT, UNDER and PROMOTE PARTITION copy no label';
create table t_src (a int);
create class p_src (a int);
create class c_before under p_src;
create table t_prom (a int) partition by range (a) (partition p0 values less than (10), partition p1 values less than (100));
create sensitivity label on column t_src.a, p_src.a, t_prom.a (grade = 'g1');
create table t_like like t_src;
create table t_as as select * from t_src;
create class c_after under p_src;
alter table t_prom promote partition p0;
select owner_name, class_name, attr_name from db_sensitivity_label where class_name in ('t_src', 't_like', 't_as', 'p_src', 'c_before', 'c_after', 't_prom', 't_prom__p__p0') order by 1, 2, 3;

evaluate 'Case 18: an inherited column is labelled per class, and INHERIT OF and DROP SUPERCLASS remove its label';
create class p_inh (a int);
create class q_inh (a int);
create class c_inh under p_inh, q_inh inherit a of p_inh;
create sensitivity label on column c_inh.a (grade = 'g1');
select owner_name, class_name, attr_name, grade from db_sensitivity_label where class_name in ('p_inh', 'c_inh') order by 1, 2, 3;
create sensitivity label on column p_inh.a (grade = 'g2');
drop sensitivity label on column p_inh.a;
select owner_name, class_name, attr_name, grade from db_sensitivity_label where class_name in ('p_inh', 'c_inh') order by 1, 2, 3;
-- c_inh.a now comes from q_inh, a new column
alter class c_inh inherit a of q_inh;
select owner_name, class_name, attr_name, grade from db_sensitivity_label where class_name in ('p_inh', 'c_inh') order by 1, 2, 3;
create class p_drop_super (a int, b int);
create class c_drop_super under p_drop_super;
create sensitivity label on column c_drop_super.b (grade = 'g1');
select owner_name, class_name, attr_name, grade from db_sensitivity_label where class_name in ('p_drop_super', 'c_drop_super') order by 1, 2, 3;
alter class c_drop_super drop superclass p_drop_super;
select owner_name, class_name, attr_name, grade from db_sensitivity_label where class_name in ('p_drop_super', 'c_drop_super') order by 1, 2, 3;

evaluate 'Case 19: RENAME COLUMN, MODIFY, OWNER TO, PARTITION BY and REMOVE PARTITIONING keep the labels';
create user u_own19;
create table t_ren (a int);
create table t_mod (a int);
insert into t_mod values (1);
create table t_own19 (a int);
create table t_pby (a int);
insert into t_pby values (1), (2);
create table t_rmp (a int) partition by hash (a) partitions 2;
insert into t_rmp values (1), (2);
create table t_rmp_empty (a int) partition by hash (a) partitions 2;
create sensitivity label on column t_ren.a, t_mod.a, t_own19.a, t_pby.a, t_rmp.a, t_rmp_empty.a (grade = 'g1');
alter table t_ren rename column a as c;
alter table t_mod modify a varchar(10);
alter table t_own19 owner to u_own19;
alter table t_pby partition by hash (a) partitions 2;
alter table t_rmp remove partitioning;
alter table t_rmp_empty remove partitioning;
select data_type from db_attribute where class_name = 't_mod' and attr_name = 'a';
select class_name, count(*) from db_partition where class_name in ('t_pby', 't_rmp', 't_rmp_empty') group by class_name order by 1;
select owner_name, class_name, attr_name, grade from db_sensitivity_label where class_name in ('t_ren', 't_mod', 't_own19', 't_pby', 't_rmp', 't_rmp_empty') order by 1, 2, 3;

evaluate 'Case 20: DROP COLUMN and DROP TABLE remove the labels with object privileges only';
create sensitivity label grade 'g_column' level 3;
create sensitivity label grade 'g_table' level 4;
create user u_drop20;
create table t_dcol20 (a int, b int, c int);
create table t_dtab20 (a int);
create table t_pdrop20 (a int) partition by hash (a) partitions 2;
create sensitivity label on column t_dcol20.a (grade = 'g_column');
create sensitivity label on column t_dcol20.c, t_pdrop20.a (grade = 'g1');
create sensitivity label on column t_dtab20.a (grade = 'g_table');
-- u_drop20 holds no label privilege
grant alter, select on t_dcol20 to u_drop20;
grant alter on t_dtab20 to u_drop20;
call login('u_drop20', '') on class db_user;
alter table dba.t_dcol20 drop column a;
drop table dba.t_dtab20;
call login('dba', '') on class db_user;
-- c of t_dcol20 keeps its own label after a column before it is gone
select owner_name, class_name, attr_name, grade from db_sensitivity_label where class_name in ('t_dcol20', 't_dtab20', 't_pdrop20') order by 1, 2, 3;
drop sensitivity label grade 'g_column';
drop sensitivity label grade 'g_table';
drop table t_pdrop20;
select name from db_sensitivity_label_grade where name in ('g_column', 'g_table') order by 1;
select owner_name, class_name, attr_name from db_sensitivity_label where class_name in ('t_pdrop20', 't_pdrop20__p__p0', 't_pdrop20__p__p1') order by 1, 2, 3;

evaluate 'Case 21: a referenced grade, info_type or source cannot be dropped, and a label shows its new name after a rename';
create sensitivity label grade 'g_ref' level 5;
create sensitivity label info_type 'i_ref';
create sensitivity label source 's_ref';
create table t_ref (a int);
create sensitivity label on column t_ref.a (grade = 'g_ref', info_type = 'i_ref', source = 's_ref');
-- expected errors: t_ref.a refers to each of them
drop sensitivity label grade 'g_ref';
drop sensitivity label info_type 'i_ref';
drop sensitivity label source 's_ref';
alter sensitivity label grade 'g_ref' rename as 'g_ref_new';
alter sensitivity label info_type 'i_ref' rename as 'i_ref_new';
alter sensitivity label source 's_ref' rename as 's_ref_new';
select owner_name, class_name, attr_name, grade, info_type, source from db_sensitivity_label where class_name = 't_ref' order by 1, 2, 3;
drop sensitivity label on column t_ref.a;
drop sensitivity label grade 'g_ref_new';
drop sensitivity label info_type 'i_ref_new';
drop sensitivity label source 's_ref_new';
select name from db_sensitivity_label_grade where name in ('g_ref', 'g_ref_new')
union all select name from db_sensitivity_label_info_type where name in ('i_ref', 'i_ref_new')
union all select name from db_sensitivity_label_source where name in ('s_ref', 's_ref_new') order by 1;

evaluate 'Case 22: the labels and the registered names of this test are gone after cleanup';
drop table t_create, t_order, t_replace, t_list, t_list2, t_owner, u_other.t_owner, t_dcol, t_dcol2, u_other.t_dcol;
drop table t_dtab, t_dtab2, t_dtab3, t_dtab4, u_other.t_dtab2, t_dsch, u_sch1.t_dsch, u_sch1.t_dsch2, u_sch2.t_dsch, u_sch3.t_dsch;
drop table t_none, u_labelled.t_none, t_part, t_reg, t_dup, u_dup.t_dup, t_atom, t_atom2, t_atom_log;
drop table u_priv_owner.t_priv, u_priv_owner.t_priv_tab, u_priv_schema.t_priv, u_table_owner.t_own15, t_by;
drop table t_src, t_like, t_as, t_prom, t_prom__p__p0, t_ren, t_mod, u_own19.t_own19, t_pby, t_rmp, t_rmp_empty, t_dcol20, t_ref;
drop view v_label;
drop synonym s_label;
drop table t_view;
drop class x_shared, c_before, c_after, p_src, c_inh, p_inh, q_inh, c_drop_super, p_drop_super;
select count(*) from db_sensitivity_label where grade in ('g1', 'g2');
drop sensitivity label grade 'g1';
drop sensitivity label grade 'g2';
drop sensitivity label info_type 'i1';
drop sensitivity label source 's1';
drop user u_other;
drop user u_sch1;
drop user u_sch2;
drop user u_sch3;
drop user u_nolabel;
drop user u_labelled;
drop user u_dup;
drop user u_priv_owner;
drop user u_priv_schema;
drop user u_alter;
drop user m_alter;
drop user u_alter_member;
drop user g_alter;
drop user u_public;
drop user u_table_owner;
drop user u_by;
drop user u_own19;
drop user u_drop20;
select name from db_sensitivity_label_grade where name in ('g1', 'g2')
union all select name from db_sensitivity_label_info_type where name = 'i1'
union all select name from db_sensitivity_label_source where name = 's1' order by 1;
--+ holdcas off;
