--+ holdcas on;

-------------------------------------------------------------
select '----1 check attribute';
-------------------------------------------------------------
CREATE TABLE t1
 (
 short_col SHORT DEFAULT 1,
 int_col INTEGER DEFAULT 2,
 bigint_col BIGINT DEFAULT 3, 
 numeric_col NUMERIC(10,5) DEFAULT 123.45, 
 float_col FLOAT DEFAULT 6.2,
 double_col DOUBLE DEFAULT 5.74,
 MONETARY_col MONETARY DEFAULT 3.402823466E+38,
 date_col DATE DEFAULT '2012-01-01',
 time_col TIME DEFAULT '13:03:03',
 timestamp_col TIMESTAMP DEFAULT '2008-10-31',
 datetime_col DATETIME DEFAULT '2000-12-31 23:59:10',
 bit_col BIT(4) DEFAULT B'1010',
 bitvary_col BIT VARYING DEFAULT B'1',
 char_col CHAR(100) DEFAULT 'cubrid_char',
 varchar_col VARCHAR(150) DEFAULT 'cubrid_varchar',
 nchar_col NCHAR(200) DEFAULT N'cubrid_nchar',
 nvarchar_col NCHAR VARYING(200) DEFAULT N'cubrid_nvarchar',
 blob_col BLOB,
 clob_col ClOB,
 share_col int shared 2
);
show create table t1;
drop t1;

CREATE TABLE [CALL] ([TIME] int, [VARYING] int shared 2);
show create table [CALL];
drop [CALL];

---------------------------------------------------------------------
select '----2 check contraints';
---------------------------------------------------------------------

--2.1 check PK
CREATE TABLE t2_a (
 id INT NOT NULL DEFAULT 0 PRIMARY KEY,
 phone VARCHAR(10));
show create table t2_a;
drop table t2_a;

CREATE TABLE t2_b (
 host_year INT NOT NULL,
 event_code INT NOT NULL,
 athlete_code INT NOT NULL,
 medal CHAR(1) NOT NULL,
 score VARCHAR(20),
 unit VARCHAR(5),
 PRIMARY KEY(host_year, event_code, athlete_code, medal));
show create table t2_b;
drop table t2_b;

--2.1(additional) check keyword (PK name)
CREATE TABLE t2_b_keyword (
 [DATE] INT NOT NULL,
 [CREATE] INT NOT NULL,
 CONSTRAINT [NULL] PRIMARY KEY ([DATE], [CREATE]));
show create table t2_b_keyword;
drop t2_b_keyword;

--2.2 check unique
CREATE TABLE t2_c(id INT UNIQUE, phone VARCHAR);
show create table t2_c;
drop t2_c;

--2.2(additional) check keyword(unique name)
CREATE TABLE t2_c_keyword (
 [REFERENCES] INT, 
 [RESTRICT] VARCHAR,
 CONSTRAINT [CONSTRAINT] UNIQUE ([REFERENCES]));
show create table t2_c_keyword;
drop t2_c_keyword;

--2.3 check FK and cache obj
CREATE TABLE t2_d (
 ID INT NOT NULL,
 name VARCHAR(10) NOT NULL,
 CONSTRAINT pk_id PRIMARY KEY(id),
 CONSTRAINT fk_id FOREIGN KEY(id) REFERENCES t2_d(id)
 ON DELETE CASCADE ON UPDATE RESTRICT );
show create table t2_d;
drop t2_d;

--2.3(additional)  check keyword (FK name and cache obj name)
CREATE TABLE t2_d_keyword (
 [NOT] INT NOT NULL,
 [NULL] VARCHAR(10) NOT NULL,
 CONSTRAINT [KEY] PRIMARY KEY([NOT]),
 CONSTRAINT [DELETE] FOREIGN KEY([NOT]) REFERENCES t2_d_keyword([NOT])
 ON DELETE CASCADE ON UPDATE RESTRICT );
show create table t2_d_keyword;
drop t2_d_keyword;

