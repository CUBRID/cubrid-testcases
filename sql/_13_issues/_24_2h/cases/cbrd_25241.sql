/* ------------------------------------------------------------------------------------*/
/* 1. alter serial owner to sql syntax check                                           */
/*  In csql, the results for errors in sql statements are displayed as in the sentence below, but the actual answer is output as an error code value. */
/* ------------------------------------------------------------------------------------*/
create user test_user1;

create serial cubrid_seq;
select unique_name, name, owner.name, [comment] from db_serial where name = 'cubrid_seq';
/*
  unique_name           name                  owner.name            comment
========================================================================================
  'dba.cubrid_seq'      'cubrid_seq'          'DBA'                 NULL
*/

alter serial cubrid_seq OWNER TO test_user1;
select unique_name, name, owner.name, [comment] from db_serial where name = 'cubrid_seq';
/*
  unique_name           name                  owner.name            comment
========================================================================================
  'test_user1.cubrid_seq'  'cubrid_seq'          'TEST_USER1'          NULL
*/

alter serial test_user1.cubrid_seq OWNER TO dba comment '1) owner to comment';
select unique_name, name, owner.name, [comment] from db_serial where name = 'cubrid_seq';
/*
  unique_name           name                  owner.name            comment
========================================================================================
  'dba.cubrid_seq'      'cubrid_seq'          'DBA'                 '1) owner to comment'
*/

/* semantic check error */
alter serial cubrid_seq;
/* csql result values
ERROR: before ' ; '
Specify alter serial option.
*/

alter serial cubrid_seq2;
/*
ERROR: before ' ; '
The serial 'dba.cubrid_seq2' is not defined yet.
*/

/* syntax error */
alter serial cubrid_seq start with 2 OWNER TO test_user1;
/*
ERROR: In line 1, column 38 before ' TO test_user1; '
Syntax error: unexpected 'OWNER', expecting ';'
*/

alter serial cubrid_seq increment by 2 OWNER TO test_user1;
/*
ERROR: In line 1, column 40 before ' TO test_user1; '
Syntax error: unexpected 'OWNER', expecting ';'
*/

alter serial cubrid_seq minvalue 3 OWNER TO test_user1;
/*
ERROR: In line 1, column 36 before ' TO test_user1; '
Syntax error: unexpected 'OWNER', expecting ';'
*/

alter serial cubrid_seq maxvalue 10 OWNER TO test_user1;
/*
ERROR: In line 1, column 37 before ' TO test_user1; '
Syntax error: unexpected 'OWNER', expecting ';'
*/

alter serial cubrid_seq cycle OWNER TO test_user1;
/*
ERROR: In line 1, column 31 before ' TO test_user1; '
Syntax error: unexpected 'OWNER', expecting ';'
*/

alter serial cubrid_seq OWNER TO test_user1 cycle;
/*
ERROR: In line 1, column 45 before '; '
Syntax error: unexpected 'cycle', expecting ';'
*/

alter serial cubrid_seq cache 3 OWNER TO test_user1;
/*
ERROR: In line 1, column 33 before ' TO test_user1; '
Syntax error: unexpected 'OWNER', expecting ';'
*/

alter serial cubrid_seq start with 1 OWNER TO test_user1 comment '2) start with owner to comment';
/*
ERROR: In line 1, column 38 before ' TO test_user1 comment '2) start with owner to comment'; '
Syntax error: unexpected 'OWNER', expecting ';'
*/

/* reset */
drop serial cubrid_seq;
drop user test_user1;

/* ------------------------------------------------------------------------------------*/
/* 2. alter serial owner to permission check                                           */
/* ------------------------------------------------------------------------------------*/
create user test_user1 groups dba;
create user test_user2;

create serial cubrid_seq;
select unique_name, name, owner.name, [comment] from db_serial where name = 'cubrid_seq';
/*
  unique_name           name                  owner.name            comment
========================================================================================
  'dba.cubrid_seq'      'cubrid_seq'          'DBA'                 NULL
*/

alter serial cubrid_seq OWNER TO test_user1;
select unique_name, name, owner.name, [comment] from db_serial where name = 'cubrid_seq';
/*
  unique_name           name                  owner.name            comment
========================================================================================
  'test_user1.cubrid_seq'  'cubrid_seq'          'TEST_USER1'          NULL
*/

CALL login ('test_user1', '') ON CLASS db_user;
alter serial cubrid_seq OWNER TO test_user2;
select unique_name, name, owner.name, [comment] from db_serial where name = 'cubrid_seq';
/*
  unique_name           name                  owner.name            comment
========================================================================================
  'test_user2.cubrid_seq'  'cubrid_seq'          'TEST_USER2'          NULL
*/

CALL login ('test_user2', '') ON CLASS db_user;
alter serial cubrid_seq OWNER TO test_user1;
/*
ERROR: before ' ; '
Only DBA and DBA group members can change the SERIAL OWNER.
*/

/* reset */
CALL login ('dba', '') ON CLASS db_user;
drop serial test_user2.cubrid_seq;
drop user test_user1;
drop user test_user2;

