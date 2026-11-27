/**
 *  This test case verifies CBRD-27419: CREATE, ALTER and DROP SENSITIVITY LABEL
 *  GRADE, INFO_TYPE and SOURCE register the names that labels use, and
 *  db_sensitivity_label_grade, db_sensitivity_label_info_type and
 *  db_sensitivity_label_source list them. A grade needs a LEVEL of 1 or more
 *  that no other grade holds.
 *
 *  Coverage:
 *    Case 1:  CREATE registers a grade with its level and comment, and an
 *             info_type and a source with their comment
 *    Case 2:  a grade without LEVEL, and an info_type or a source with LEVEL,
 *             are syntax errors that register nothing
 *    Case 3:  ALTER changes only the LEVEL or the COMMENT it names
 *    Case 4:  RENAME AS changes only the name and keeps created_time
 *    Case 5:  DROP removes only the name it names
 *    Case 6:  LEVEL takes 1 to 2147483647 in CREATE and ALTER, and an error
 *             changes nothing
 *    Case 7:  CREATE or RENAME AS to a registered name fails with -1403
 *    Case 8:  CREATE or ALTER to a level another grade holds fails with -1406
 *    Case 9:  ALTER GRADE with neither LEVEL nor COMMENT, and ALTER INFO_TYPE or
 *             SOURCE without COMMENT or with LEVEL, fail
 *    Case 10: ALTER, RENAME AS or DROP of a name not registered fails with -1404
 *    Case 11: names are stored in lowercase
 *    Case 12: a name matches whatever its letter case
 *    Case 13: a name is 1 to 254 bytes
 *    Case 14: a name cannot hold an opening or a closing square bracket
 *    Case 15: ROLLBACK undoes CREATE, ALTER and DROP, and COMMIT keeps them
 *    Case 16: a user holding only SELECT ON SENSITIVITY LABEL, or a user after
 *             ALTER is revoked from PUBLIC, gets -158 and changes nothing,
 *             while dba runs the statements the SELECT-only user could not
 *    Case 17: ALTER ON SENSITIVITY LABEL held directly lets a user run CREATE,
 *             ALTER and DROP SENSITIVITY LABEL, and held through a group or
 *             through PUBLIC lets a user run CREATE
 *    Case 18: a DBA group member runs CREATE, ALTER and DROP SENSITIVITY LABEL
 *             with nothing granted
 *    Case 19: SENSITIVITY, LABEL, GRADE, INFO_TYPE and SOURCE are not reserved
 *    Case 20: LEVEL stays reserved
 *    Case 21: dropping the names and the users leaves no registered name and no
 *             label grant
 */
drop table if exists sensitivity, label, grade, info_type, source, c20_t;

evaluate 'Case 1: CREATE registers a grade with its level and comment, and an info_type and a source with their comment';
create sensitivity label grade 'c01_g1' level 101 comment 'grade one';
create sensitivity label grade 'c01_g2' level 102;
create sensitivity label info_type 'c01_i1' comment 'info_type one';
create sensitivity label info_type 'c01_i2';
create sensitivity label source 'c01_s1' comment 'source one';
create sensitivity label source 'c01_s2';
select 'GRADE' kind, name, grade_level, comment from db_sensitivity_label_grade where left (name, 3) = 'c01'
union all select 'INFO_TYPE', name, null, comment from db_sensitivity_label_info_type where left (name, 3) = 'c01'
union all select 'SOURCE', name, null, comment from db_sensitivity_label_source where left (name, 3) = 'c01'
order by 1, 2;

evaluate 'Case 2: a grade without LEVEL, and an info_type or a source with LEVEL, are syntax errors that register nothing';
create sensitivity label grade 'c02_g';
create sensitivity label grade 'c02_g' comment 'no level';
create sensitivity label info_type 'c02_i' level 201;
create sensitivity label source 'c02_s' level 202;
select 'GRADE' kind, name, grade_level, comment from db_sensitivity_label_grade where left (name, 3) in ('c01', 'c02')
union all select 'INFO_TYPE', name, null, comment from db_sensitivity_label_info_type where left (name, 3) in ('c01', 'c02')
union all select 'SOURCE', name, null, comment from db_sensitivity_label_source where left (name, 3) in ('c01', 'c02')
order by 1, 2;