--2.4 check index
CREATE TABLE t2_e(id INT, phone VARCHAR, INDEX idx(id DESC, phone ASC));
show create table t2_e;
drop t2_e;

--2.4(additional) check keyword(index name)
CREATE TABLE t2_e_keyword ([UNIQUE] INT, [on] VARCHAR, INDEX [INDEX]([UNIQUE] DESC, [on] ASC));
show create table t2_e_keyword;
drop t2_e_keyword;

create table t2_f_keyword ([DELETE] int, [FOREIGN] int);
create reverse index [create] on t2_f_keyword([DELETE]);
create reverse unique index [index] on t2_f_keyword([FOREIGN]);
show create table t2_f_keyword;
drop t2_f_keyword;

----3 check class attribute
create table t3 class attribute (i int shared 20);
show create table t3;
drop t3;

--check keyword(class attribute)
create table t3_keyword class attribute ([attribute] int shared 30);
show create table t3_keyword;
drop t3_keyword;

----4 check METHOD, CLASS METHOD and FILE
CREATE CLASS t4(
 dummy_column set( int ),
 num int,
 name string
 )
 METHOD get_2000() int FUNCTION TEST_getInt,
 get_success() string FUNCTION TEST_getString,
 CLASS get_null() string FUNCTION TEST_getNull,
 CLASS get_int(int) int FUNCTION TEST_int_input,
 CLASS get_string(string) string FUNCTION TEST_string_input,
 CLASS get_string2(string,string) string FUNCTION TEST_string_input2
 FILE '$HOME/method_test/myyang';
show create table t4;
drop t4;

---check keyword(METHOD name, CLASS METHOD name, FUNCTION name)
CREATE CLASS t4_keyword(
 [set] set( int ),
 [CLASS] int,
 name string
 )
 METHOD [FUNCTION]() int FUNCTION [METHOD],
 CLASS [FILE](string,string) string FUNCTION [string]
 FILE '$HOME/method_test/myyang';
show create table t4_keyword;
drop t4_keyword;

------------------------------------------------------------------------------
select '----5 check reuse id and AUTO_INCREMENT';
------------------------------------------------------------------------------
--5.1 check REUSE_OID
CREATE TABLE t5 (a INT PRIMARY KEY) REUSE_OID;
show create table t5;
drop t5;

--5.2 check AUTO_INCREMENT
CREATE TABLE t5_b (a INT auto_increment) AUTO_INCREMENT = 2; 
show create table t5_b;
drop t5_b;

------------------------------------------------------------------------------
select '----6 check UNDER ';
------------------------------------------------------------------------------
--6.1 check UNDER about attribute and constraint
--CREATE CLASS t6_attribute (
--col1    int,
--col2    varchar(100)
--);
--CREATE CLASS t6_contraint (
--col3    int unique Not Null,
--col4    int primary key,
--col5    varchar(100), 
--col6    int,
--constraint idx unique index(col5),
--CONSTRAINT fk_contraint FOREIGN KEY(col6) REFERENCES t6_contraint(col4)
--);
--CREATE CLASS t6_sub_ac UNDER t6_attribute, t6_contraint(col7 varchar(100));
--show create table t6_sub_ac;
--drop t6_sub_ac;

--No attribute
--CREATE CLASS t6_sub_ac2 UNDER t6_attribute, t6_contraint;
--show create table t6_sub_ac2;
--drop t6_sub_ac2;
--drop t6_attribute;
--drop t6_contraint;

--6.2 check UNDER about class attribute
create table t6_class_attr class attribute (c1 int, c2 int, c3 int);
create table t6_class_attr_sub under t6_class_attr class attribute (c4 int, c5 int);
show create table t6_class_attr_sub;
drop t6_class_attr_sub;

--no class attribute
create table t6_class_attr_sub2 under t6_class_attr;
show create table t6_class_attr_sub2;
drop t6_class_attr_sub2;
drop t6_class_attr;


