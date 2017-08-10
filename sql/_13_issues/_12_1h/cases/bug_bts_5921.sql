 CREATE TABLE types
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
 clob_col ClOB
 ); 
SHOW COLUMNS FROM types;
drop types;
