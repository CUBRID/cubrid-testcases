-- This test case verifies the following issue: CBRD-25195.
-- A core dump occurs when multiple tables and serial functions are used simultaneously in one query.
-- Ensure the core is no longer dumped and the expected query result is returned

-- Create 20 tables
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;
drop table if exists t4;
drop table if exists t5;
drop table if exists t6;
drop table if exists t7;
drop table if exists t8;
drop table if exists t9;
drop table if exists t10;
drop table if exists t11;
drop table if exists t12;
drop table if exists t13;
drop table if exists t14;
drop table if exists t15;
drop table if exists t16;
drop table if exists t17;
drop table if exists t18;
drop table if exists t19;
drop table if exists t20;
create table t1 (a int);
create table t2 (a int);
create table t3 (a int);
create table t4 (a int);
create table t5 (a int);
create table t6 (a int);
create table t7 (a int);
create table t8 (a int);
create table t9 (a int);
create table t10 (a int);
create table t11 (a int);
create table t12 (a int);
create table t13 (a int);
create table t14 (a int);
create table t15 (a int);
create table t16 (a int);
create table t17 (a int);
create table t18 (a int);
create table t19 (a int);
create table t20 (a int);

--/* ----------------------------------------
--*
--* Test case 1 - min_tables_single_cast
--* 
--* Ensure core dump no longer occurs when using 10 tables and 1 serial function.
--*     => Selects data from 9 tables -> select 1 serial function -> select 10th table;
--* Expected Result: The query should return 1
--* ---------------------------------------- */
create serial sr1;

select a from t1
union all
select a from t2
union all
select  a from t3
union all
select  a from t4
union all
select  a from t5
union all
select  a from t6
union all
select a from t7
union all
select a from t8
union all
select a from t9
union all
select cast(sr1.next_value as int)
union all
select a from t10;

drop serial sr1;


--/* ----------------------------------------
--*
--* Test case 2 - min_tables_many_casts
--* 
--* Ensure core dump no longer occurs when using 10 tables and 10 serial functions sequentially.
--*     => Selects data from 10 tables and 10 serial functions sequentially and returns the number of rows in the output 
--* Expected Result: The query should return 10 results with values 1 
--* ---------------------------------------- */
create serial sr1;
create serial sr2;
create serial sr3;
create serial sr4;
create serial sr5;
create serial sr6;
create serial sr7;
create serial sr8;
create serial sr9;
create serial sr10;

select a from t1
union all
select a from t2
union all
select a from t3
union all
select a from t4
union all
select a from t5
union all
select a from t6
union all
select a from t7
union all
select a from t8
union all
select a from t9
union all
select a from t10
union all
select cast(sr1.next_value as int)
union all
select cast(sr2.next_value as int)
union all
select cast(sr3.next_value as int)
union all
select cast(sr4.next_value as int)
union all
select cast(sr5.next_value as int)
union all
select cast(sr6.next_value as int)
union all
select cast(sr7.next_value as int)
union all
select cast(sr8.next_value as int)
union all
select cast(sr9.next_value as int)
union all
select cast(sr10.next_value as int);

drop serial sr1;
drop serial sr2;
drop serial sr3;
drop serial sr4;
drop serial sr5;
drop serial sr6;
drop serial sr7;
drop serial sr8;
drop serial sr9;
drop serial sr10;


--/* ----------------------------------------
--*
--* Test case 3 - max_tables_single_cast
--* 
--* Ensure core dump no longer occurs when using 20 tables and 1 serial function.
--*     => Selects data from 19 tables -> select 1 serial function -> select 20th table;
--* Expected Result: The query should return 1
--* ---------------------------------------- */
create serial sr1;

select a from t1
union all
select a from t2
union all
select a from t3
union all
select a from t4
union all
select a from t5
union all
select a from t6
union all
select a from t7
union all
select a from t8
union all
select a from t9
union all
select a from t10
union all
select a from t11
union all
select a from t12
union all
select a from t13
union all
select a from t14
union all
select a from t15
union all
select a from t16
union all
select a from t17
union all
select a from t18
union all
select a from t19
union all
select cast(sr1.next_value as int)
union all
select a from t20;

drop serial sr1;


--/* ----------------------------------------
--*
--* Test case 4 - max_tables_many_casts
--* 
--* Ensure core dump no longer occurs when using 20 tables and 10 serial functions.
--*     => Selects data from 20 tables and 10 serial functions sequentially and returns the number of rows in the output.
--* Expected Result: The query should return 10 results with values 1 
--* ---------------------------------------- */
create serial sr1;
create serial sr2;
create serial sr3;
create serial sr4;
create serial sr5;
create serial sr6;
create serial sr7;
create serial sr8;
create serial sr9;
create serial sr10;

select a from t1
union all
select a from t2
union all
select a from t3
union all
select a from t4
union all
select a from t5
union all
select a from t6
union all
select a from t7
union all
select a from t8
union all
select a from t9
union all
select a from t10
union all
select a from t11
union all
select a from t12
union all
select a from t13
union all
select a from t14
union all
select a from t15
union all
select a from t16
union all
select a from t17
union all
select a from t18
union all
select a from t19
union all
select a from t20
union all
select cast(sr1.next_value as int)
union all
select cast(sr2.next_value as int)
union all
select cast(sr3.next_value as int)
union all
select cast(sr4.next_value as int)
union all
select cast(sr5.next_value as int)
union all
select cast(sr6.next_value as int)
union all
select cast(sr7.next_value as int)
union all
select cast(sr8.next_value as int)
union all
select cast(sr9.next_value as int)
union all
select cast(sr10.next_value as int);

drop serial sr1;
drop serial sr2;
drop serial sr3;
drop serial sr4;
drop serial sr5;
drop serial sr6;
drop serial sr7;
drop serial sr8;
drop serial sr9;
drop serial sr10;


-- Table Cleanup
drop table t1;
drop table t2;
drop table t3;
drop table t4;
drop table t5;
drop table t6;
drop table t7;
drop table t8;
drop table t9;
drop table t10;
drop table t11;
drop table t12;
drop table t13;
drop table t14;
drop table t15;
drop table t16;
drop table t17;
drop table t18;
drop table t19;
drop table t20;