--6.3 check UNDER about METHOD, CLASS METHOD and FILE
CREATE CLASS t6_method_file(name string)
 METHOD MyMethod1() int FUNCTION func1,
 CLASS ClassMethod1(string,string) string FUNCTION func2
 FILE '$HOME/method_test/myyang';
CREATE CLASS t6_method_file_sub under t6_method_file (name2 string)
 METHOD MyMethod21() int FUNCTION func21,
 CLASS ClassMethod21(string,string) string FUNCTION func22
 FILE '$HOME/method_test/myyang2';
show create table t6_method_file_sub;
drop t6_method_file_sub;

--no METHOD, CLASS METHOD and FILE
CREATE CLASS t6_method_file_sub2 under t6_method_file;
show create table t6_method_file_sub2;
drop t6_method_file_sub2;
drop t6_method_file;

--6.4 check keyword (UNDER class name)
CREATE CLASS [varchar] ([unique] int Unique Not Null);
CREATE CLASS t6_table_keyword UNDER [varchar]
(col    varchar(100));
show create table t6_table_keyword;
drop t6_table_keyword;
drop [varchar];

------------------------------------------------------------------------------
select '----7 check partition table';
------------------------------------------------------------------------------
--7.1 check list partition table
create table t7_list (id int not null ,
                        test_char char(50),
                        test_varchar varchar(2000),
                        test_bit bit(16),
                        test_varbit bit varying(20),
                        test_nchar nchar(50),
                        test_nvarchar nchar varying(2000),
                        test_string string,
                        test_datetime timestamp,
                        primary key(id,test_varchar))
PARTITION BY LIST (test_varchar) (
    PARTITION p0 VALUES IN ('aaa','bbb','ddd'),
    PARTITION p1 VALUES IN ('fff','ggg','hhh'),
    PARTITION p2 VALUES IN ('kkk','lll','mmm')
);
show create table t7_list;
drop t7_list;

--7.2 check range partition table
CREATE TABLE t7_range ( 
store_id string 
) 
PARTITION BY range(to_date(store_id)) (
partition p0 values less than ('1999-01-01'),
partition p1 values less than ('2003-01-01'),
partition p2 values less than MAXVALUE);
show create table t7_range;
drop t7_range;

--7.3 check hash partition table
create table t7_hash (id int not null ,
                         test_int int,
                         test_smallint smallint,
                         test_numeric numeric(38,10),
                         test_float float,
                         test_real real,
                         test_double double,
                         test_monetary monetary,
                         test_datetime timestamp,
                         primary key(id,test_int) )
        PARTITION BY HASH(test_int)
        PARTITIONS 2;
show create table t7_hash;
drop t7_hash;

--7.4 check keyword (partition)
CREATE TABLE t7_keyword ( 
[show] string
) 
PARTITION BY range(to_date([show])) (
partition [monetary] values less than ('1999-01-01'),
partition [numeric] values less than ('2003-01-01'),
partition [values] values less than MAXVALUE);
show create table t7_keyword;
drop t7_keyword;

------------------------------------------------------------------------------
select '----8 check inherent ';
------------------------------------------------------------------------------
CREATE CLASS t8_01;
CREATE TABLE t8_02 UNDER t8_01;
show create table t8_02;


ALTER CLASS t8_01 ADD ATTRIBUTE col1 int unique;
ALTER CLASS t8_01 ADD ATTRIBUTE col2 timestamp NOT NULL;
ALTER CLASS t8_01 ADD ATTRIBUTE col3 double;
ALTER CLASS t8_02 ADD ATTRIBUTE col4 int unique;
ALTER CLASS t8_02 ADD ATTRIBUTE col5 varchar(100) NOT NULL;
show create table t8_02;


CREATE CLASS t8_03  UNDER t8_02,t8_01
 INHERIT col1 of t8_01,
 col1 of t8_01 as col1_modify_1,
 col2 of t8_02,
 col2 of t8_01 as col2_modify_2,
 col3 of t8_02,
 col3 of t8_01 as col3_modify_3 ;