evaluate 'Case 3: ALTER changes only the LEVEL or the COMMENT it names';
create sensitivity label grade 'c03_ga' level 301 comment 'a';
create sensitivity label grade 'c03_gb' level 302 comment 'b';
create sensitivity label grade 'c03_gc' level 303 comment 'c';
create sensitivity label info_type 'c03_i' comment 'i';
create sensitivity label source 'c03_s' comment 's';
alter sensitivity label grade 'c03_ga' level 311;
alter sensitivity label grade 'c03_gb' comment 'b altered';
alter sensitivity label grade 'c03_gc' level 313 comment 'c altered';
alter sensitivity label info_type 'c03_i' comment 'i altered';
alter sensitivity label source 'c03_s' comment 's altered';
select 'GRADE' kind, name, grade_level, comment from db_sensitivity_label_grade where left (name, 3) = 'c03'
union all select 'INFO_TYPE', name, null, comment from db_sensitivity_label_info_type where left (name, 3) = 'c03'
union all select 'SOURCE', name, null, comment from db_sensitivity_label_source where left (name, 3) = 'c03'
order by 1, 2;

evaluate 'Case 4: RENAME AS changes only the name and keeps created_time';
create sensitivity label grade 'c04_g' level 401 comment 'g';
create sensitivity label info_type 'c04_i' comment 'i';
create sensitivity label source 'c04_s' comment 's';
set @grade_time = (select created_time from db_sensitivity_label_grade where name = 'c04_g');
set @info_type_time = (select created_time from db_sensitivity_label_info_type where name = 'c04_i');
set @source_time = (select created_time from db_sensitivity_label_source where name = 'c04_s');
-- a second apart, so a RENAME that resets created_time prints 0
select sleep(1);
alter sensitivity label grade 'c04_g' rename as 'c04_g_renamed';
alter sensitivity label info_type 'c04_i' rename as 'c04_i_renamed';
alter sensitivity label source 'c04_s' rename as 'c04_s_renamed';
select 'GRADE' kind, name, grade_level, comment, created_time = @grade_time from db_sensitivity_label_grade where left (name, 3) = 'c04'
union all select 'INFO_TYPE', name, null, comment, created_time = @info_type_time from db_sensitivity_label_info_type where left (name, 3) = 'c04'
union all select 'SOURCE', name, null, comment, created_time = @source_time from db_sensitivity_label_source where left (name, 3) = 'c04'
order by 1, 2;
drop variable @grade_time, @info_type_time, @source_time;

evaluate 'Case 5: DROP removes only the name it names';
create sensitivity label grade 'c05_g1' level 501;
create sensitivity label grade 'c05_g2' level 502;
create sensitivity label info_type 'c05_i1';
create sensitivity label info_type 'c05_i2';
create sensitivity label source 'c05_s1';
create sensitivity label source 'c05_s2';
drop sensitivity label grade 'c05_g1';
drop sensitivity label info_type 'c05_i1';
drop sensitivity label source 'c05_s1';
select 'GRADE' kind, name, grade_level, comment from db_sensitivity_label_grade where left (name, 3) = 'c05'
union all select 'INFO_TYPE', name, null, comment from db_sensitivity_label_info_type where left (name, 3) = 'c05'
union all select 'SOURCE', name, null, comment from db_sensitivity_label_source where left (name, 3) = 'c05'
order by 1, 2;

evaluate 'Case 6: LEVEL takes 1 to 2147483647 in CREATE and ALTER, and an error changes nothing';
create sensitivity label grade 'c06_min' level 1;
create sensitivity label grade 'c06_max' level 2147483647;
create sensitivity label grade 'c06_zero' level 0;
create sensitivity label grade 'c06_over' level 2147483648;
create sensitivity label grade 'c06_negative' level -1;
select name, grade_level from db_sensitivity_label_grade where left (name, 3) = 'c06' order by name;
-- frees levels 1 and 2147483647 for the ALTER below
drop sensitivity label grade 'c06_min';
drop sensitivity label grade 'c06_max';
create sensitivity label grade 'c06_alter' level 601;
alter sensitivity label grade 'c06_alter' level 0;
alter sensitivity label grade 'c06_alter' level 2147483648;
select name, grade_level from db_sensitivity_label_grade where left (name, 3) = 'c06' order by name;
alter sensitivity label grade 'c06_alter' level 1;
select name, grade_level from db_sensitivity_label_grade where left (name, 3) = 'c06' order by name;
alter sensitivity label grade 'c06_alter' level 2147483647;
select name, grade_level from db_sensitivity_label_grade where left (name, 3) = 'c06' order by name;

