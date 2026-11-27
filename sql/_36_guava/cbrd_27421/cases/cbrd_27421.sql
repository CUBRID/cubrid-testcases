/**
 *  This test case verifies CBRD-27421: db_sensitivity_label and
 *  information_schema.sensitivity_labels show a user the labels of the tables
 *  the user owns or holds SELECT on, as db_class does, and show every label to
 *  a holder of SELECT ON SENSITIVITY LABEL and to the DBA group.
 *  It also verifies SENSITIVITY_LABEL_GRADE_LEVEL, which turns a grade name into
 *  its level, returns NULL for a name not registered, and is open to every user.
 *
 *  Coverage:
 *    Case 1:  dba sees the six labels in both views, with the specified columns
 *    Case 2:  the owner, a member of the owner group, and a SELECT grantee
 *             directly or by group see the labels of their tables and of t_pub,
 *             and a partitioned table shows its label on the root only
 *    Case 3:  INSERT and UPDATE on t_sel, or ALTER ON SENSITIVITY LABEL, show
 *             no label of t_sel
 *    Case 4:  SELECT ON SENSITIVITY LABEL held directly, by group or by PUBLIC,
 *             and the DBA group show every label, and a REVOKE takes it back
 *    Case 5:  revoking SELECT on t_sel hides the label of t_sel
 *    Case 6:  SENSITIVITY_LABEL_GRADE_LEVEL returns the level of the grade whose
 *             name equals its argument in lowercase byte by byte, and NULL for
 *             any other name
 *    Case 7:  a user with no privilege gets the level
 *    Case 8:  the function gives the same level in WHERE, in the select list, in
 *             INSERT and UPDATE, in a view and in a PL/CSQL function
 *    Case 9:  a statement prepared once, or run again with the same text, reads
 *             the grade catalog on each execution, and a rolled back grade has
 *             no level
 *    Case 10: dropping the tables and the labels leaves no label, grade,
 *             info_type or source of this file
 */
drop table if exists t_sel, t_none, t_pub, t_p, t_name, t_level;
drop view if exists v_level;

create sensitivity label grade 'g1' level 3;
create sensitivity label grade 'g2' level 5;
create sensitivity label info_type 'i1';
create sensitivity label source 's1';

create user u_own;
create user g_own;
create user u_group_owner groups g_own;
create user u_sel;
create user g_sel;
create user u_group_sel groups g_sel;
create user u_ins;
create user u_alt;
create user u_label;
create user g_label;
create user u_group_label groups g_label;
create user u_group_dba groups dba;
create user u_none;

create table t_sel (a int);
create table t_none (a int);
create table t_pub (a int);
create table t_p (a int) partition by range (a) (partition p_low values less than (10), partition p_high values less than maxvalue);
create table u_own.t_own (a int);
create table g_own.t_go (a int);
grant select on t_pub to public;
grant select on t_sel to u_sel;
grant select on t_p to u_sel;
grant select on t_sel to g_sel;
grant insert, update on t_sel to u_ins;
grant alter on sensitivity label to u_alt;
grant select on sensitivity label to u_label;
grant select on sensitivity label to g_label;

create sensitivity label on column t_sel.a (grade = 'g1', info_type = 'i1', source = 's1');
create sensitivity label on column t_none.a (grade = 'g2');
create sensitivity label on column t_pub.a (grade = 'g1', info_type = 'i1');
create sensitivity label on column t_p.a (grade = 'g2', source = 's1');
create sensitivity label on column u_own.t_own.a (grade = 'g1');
create sensitivity label on column g_own.t_go.a (grade = 'g2');

-- Every query below reads only the labels of this file, so a label another file leaves does not change it.
-- The IN lists name the two partitions of t_p, so a label shown on a partition would print.
evaluate 'Case 1: dba sees the six labels in both views, with the specified columns';
select table_catalog = database () as is_current_db, table_schema, table_name, column_name, grade, grade_level, info_type, source, labeled_by
from information_schema.sensitivity_labels
where table_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
order by table_schema, table_name, column_name;
select 'L' as view_name, owner_name, class_name, attr_name, grade, grade_level from db_sensitivity_label
where class_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
union all
select 'I', table_schema, table_name, column_name, grade, grade_level from information_schema.sensitivity_labels
where table_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
order by 1, 2, 3, 4;