/* ------------------------------------------------------------------------------------*/
/* 3. Test whether serial can be created in the view table                             */
/* ------------------------------------------------------------------------------------*/
create serial cubrid_seq;
create table tbl1 (col1 int, col2 varchar);
INSERT INTO tbl1  values (1,'a');
INSERT INTO tbl1  values (2,'b');
INSERT INTO tbl1  values (3,'c');

create view v_serial as select cubrid_seq.nextval from dual;
/*
ERROR: before ' ; '
Missing an expected attribute name for serial_next_value([dba.cubrid_seq], 1).
*/

create view v_serial as insert into tbl1 select cubrid_seq.nextval, 'd' from dual;
/*
ERROR: In line 1, column 25 before ' into tbl1 select cubrid_seq.nextval, 'd' from dual; '
Syntax error: unexpected 'insert', expecting SELECT or VALUE or VALUES or '('
*/

/* Scalar Subquery */
CREATE VIEW v_serial AS SELECT t1.*, (SELECT cubrid_seq.NEXTVAL) as col3 FROM tbl1 t1;
select * from v_serial;
/*
         col1  col2                  col3
=========================================================
            1  'a'                   1
            2  'b'                   1
            3  'c'                   1
*/

/* Inline View */
CREATE VIEW v_serial2 AS SELECT t1.* FROM (SELECT cubrid_seq.NEXTVAL, 'a' FROM dual) t1;
select * from v_serial2;
/*
  serial_next_value(cubrid_seq, 1)  'a'
============================================
  2                     'a'
*/

/* Subquery */
CREATE VIEW v_serial3 AS SELECT t1.* FROM (select * from tbl1 where col1 = (SELECT cubrid_seq.NEXTVAL)) t1;
select * from v_serial3;
/*
         col1  col2
===================================
            3  'c'
*/

/* reset */
drop view v_serial;
drop view v_serial2;
drop view v_serial3;
drop table tbl1;
drop serial cubrid_seq;



/* ------------------------------------------------------------------------------------*/
/* 4. Test changing ai serial owner in auto increment                                  */
/* ------------------------------------------------------------------------------------*/
create user test_user1;
create table tbl1 (col1 int auto_increment, col2 varchar);

alter serial tbl1_ai_col1 owner to test_user1;
/*
ERROR: AUTO_INCREMENT does not allow change of owner.
*/

select unique_name, name, owner.name from db_serial where name = 'tbl1_ai_col1';
/*
  unique_name           name                  owner.name
==================================================================
  'dba.tbl1_ai_col1'    'tbl1_ai_col1'        'DBA'
*/

alter table tbl1 owner to test_user1;
select unique_name, name, owner.name from db_serial where name = 'tbl1_ai_col1';
/*
  unique_name           name                  owner.name
==================================================================
  'test_user1.tbl1_ai_col1'  'tbl1_ai_col1'        'TEST_USER1'
*/

/* reset */
drop table test_user1.tbl1;
drop user test_user1;

/* ------------------------------------------------------------------------------------*/
/* 5. HA synchronization test                                                          */
/* 5-1. master node - add test_user2 as a member to test_user1 group */
/* ------------------------------------------------------------------------------------*/
create user test_user1;
create serial cubrid_seq cache 5;
SELECT cubrid_seq.nextval from dual;
/*
  serial_next_value(cubrid_seq, 1)
======================
  1
*/
alter serial cubrid_seq owner to test_user1;
SELECT unique_name, name, owner.name, current_val, cached_num, [comment] FROM db_serial WHERE name = 'cubrid_seq';
/*
  unique_name           name                  owner.name            current_val            cached_num  comment
===========================================================================================================================
  'test_user1.cubrid_seq'  'cubrid_seq'          'TEST_USER1'          5                     5          NULL
*/

/* 5-2. slave node - check whether the ADD MEMBERS syntax is synchronized. */
SELECT unique_name, name, owner.name, current_val, cached_num, [comment] FROM db_serial WHERE name = 'cubrid_seq';
/*
  unique_name           name                  owner.name            current_val            cached_num  comment
===========================================================================================================================
  'test_user1.cubrid_seq'  'cubrid_seq'          'TEST_USER1'          5                               5  NULL
*/

/* 5-3. master node - delete member test_user2 in test_user1 group */
drop serial test_user1.cubrid_seq;
SELECT unique_name, name, owner.name, current_val, cached_num, [comment] FROM db_serial WHERE name = 'cubrid_seq';
/*
There are no results.
0 row selected. (0.002959 sec) Committed. (0.000079 sec)
*/

/* 5-4. slave node - check whether the DROP MEMBERS syntax is synchronized. */
SELECT unique_name, name, owner.name, current_val, cached_num, [comment] FROM db_serial WHERE name = 'cubrid_seq';
/*
There are no results.
0 row selected. (0.002959 sec) Committed. (0.000079 sec)
*/

/* reset */
/* master node */
DROP USER test_user1;