evaluate 'Case 7: CREATE or RENAME AS to a registered name fails with -1403';
create sensitivity label grade 'c07_g1' level 701;
create sensitivity label grade 'c07_g2' level 702;
create sensitivity label info_type 'c07_i1';
create sensitivity label info_type 'c07_i2';
create sensitivity label source 'c07_s1';
create sensitivity label source 'c07_s2';
create sensitivity label grade 'c07_g1' level 703;
create sensitivity label info_type 'c07_i1';
create sensitivity label source 'c07_s1';
alter sensitivity label grade 'c07_g1' rename as 'c07_g2';
alter sensitivity label info_type 'c07_i1' rename as 'c07_i2';
alter sensitivity label source 'c07_s1' rename as 'c07_s2';
select 'GRADE' kind, name, grade_level, comment from db_sensitivity_label_grade where left (name, 3) = 'c07'
union all select 'INFO_TYPE', name, null, comment from db_sensitivity_label_info_type where left (name, 3) = 'c07'
union all select 'SOURCE', name, null, comment from db_sensitivity_label_source where left (name, 3) = 'c07'
order by 1, 2;

evaluate 'Case 8: CREATE or ALTER to a level another grade holds fails with -1406';
create sensitivity label grade 'c08_a' level 801;
create sensitivity label grade 'c08_b' level 802;
create sensitivity label grade 'c08_c' level 801;
alter sensitivity label grade 'c08_b' level 801;
select name, grade_level from db_sensitivity_label_grade where left (name, 3) = 'c08' order by name;

evaluate 'Case 9: ALTER GRADE with neither LEVEL nor COMMENT, and ALTER INFO_TYPE or SOURCE without COMMENT or with LEVEL, fail';
create sensitivity label grade 'c09_g' level 901 comment 'g';
create sensitivity label info_type 'c09_i' comment 'i';
create sensitivity label source 'c09_s' comment 's';
alter sensitivity label grade 'c09_g';
alter sensitivity label info_type 'c09_i';
alter sensitivity label source 'c09_s';
alter sensitivity label info_type 'c09_i' level 902;
alter sensitivity label source 'c09_s' level 903;
select 'GRADE' kind, name, grade_level, comment from db_sensitivity_label_grade where left (name, 3) = 'c09'
union all select 'INFO_TYPE', name, null, comment from db_sensitivity_label_info_type where left (name, 3) = 'c09'
union all select 'SOURCE', name, null, comment from db_sensitivity_label_source where left (name, 3) = 'c09'
order by 1, 2;

evaluate 'Case 10: ALTER, RENAME AS or DROP of a name not registered fails with -1404';
create sensitivity label grade 'c10_g' level 1001 comment 'g';
alter sensitivity label grade 'c10_none' comment 'x';
alter sensitivity label grade 'c10_none' rename as 'c10_new';
alter sensitivity label info_type 'c10_none' comment 'x';
alter sensitivity label info_type 'c10_none' rename as 'c10_new';
alter sensitivity label source 'c10_none' comment 'x';
alter sensitivity label source 'c10_none' rename as 'c10_new';
drop sensitivity label grade 'c10_none';
drop sensitivity label info_type 'c10_none';
drop sensitivity label source 'c10_none';
select 'GRADE' kind, name, grade_level, comment from db_sensitivity_label_grade where left (name, 3) = 'c10'
union all select 'INFO_TYPE', name, null, comment from db_sensitivity_label_info_type where left (name, 3) = 'c10'
union all select 'SOURCE', name, null, comment from db_sensitivity_label_source where left (name, 3) = 'c10'
order by 1, 2;