evaluate 'Case 2: u_own sees the labels of t_own and t_pub';
call login ('u_own', '') on class db_user;
select 'L' as view_name, owner_name, class_name, attr_name from db_sensitivity_label
where class_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
union all
select 'I', table_schema, table_name, column_name from information_schema.sensitivity_labels
where table_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
order by 1, 2, 3, 4;
evaluate 'Case 2: u_group_owner, a member of the owner g_own, sees the labels of t_go and t_pub';
call login ('u_group_owner', '') on class db_user;
select 'L' as view_name, owner_name, class_name, attr_name from db_sensitivity_label
where class_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
union all
select 'I', table_schema, table_name, column_name from information_schema.sensitivity_labels
where table_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
order by 1, 2, 3, 4;
evaluate 'Case 2: u_sel sees the labels of t_sel, t_pub and the root of t_p';
call login ('u_sel', '') on class db_user;
select 'L' as view_name, owner_name, class_name, attr_name from db_sensitivity_label
where class_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
union all
select 'I', table_schema, table_name, column_name from information_schema.sensitivity_labels
where table_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
order by 1, 2, 3, 4;
evaluate 'Case 2: u_group_sel, a member of g_sel granted SELECT on t_sel, sees the labels of t_sel and t_pub';
call login ('u_group_sel', '') on class db_user;
select 'L' as view_name, owner_name, class_name, attr_name from db_sensitivity_label
where class_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
union all
select 'I', table_schema, table_name, column_name from information_schema.sensitivity_labels
where table_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
order by 1, 2, 3, 4;

evaluate 'Case 3: u_ins, granted INSERT and UPDATE on t_sel, sees the label of t_pub only';
call login ('u_ins', '') on class db_user;
select 'L' as view_name, owner_name, class_name, attr_name from db_sensitivity_label
where class_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
union all
select 'I', table_schema, table_name, column_name from information_schema.sensitivity_labels
where table_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
order by 1, 2, 3, 4;
evaluate 'Case 3: u_alt, granted ALTER ON SENSITIVITY LABEL, sees the label of t_pub only';
call login ('u_alt', '') on class db_user;
select 'L' as view_name, owner_name, class_name, attr_name from db_sensitivity_label
where class_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
union all
select 'I', table_schema, table_name, column_name from information_schema.sensitivity_labels
where table_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
order by 1, 2, 3, 4;

evaluate 'Case 4: u_label, granted SELECT ON SENSITIVITY LABEL, sees the six labels';
call login ('u_label', '') on class db_user;
select 'L' as view_name, owner_name, class_name, attr_name from db_sensitivity_label
where class_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
union all
select 'I', table_schema, table_name, column_name from information_schema.sensitivity_labels
where table_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
order by 1, 2, 3, 4;
evaluate 'Case 4: u_group_label, a member of g_label granted SELECT ON SENSITIVITY LABEL, sees the six labels';
call login ('u_group_label', '') on class db_user;
select 'L' as view_name, owner_name, class_name, attr_name from db_sensitivity_label
where class_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
union all
select 'I', table_schema, table_name, column_name from information_schema.sensitivity_labels
where table_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
order by 1, 2, 3, 4;
evaluate 'Case 4: u_group_dba, a member of the DBA group, sees the six labels';
call login ('u_group_dba', '') on class db_user;
select 'L' as view_name, owner_name, class_name, attr_name from db_sensitivity_label
where class_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
union all
select 'I', table_schema, table_name, column_name from information_schema.sensitivity_labels
where table_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
order by 1, 2, 3, 4;
evaluate 'Case 4: u_none sees the six labels while PUBLIC holds SELECT ON SENSITIVITY LABEL';
call login ('dba', '') on class db_user;
grant select on sensitivity label to public;
call login ('u_none', '') on class db_user;
select 'L' as view_name, owner_name, class_name, attr_name from db_sensitivity_label
where class_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
union all
select 'I', table_schema, table_name, column_name from information_schema.sensitivity_labels
where table_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
order by 1, 2, 3, 4;
evaluate 'Case 4: after REVOKE from PUBLIC, u_none sees the label of t_pub only';
call login ('dba', '') on class db_user;
revoke select on sensitivity label from public;
call login ('u_none', '') on class db_user;
select 'L' as view_name, owner_name, class_name, attr_name from db_sensitivity_label
where class_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
union all
select 'I', table_schema, table_name, column_name from information_schema.sensitivity_labels
where table_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
order by 1, 2, 3, 4;
evaluate 'Case 4: after REVOKE from u_label, u_label sees the label of t_pub only';
call login ('dba', '') on class db_user;
revoke select on sensitivity label from u_label;
call login ('u_label', '') on class db_user;
select 'L' as view_name, owner_name, class_name, attr_name from db_sensitivity_label
where class_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
union all
select 'I', table_schema, table_name, column_name from information_schema.sensitivity_labels
where table_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
order by 1, 2, 3, 4;