show create table t8_03;


--check keyword (inherent)
create table [CLASS] (
[INT] INT,
[VARCHAR] VARCHAR(100),
[DOUBLE] DOUBLE);
create table [table] (
[INT] INT,
[VARCHAR] VARCHAR(100),
[DOUBLE] DOUBLE);
create table t8_keyword UNDER [CLASS],[table]
INHERIT [INT] of [CLASS],
[VARCHAR] of [CLASS] as [VIEW],
[DOUBLE] of [CLASS] as [TRIGGER];
show create table t8_keyword;

drop t8_03;
drop t8_01;
drop t8_02;
drop t8_keyword;
drop  [table];
drop [CLASS];

------------------------------------------------------------------------
select '----9 check like and as';
------------------------------------------------------------------------
--9.1 check like
CREATE TABLE t9(
id INT NOT NULL DEFAULT 0 PRIMARY KEY,
phone VARCHAR(10));
CREATE TABLE t9_like LIKE t9;
show create table t9_like;

--9.2 check as
CREATE TABLE t9_as AS SELECT * FROM t9;
show create table t9_as;

--9.3.1  check keyword (like)
CREATE TABLE [NULL](
[INT] INT NOT NULL DEFAULT 0 PRIMARY KEY,
[VARCHAR] VARCHAR(10));
CREATE TABLE t9_keyword1 LIKE [NULL];
show create table t9_keyword1;

--9.3.2  check keyword (as)
CREATE TABLE t9_keyword2 AS SELECT * FROM [NULL];
show create table t9_keyword2;

drop t9_like;
drop t9_as;
drop t9_keyword2;
drop t9_keyword1;
drop [NULL];
drop t9;

------------------------------------------------------------------------
select '----10 test table does not exist--------';
------------------------------------------------------------------------
show create table t10_asdf_asdf;
drop t10_asdf_asdf;
------------------------------------------------------------------------
select '----11 test view--------';
------------------------------------------------------------------------
create view v11 as select * from _db_class;
show create table v11;
drop v11;

------------------------------------------------------------------------
select '----12 test AUTHORIZATION';
------------------------------------------------------------------------
CALL login ('public', '') ON CLASS db_user;
show create table _db_class;
CALL login ('dba', '') ON CLASS db_user;
------------------------------------------------------------------------
select '----13 test filter index';
------------------------------------------------------------------------
--13.1 test filter index
CREATE TABLE  filter_t (a INTEGER);
CREATE INDEX index_filter ON filter_t (a) WHERE a > 10;

SHOW CREATE TABLE filter_t;
drop filter_t;

--13.2 check keyword (table name and attribute name)
CREATE TABLE [CREATE] ([INT] INTEGER);
CREATE INDEX filter_create_a ON  [CREATE]([INT]) WHERE [INT] > 10;

SHOW CREATE TABLE [CREATE];
drop [CREATE];

--13.3 there is function in filter
create table filter_b(col char(10));
create index filter_b_idx on filter_b(col) where lower(col)>'a';
show create table filter_b;
drop filter_b;

------------------------------------------------------------------------
select '----14 test function base index';
------------------------------------------------------------------------
--14.1 test function base index
CREATE TABLE func_t (col int);
CREATE INDEX index_func ON func_t(mod (col, 3));

SHOW CREATE TABLE func_t;
drop table func_t;

--14.2 check keyword (table name and attribute name)
CREATE TABLE [ALTER] ([INT] INTEGER);
CREATE INDEX index_alter ON [ALTER](mod ([INT], 3));

SHOW CREATE TABLE [ALTER];
drop [ALTER];

------------------------------------------------------------------------
select '------15 test i18n ---------------';
------------------------------------------------------------------------
create table i18n_t(a string charset utf8 collate utf8_bin);
show create table i18n_t;
drop i18n_t;

--+ holdcas off;