evaluate 'Case 11: names are stored in lowercase';
create sensitivity label grade 'C11_Mixed_G' level 1101;
create sensitivity label info_type 'C11_Mixed_I';
create sensitivity label source 'C11_Mixed_S';
-- lower () in the filter lets a name kept in mixed case show as well
select 'GRADE' kind, name, grade_level, comment from db_sensitivity_label_grade where lower (left (name, 3)) = 'c11'
union all select 'INFO_TYPE', name, null, comment from db_sensitivity_label_info_type where lower (left (name, 3)) = 'c11'
union all select 'SOURCE', name, null, comment from db_sensitivity_label_source where lower (left (name, 3)) = 'c11'
order by 1, 2;
alter sensitivity label grade 'c11_mixed_g' rename as 'C11_Renamed_G';
alter sensitivity label info_type 'c11_mixed_i' rename as 'C11_Renamed_I';
alter sensitivity label source 'c11_mixed_s' rename as 'C11_Renamed_S';
select 'GRADE' kind, name, grade_level, comment from db_sensitivity_label_grade where lower (left (name, 3)) = 'c11'
union all select 'INFO_TYPE', name, null, comment from db_sensitivity_label_info_type where lower (left (name, 3)) = 'c11'
union all select 'SOURCE', name, null, comment from db_sensitivity_label_source where lower (left (name, 3)) = 'c11'
order by 1, 2;

evaluate 'Case 12: a name matches whatever its letter case';
create sensitivity label grade 'c12_ga' level 1201;
create sensitivity label grade 'c12_gb' level 1202;
create sensitivity label info_type 'c12_ia';
create sensitivity label info_type 'c12_ib';
create sensitivity label source 'c12_sa';
create sensitivity label source 'c12_sb';
-- expected errors: CREATE and RENAME AS to a registered name written in upper case
create sensitivity label grade 'C12_GA' level 1203;
create sensitivity label info_type 'C12_IA';
create sensitivity label source 'C12_SA';
alter sensitivity label grade 'c12_gb' rename as 'C12_GA';
alter sensitivity label info_type 'c12_ib' rename as 'C12_IA';
alter sensitivity label source 'c12_sb' rename as 'C12_SA';
alter sensitivity label grade 'C12_GA' comment 'c';
alter sensitivity label info_type 'C12_IA' comment 'c';
alter sensitivity label source 'C12_SA' comment 'c';
alter sensitivity label grade 'C12_GA' rename as 'c12_gc';
alter sensitivity label info_type 'C12_IA' rename as 'c12_ic';
alter sensitivity label source 'C12_SA' rename as 'c12_sc';
drop sensitivity label grade 'C12_GB';
drop sensitivity label info_type 'C12_IB';
drop sensitivity label source 'C12_SB';
select 'GRADE' kind, name, grade_level, comment from db_sensitivity_label_grade where lower (left (name, 3)) = 'c12'
union all select 'INFO_TYPE', name, null, comment from db_sensitivity_label_info_type where lower (left (name, 3)) = 'c12'
union all select 'SOURCE', name, null, comment from db_sensitivity_label_source where lower (left (name, 3)) = 'c12'
order by 1, 2;

evaluate 'Case 13: a name is 1 to 254 bytes';
-- expected errors: an empty name, by CREATE and by RENAME AS
create sensitivity label grade '' level 1301;
create sensitivity label info_type '';
create sensitivity label source '';
create sensitivity label grade 'c13_g' level 1302;
create sensitivity label info_type 'c13_i';
create sensitivity label source 'c13_s';
alter sensitivity label grade 'c13_g' rename as '';
alter sensitivity label info_type 'c13_i' rename as '';
alter sensitivity label source 'c13_s' rename as '';
select 'GRADE' kind, name, grade_level, comment from db_sensitivity_label_grade where left (name, 3) = 'c13' or name = ''
union all select 'INFO_TYPE', name, null, comment from db_sensitivity_label_info_type where left (name, 3) = 'c13' or name = ''
union all select 'SOURCE', name, null, comment from db_sensitivity_label_source where left (name, 3) = 'c13' or name = ''
order by 1, 2;
-- c13_ followed by 250 and 251 letters: 254 and 255 bytes; z: 1 byte; the 255-byte name is an expected error
create sensitivity label grade 'c13_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa' level 1303;
create sensitivity label grade 'c13_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa' level 1304;
create sensitivity label grade 'z' level 1305;
select octet_length (name), grade_level from db_sensitivity_label_grade where left (name, 3) = 'c13' or name = 'z' order by 2;