evaluate 'Case 5: after REVOKE SELECT on t_sel, u_sel sees the labels of t_p and t_pub only';
call login ('dba', '') on class db_user;
revoke select on t_sel from u_sel;
call login ('u_sel', '') on class db_user;
select 'L' as view_name, owner_name, class_name, attr_name from db_sensitivity_label
where class_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
union all
select 'I', table_schema, table_name, column_name from information_schema.sensitivity_labels
where table_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go')
order by 1, 2, 3, 4;
call login ('dba', '') on class db_user;

evaluate 'Case 6: g1 is 3 and g2 is 5, and a name not registered, NULL and the empty string are NULL';
-- 'G4' is stored as the grade name g4, 'g1 ' with its trailing space is a grade of its own,
-- and the 254-byte name is the longest a grade name can be.
-- CTP creates the database with the en_US locale, so a literal without a charset introducer is ISO-8859-1.
create sensitivity label grade 'G4' level 4;
create sensitivity label grade 'g1 ' level 9;
create sensitivity label grade 'é' level 11;
create sensitivity label grade 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' level 13;
select sensitivity_label_grade_level ('g1') as g1, sensitivity_label_grade_level ('g2') as g2,
  sensitivity_label_grade_level ('g9') as g9, sensitivity_label_grade_level (null) as null_name,
  sensitivity_label_grade_level ('') as empty_name;
evaluate 'Case 6: the argument is lowercased, so G1 is 3, and g4 and G4 are 4';
select sensitivity_label_grade_level ('G1') as upper_g1, sensitivity_label_grade_level ('g4') as g4,
  sensitivity_label_grade_level ('G4') as upper_g4;
evaluate 'Case 6: a trailing space is part of the name, so g1 with a space is 9 and g1 padded as CHAR(10) is NULL';
select sensitivity_label_grade_level ('g1 ') as g1_space, sensitivity_label_grade_level (cast ('g1' as char(10))) as g1_char10;
evaluate 'Case 6: g1 written in utf8 is 3 and the non-ASCII name is 11';
select sensitivity_label_grade_level (_utf8'g1') as utf8_g1, sensitivity_label_grade_level ('é') as non_ascii_name;
evaluate 'Case 6: the 254-byte name is 13, a 255-byte name and a name with a NUL byte are NULL';
select sensitivity_label_grade_level (repeat ('b', 254)) as name_254, sensitivity_label_grade_level (repeat ('b', 255)) as name_255,
  sensitivity_label_grade_level ('g1' || chr (0)) as g1_nul;

evaluate 'Case 7: u_none, with no privilege, gets 3 for g1';
call login ('u_none', '') on class db_user;
select sensitivity_label_grade_level ('g1') as g1;
call login ('dba', '') on class db_user;