evaluate 'Case 14: a name cannot hold an opening or a closing square bracket';
create sensitivity label grade 'c14_a[b' level 1401;
create sensitivity label info_type 'c14_a]b';
create sensitivity label source 'c14_s';
alter sensitivity label source 'c14_s' rename as 'c14_s[';
select 'GRADE' kind, name, grade_level, comment from db_sensitivity_label_grade where left (name, 3) = 'c14'
union all select 'INFO_TYPE', name, null, comment from db_sensitivity_label_info_type where left (name, 3) = 'c14'
union all select 'SOURCE', name, null, comment from db_sensitivity_label_source where left (name, 3) = 'c14'
order by 1, 2;

evaluate 'Case 15: ROLLBACK undoes CREATE, ALTER and DROP, and COMMIT keeps them';
autocommit off;
create sensitivity label grade 'c15_g' level 1501 comment 'g';
create sensitivity label info_type 'c15_i' comment 'i';
create sensitivity label source 'c15_s' comment 's';
select 'GRADE' kind, name, grade_level, comment from db_sensitivity_label_grade where left (name, 3) = 'c15'
union all select 'INFO_TYPE', name, null, comment from db_sensitivity_label_info_type where left (name, 3) = 'c15'
union all select 'SOURCE', name, null, comment from db_sensitivity_label_source where left (name, 3) = 'c15'
order by 1, 2;
rollback;
select 'GRADE' kind, name, grade_level, comment from db_sensitivity_label_grade where left (name, 3) = 'c15'
union all select 'INFO_TYPE', name, null, comment from db_sensitivity_label_info_type where left (name, 3) = 'c15'
union all select 'SOURCE', name, null, comment from db_sensitivity_label_source where left (name, 3) = 'c15'
order by 1, 2;
create sensitivity label grade 'c15_g' level 1501 comment 'g';
create sensitivity label info_type 'c15_i' comment 'i';
create sensitivity label source 'c15_s' comment 's';
commit;
select 'GRADE' kind, name, grade_level, comment from db_sensitivity_label_grade where left (name, 3) = 'c15'
union all select 'INFO_TYPE', name, null, comment from db_sensitivity_label_info_type where left (name, 3) = 'c15'
union all select 'SOURCE', name, null, comment from db_sensitivity_label_source where left (name, 3) = 'c15'
order by 1, 2;
alter sensitivity label grade 'c15_g' level 1502 comment 'g altered';
alter sensitivity label info_type 'c15_i' rename as 'c15_i_renamed';
drop sensitivity label source 'c15_s';
select 'GRADE' kind, name, grade_level, comment from db_sensitivity_label_grade where left (name, 3) = 'c15'
union all select 'INFO_TYPE', name, null, comment from db_sensitivity_label_info_type where left (name, 3) = 'c15'
union all select 'SOURCE', name, null, comment from db_sensitivity_label_source where left (name, 3) = 'c15'
order by 1, 2;
rollback;
select 'GRADE' kind, name, grade_level, comment from db_sensitivity_label_grade where left (name, 3) = 'c15'
union all select 'INFO_TYPE', name, null, comment from db_sensitivity_label_info_type where left (name, 3) = 'c15'
union all select 'SOURCE', name, null, comment from db_sensitivity_label_source where left (name, 3) = 'c15'
order by 1, 2;
autocommit on;

evaluate 'Case 16: a user holding only SELECT ON SENSITIVITY LABEL, or a user after ALTER is revoked from PUBLIC, gets -158 and changes nothing, while dba runs the statements the SELECT-only user could not';
create user u_select;
grant select on sensitivity label to u_select;
create user u_public;
create sensitivity label grade 'c16_ga' level 1601;
create sensitivity label grade 'c16_gb' level 1602;
create sensitivity label grade 'c16_gc' level 1603;
create sensitivity label info_type 'c16_ia';
create sensitivity label info_type 'c16_ib';
create sensitivity label info_type 'c16_ic';
create sensitivity label source 'c16_sa';
create sensitivity label source 'c16_sb';
create sensitivity label source 'c16_sc';
--+ holdcas on;
call login('u_select', '') on class db_user;
create sensitivity label grade 'c16_gn' level 1604;
alter sensitivity label grade 'c16_ga' comment 'altered';
alter sensitivity label grade 'c16_gb' rename as 'c16_gr';
drop sensitivity label grade 'c16_gc';
create sensitivity label info_type 'c16_in';
alter sensitivity label info_type 'c16_ia' comment 'altered';
alter sensitivity label info_type 'c16_ib' rename as 'c16_ir';
drop sensitivity label info_type 'c16_ic';
create sensitivity label source 'c16_sn';
alter sensitivity label source 'c16_sa' comment 'altered';
alter sensitivity label source 'c16_sb' rename as 'c16_sr';
drop sensitivity label source 'c16_sc';
call login('dba', '') on class db_user;
--+ holdcas off;
select 'GRADE' kind, name, grade_level, comment from db_sensitivity_label_grade where left (name, 3) = 'c16'
union all select 'INFO_TYPE', name, null, comment from db_sensitivity_label_info_type where left (name, 3) = 'c16'
union all select 'SOURCE', name, null, comment from db_sensitivity_label_source where left (name, 3) = 'c16'
order by 1, 2;
create sensitivity label grade 'c16_gn' level 1604;
alter sensitivity label grade 'c16_ga' comment 'altered';
alter sensitivity label grade 'c16_gb' rename as 'c16_gr';
drop sensitivity label grade 'c16_gc';
create sensitivity label info_type 'c16_in';
alter sensitivity label info_type 'c16_ia' comment 'altered';
alter sensitivity label info_type 'c16_ib' rename as 'c16_ir';
drop sensitivity label info_type 'c16_ic';
create sensitivity label source 'c16_sn';
alter sensitivity label source 'c16_sa' comment 'altered';
alter sensitivity label source 'c16_sb' rename as 'c16_sr';
drop sensitivity label source 'c16_sc';
select 'GRADE' kind, name, grade_level, comment from db_sensitivity_label_grade where left (name, 3) = 'c16'
union all select 'INFO_TYPE', name, null, comment from db_sensitivity_label_info_type where left (name, 3) = 'c16'
union all select 'SOURCE', name, null, comment from db_sensitivity_label_source where left (name, 3) = 'c16'
order by 1, 2;
grant alter on sensitivity label to public;
revoke alter on sensitivity label from public;
--+ holdcas on;
call login('u_public', '') on class db_user;
create sensitivity label grade 'c16_public' level 1605;
call login('dba', '') on class db_user;
--+ holdcas off;
select name from db_sensitivity_label_grade where name = 'c16_public';