evaluate 'Case 8: the level of each label equals the grade_level column of db_sensitivity_label';
create table t_name (id int primary key, gn varchar(255));
insert into t_name values (1, 'g1'), (2, 'g2'), (3, 'zz'), (4, null);
create table t_level (id int primary key, lv int);
create view v_level as select id, sensitivity_label_grade_level (gn) as lv from t_name;
create function f_level (n varchar) return int as
begin
  return sensitivity_label_grade_level (n);
end;
select class_name, grade, grade_level, sensitivity_label_grade_level (grade) as function_level from db_sensitivity_label
where class_name in ('t_sel', 't_none', 't_pub', 't_p', 't_own', 't_go')
order by class_name;
evaluate 'Case 8: in WHERE, the labels with a level of 5 or more are those of grade g2';
select class_name, grade from db_sensitivity_label
where sensitivity_label_grade_level (grade) >= 5 and class_name in ('t_sel', 't_none', 't_pub', 't_p', 't_own', 't_go')
order by class_name;
evaluate 'Case 8: in the select list, each row gets the level of its column value, and NULL for zz and NULL';
select id, gn, sensitivity_label_grade_level (gn) as lv from t_name order by id;
evaluate 'Case 8: INSERT VALUES stores 5 for g2 and UPDATE SET stores 3 for g1';
insert into t_level values (1, sensitivity_label_grade_level ('g2')), (2, sensitivity_label_grade_level ('g2'));
update t_level set lv = sensitivity_label_grade_level ('g1') where id = 2;
select id, lv from t_level order by id;
evaluate 'Case 8: a view and a PL/CSQL function return the same levels as the select list';
select id, lv from v_level order by id;
select id, f_level (gn) as lv from t_name order by id;

evaluate 'Case 9: one prepared statement returns NULL, then 7 after g3 is created, then NULL after g3 is dropped';
prepare s_level from 'select sensitivity_label_grade_level (''g3'') as g3';
execute s_level;
create sensitivity label grade 'g3' level 7;
execute s_level;
drop sensitivity label grade 'g3';
execute s_level;
deallocate prepare s_level;
evaluate 'Case 9: a select run twice with the same text returns 5, then 6 after g2 is altered to level 6';
select sensitivity_label_grade_level ('g2') as g2;
alter sensitivity label grade 'g2' level 6;
select sensitivity_label_grade_level ('g2') as g2;
evaluate 'Case 9: g5 created in an open transaction is 8, and NULL after ROLLBACK';
autocommit off;
create sensitivity label grade 'g5' level 8;
select sensitivity_label_grade_level ('g5') as g5;
rollback;
select sensitivity_label_grade_level ('g5') as g5;
autocommit on;

evaluate 'Case 10: no label, grade, info_type or source of this file is left';
drop function f_level;
drop view v_level;
drop table t_sel, t_none, t_pub, t_p, t_name, t_level, u_own.t_own, g_own.t_go;
drop sensitivity label grade 'g1';
drop sensitivity label grade 'g2';
drop sensitivity label grade 'G4';
drop sensitivity label grade 'g1 ';
drop sensitivity label grade 'é';
drop sensitivity label grade 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb';
drop sensitivity label info_type 'i1';
drop sensitivity label source 's1';
drop user u_own;
drop user u_group_owner;
drop user g_own;
drop user u_sel;
drop user u_group_sel;
drop user g_sel;
drop user u_ins;
drop user u_alt;
drop user u_label;
drop user u_group_label;
drop user g_label;
drop user u_group_dba;
drop user u_none;

select count (*) from db_sensitivity_label
where class_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go');
select count (*) from information_schema.sensitivity_labels
where table_name in ('t_sel', 't_none', 't_pub', 't_p', 't_p__p__p_low', 't_p__p__p_high', 't_own', 't_go');
select count (*) from db_sensitivity_label_grade where name in ('g1', 'g2', 'g3', 'g4', 'g5', 'g1 ', 'é') or name = repeat ('b', 254);
select count (*) from db_sensitivity_label_info_type where name = 'i1';
select count (*) from db_sensitivity_label_source where name = 's1';