evaluate 'Case 17: ALTER ON SENSITIVITY LABEL held directly lets a user run CREATE, ALTER and DROP SENSITIVITY LABEL, and held through a group or through PUBLIC lets a user run CREATE';
create user u_alter;
grant alter on sensitivity label to u_alter;
create user g_alter;
grant alter on sensitivity label to g_alter;
create user u_member groups g_alter;
create sensitivity label grade 'c17_ga' level 1701;
create sensitivity label grade 'c17_gb' level 1702;
create sensitivity label grade 'c17_gc' level 1703;
create sensitivity label info_type 'c17_ia';
create sensitivity label info_type 'c17_ib';
create sensitivity label info_type 'c17_ic';
create sensitivity label source 'c17_sa';
create sensitivity label source 'c17_sb';
create sensitivity label source 'c17_sc';
--+ holdcas on;
call login('u_alter', '') on class db_user;
create sensitivity label grade 'c17_gn' level 1704;
alter sensitivity label grade 'c17_ga' comment 'altered';
alter sensitivity label grade 'c17_gb' rename as 'c17_gr';
drop sensitivity label grade 'c17_gc';
create sensitivity label info_type 'c17_in';
alter sensitivity label info_type 'c17_ia' comment 'altered';
alter sensitivity label info_type 'c17_ib' rename as 'c17_ir';
drop sensitivity label info_type 'c17_ic';
create sensitivity label source 'c17_sn';
alter sensitivity label source 'c17_sa' comment 'altered';
alter sensitivity label source 'c17_sb' rename as 'c17_sr';
drop sensitivity label source 'c17_sc';
call login('u_member', '') on class db_user;
create sensitivity label grade 'c17_group' level 1705;
call login('dba', '') on class db_user;
grant alter on sensitivity label to public;
-- u_public is the user Case 16 created
call login('u_public', '') on class db_user;
create sensitivity label grade 'c17_public' level 1706;
call login('dba', '') on class db_user;
--+ holdcas off;
revoke alter on sensitivity label from public;
select 'GRADE' kind, name, grade_level, comment from db_sensitivity_label_grade where left (name, 3) = 'c17'
union all select 'INFO_TYPE', name, null, comment from db_sensitivity_label_info_type where left (name, 3) = 'c17'
union all select 'SOURCE', name, null, comment from db_sensitivity_label_source where left (name, 3) = 'c17'
order by 1, 2;

evaluate 'Case 18: a DBA group member runs CREATE, ALTER and DROP SENSITIVITY LABEL with nothing granted';
create user u_dba_member groups dba;
create sensitivity label grade 'c18_ga' level 1801;
create sensitivity label grade 'c18_gb' level 1802;
create sensitivity label grade 'c18_gc' level 1803;
create sensitivity label info_type 'c18_ia';
create sensitivity label info_type 'c18_ib';
create sensitivity label info_type 'c18_ic';
create sensitivity label source 'c18_sa';
create sensitivity label source 'c18_sb';
create sensitivity label source 'c18_sc';
--+ holdcas on;
call login('u_dba_member', '') on class db_user;
create sensitivity label grade 'c18_gn' level 1804;
alter sensitivity label grade 'c18_ga' comment 'altered';
alter sensitivity label grade 'c18_gb' rename as 'c18_gr';
drop sensitivity label grade 'c18_gc';
create sensitivity label info_type 'c18_in';
alter sensitivity label info_type 'c18_ia' comment 'altered';
alter sensitivity label info_type 'c18_ib' rename as 'c18_ir';
drop sensitivity label info_type 'c18_ic';
create sensitivity label source 'c18_sn';
alter sensitivity label source 'c18_sa' comment 'altered';
alter sensitivity label source 'c18_sb' rename as 'c18_sr';
drop sensitivity label source 'c18_sc';
call login('dba', '') on class db_user;
--+ holdcas off;
select 'GRADE' kind, name, grade_level, comment from db_sensitivity_label_grade where left (name, 3) = 'c18'
union all select 'INFO_TYPE', name, null, comment from db_sensitivity_label_info_type where left (name, 3) = 'c18'
union all select 'SOURCE', name, null, comment from db_sensitivity_label_source where left (name, 3) = 'c18'
order by 1, 2;

evaluate 'Case 19: SENSITIVITY, LABEL, GRADE, INFO_TYPE and SOURCE are not reserved';
create table sensitivity (sensitivity int);
create table label (label int);
create table grade (grade int);
create table info_type (info_type int);
create table source (source int);
insert into sensitivity values (1);
insert into label values (2);
insert into grade values (3);
insert into info_type values (4);
insert into source values (5);
select sensitivity, label, grade, info_type, source from sensitivity, label, grade, info_type, source;

evaluate 'Case 20: LEVEL stays reserved';
create table level (a int);
create table c20_t (level int);
select class_name from db_class where class_name in ('level', 'c20_t') order by class_name;

evaluate 'Case 21: dropping the names and the users leaves no registered name and no label grant';
drop sensitivity label grade 'c01_g1';
drop sensitivity label grade 'c01_g2';
drop sensitivity label grade 'c03_ga';
drop sensitivity label grade 'c03_gb';
drop sensitivity label grade 'c03_gc';
drop sensitivity label grade 'c04_g_renamed';
drop sensitivity label grade 'c05_g2';
drop sensitivity label grade 'c06_alter';
drop sensitivity label grade 'c07_g1';
drop sensitivity label grade 'c07_g2';
drop sensitivity label grade 'c08_a';
drop sensitivity label grade 'c08_b';
drop sensitivity label grade 'c09_g';
drop sensitivity label grade 'c10_g';
drop sensitivity label grade 'c11_renamed_g';
drop sensitivity label grade 'c12_gc';
drop sensitivity label grade 'c13_g';
drop sensitivity label grade 'c13_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
drop sensitivity label grade 'z';
drop sensitivity label grade 'c15_g';
drop sensitivity label grade 'c16_ga';
drop sensitivity label grade 'c16_gr';
drop sensitivity label grade 'c16_gn';
drop sensitivity label grade 'c17_ga';
drop sensitivity label grade 'c17_gr';
drop sensitivity label grade 'c17_gn';
drop sensitivity label grade 'c17_group';
drop sensitivity label grade 'c17_public';
drop sensitivity label grade 'c18_ga';
drop sensitivity label grade 'c18_gr';
drop sensitivity label grade 'c18_gn';
drop sensitivity label info_type 'c01_i1';
drop sensitivity label info_type 'c01_i2';
drop sensitivity label info_type 'c03_i';
drop sensitivity label info_type 'c04_i_renamed';
drop sensitivity label info_type 'c05_i2';
drop sensitivity label info_type 'c07_i1';
drop sensitivity label info_type 'c07_i2';
drop sensitivity label info_type 'c09_i';
drop sensitivity label info_type 'c11_renamed_i';
drop sensitivity label info_type 'c12_ic';
drop sensitivity label info_type 'c13_i';
drop sensitivity label info_type 'c15_i';
drop sensitivity label info_type 'c16_ia';
drop sensitivity label info_type 'c16_ir';
drop sensitivity label info_type 'c16_in';
drop sensitivity label info_type 'c17_ia';
drop sensitivity label info_type 'c17_ir';
drop sensitivity label info_type 'c17_in';
drop sensitivity label info_type 'c18_ia';
drop sensitivity label info_type 'c18_ir';
drop sensitivity label info_type 'c18_in';
drop sensitivity label source 'c01_s1';
drop sensitivity label source 'c01_s2';
drop sensitivity label source 'c03_s';
drop sensitivity label source 'c04_s_renamed';
drop sensitivity label source 'c05_s2';
drop sensitivity label source 'c07_s1';
drop sensitivity label source 'c07_s2';
drop sensitivity label source 'c09_s';
drop sensitivity label source 'c11_renamed_s';
drop sensitivity label source 'c12_sc';
drop sensitivity label source 'c13_s';
drop sensitivity label source 'c14_s';
drop sensitivity label source 'c15_s';
drop sensitivity label source 'c16_sa';
drop sensitivity label source 'c16_sr';
drop sensitivity label source 'c16_sn';
drop sensitivity label source 'c17_sa';
drop sensitivity label source 'c17_sr';
drop sensitivity label source 'c17_sn';
drop sensitivity label source 'c18_sa';
drop sensitivity label source 'c18_sr';
drop sensitivity label source 'c18_sn';
drop table sensitivity, label, grade, info_type, source;
drop user u_select;
drop user u_public;
drop user u_alter;
drop user u_member;
drop user g_alter;
drop user u_dba_member;
select (select count (*) from db_sensitivity_label_grade where (name regexp '^c[0-9][0-9]_' or name in ('z', ''))) grades, (select count (*) from db_sensitivity_label_info_type where (name regexp '^c[0-9][0-9]_' or name in ('z', ''))) info_types,
  (select count (*) from db_sensitivity_label_source where (name regexp '^c[0-9][0-9]_' or name in ('z', ''))) sources, (select count (*) from db_auth where object_type = 'SENSITIVITY LABEL' and grantee_name in ('PUBLIC', 'U_SELECT', 'U_PUBLIC', 'U_ALTER', 'U_MEMBER', 'G_ALTER', 'U_DBA_MEMBER')) label_grants;
