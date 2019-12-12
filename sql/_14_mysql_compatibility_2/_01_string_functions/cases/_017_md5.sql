-- check function with NULL  argument --
SELECT MD5(NULL);

-- check function with a literal, non-char argument (implies conversion to char) --
SELECT MD5(1);

-- check function result data type --
CREATE TABLE MD5Type AS SELECT MD5(1) AS MD5Col;
SELECT attr_name, class_name, attr_type, data_type FROM db_attribute WHERE class_name='md5type' AND attr_name='md5col';
DROP TABLE MD5Type;

-- check run-time function --
SELECT MD5(CAST(1024 AS CHAR VARYING));
SELECT MD5(CAST(1024 AS NCHAR VARYING));

-- check some literal strings --
SELECT MD5('SQL-99 Complete. Really!');

-- check host variables support --
PREPARE st FROM 'SELECT MD5(?)'
EXECUTE st USING 'SQL-99 Complete. Really!';

CREATE TABLE test (
  test_id				int 						NOT NULL,
  test_id_md5	CHAR(32)			NOT NULL,
  [str1]						VARCHAR(64)		NOT NULL,
  [str1_md5]				CHAR(32) 			NOT NULL,
  str2				STRING 				NOT NULL,
  str2_md5 		CHAR(32) 			NOT NULL,
  str3 					STRING 				NOT NULL,
  str3_md5 			CHAR(32) 			NOT NULL,
  str4 								VARCHAR(128)	NOT NULL,
  str4_md5 					CHAR(32) 			NOT NULL,
  PRIMARY KEY  (test_id),
  UNIQUE KEY [str1] ([str1])
);


INSERT INTO test (test_id, test_id_md5, str1, str1_md5, str2, str2_md5, str3, str3_md5, str4, str4_md5) VALUES
(3, 'eccbc87e4b5ce2fe28308fd9f2a7baf3', 'MP', 'c90a918b859bd1e56cf99af6246b128e', 'GLength(ls)\n\nJoin type: It is printed as (inner join) on the above. The following are the join types which are printed on the query plan.\n\nstr4: http://aaaaaaaaaa.com/def/aaa/5.0/aa/count\n\n', 'cc325c2213ce6611165d8a60d789e929', 'csql> SELECT UTC_DATE(), UTC_DATE() + 0;\n=== <Result of SELECT Command in Line 1> ===\n   utc_date()    utc_date() +0\n==============================\n  02/24/2016    02/24/2016    \n\n1 row selected. (0.014328 sec) Committed.\n\n1 command(s) successfully processed.\ncsql> ', '3ed89c10d7011d59498a1783a00ac79e', 'http://www.cubrid.org/manual/93/en/sql/function/LWWSFJ.html', '294309d57ef088c34651dfab8084d188'),
(4, 'a87ff679a2f3e71d9181a67b7542122c', 'HVAQWQO', '516656ee68dd90aa74298a133f741013', 'Query Plan Related Terms\n\nThe following show the meaning for each term which is printed as a query plan. (28 - 1) \nNested loop join, and it is a join which uses an index in \n\nstr4: http://aaaaaaaaaa.com/def/aaa/5.0/aa/count\n\n', '00d1e74a7bb12889ea64c6c116cf12a6', 'csql> SELECT count(*) FROM db_root;\n\n=== <Result of SELECT Command in Line 1> ===\n\n        ->count(*)\n=============\n            1\n\n        ->1 row selected. (0.014926 sec) Committed.\n\n1 command(s) successfully processed.\ncsql>', '8e293d4c4597ef6db4d3c4cd44d90815', 'http://www.cubrid.org/manual/93/en/sql/function/comparison_op.html', 'f1ece26b33f592bcd633279f7ae2ba79'),
(6, '1679091c5a880faf6fb5e6087eb1b2dc', 'EGDHG', '02464da625a803944c1dc93313cb9fec', 'qualifier:\nquery_term (statement_set\r_operator [qualifier] )<query_term>[{statement_set_operator [,qualifier] <query_term>}]', 'f4f6379c4df2c0c994077a36b9735a52', 'csql> SELECT 29 | 15;\n\n        -> === <Result of SELECT Command in Line 1> ===\n\n                 29|15\n======================\n\n                  31\n1 row selected. (0.014428 sec) Committed.', '8ca978eb34652707e450d624e722e5cc', 'http://www.cubrid.org/manual/93/en/sql/function/comparison_op.html', 'f1ece26b33f592bcd633279f7ae2ba79'),
(7, '8f14e45fceea167a5a36dedd4bea2543', 'RUADHE', '685f85cc2b76a4f927ec2a40761c2160', 'Conflict:\nquery_term statement_set_operator [qualifier] <query_term>\n\n[{statement_set_operator [qualifier] <query_term>}]\n    <query_term> ::=\n\tquery_specification\tsubquery', '77120f956e51b83f3ad4f42295811da6', '', 'd41d8cd98f00b204e9800998ecf8427e', 'http://www.cubrid.org/manual/93/en/sql/function/DCOSDEM.html', 'fb9b7b2c45c4a41c7f912cee039dfa04'),
(8, 'c9f0f895fb98ab9159f51fd0297e236d', 'BNNFHR', '6afa82bfa96329849a6696d17d3f6e87', 'Statement  [(qualifier)]\n\nThe following table shows statement set operators supported by CUBRID.\n6l\n\n', 'b2e1596f142ce51dd72e29d9f63602fb', '', 'd41d8cd98f00b204e9800998ecf8427e', 'http://www.cubrid.org/manual/93/en/sql/function/DCOSDEM.html', 'fb9b7b2c45c4a41c7f912cee039dfa04');


UPDATE
	test
SET
   str1 = 
   	REPLACE
   		(
   			REPLACE
   				(
   					REPLACE
   						(
   							REPLACE
   								(
   									REPLACE
   										(
   											REPLACE
   												(
   													REPLACE
   														(
   															REPLACE
   																(
   																	REPLACE(str1, '\0', CHR(0)),
   																	'\''',
   																	''''
   																),
   															'\"',
   															'"'
   														),
   													'\b',
   													CHR(8)
   												),
   											'\n',
   											CHR(10)
   										),
   										'\r',
   										CHR(13)
   								),
   								'\t',
   								CHR(9)
   						),
   						'\z',
   						CHR(26)
   				),
   				'\\',
   				'\'
   		),
   	str2 = 
   	REPLACE
   		(
   			REPLACE
   				(
   					REPLACE
   						(
   							REPLACE
   								(
   									REPLACE
   										(
   											REPLACE
   												(
   													REPLACE
   														(
   															REPLACE
   																(
   																	REPLACE(str2, '\0', CHR(0)),
   																	'\''',
   																	''''
   																),
   															'\"',
   															'"'
   														),
   													'\b',
   													CHR(8)
   												),
   											'\n',
   											CHR(10)
   										),
   										'\r',
   										CHR(13)
   								),
   								'\t',
   								CHR(9)
   						),
   						'\z',
   						CHR(26)
   				),
   				'\\',
   				'\'
   		),
   str3 = 
   	REPLACE
   		(
   			REPLACE
   				(
   					REPLACE
   						(
   							REPLACE
   								(
   									REPLACE
   										(
   											REPLACE
   												(
   													REPLACE
   														(
   															REPLACE
   																(
   																	REPLACE(str3, '\0', CHR(0)),
   																	'\''',
   																	''''
   																),
   															'\"',
   															'"'
   														),
   													'\b',
   													CHR(8)
   												),
   											'\n',
   											CHR(10)
   										),
   										'\r',
   										CHR(13)
   								),
   								'\t',
   								CHR(9)
   						),
   						'\z',
   						CHR(26)
   				),
   				'\\',
   				'\'
   		),
    str4 = 
   	REPLACE
   		(
   			REPLACE
   				(
   					REPLACE
   						(
   							REPLACE
   								(
   									REPLACE
   										(
   											REPLACE
   												(
   													REPLACE
   														(
   															REPLACE
   																(
   																	REPLACE(str4, '\0', CHR(0)),
   																	'\''',
   																	''''
   																),
   															'\"',
   															'"'
   														),
   													'\b',
   													CHR(8)
   												),
   											'\n',
   											CHR(10)
   										),
   										'\r',
   										CHR(13)
   								),
   								'\t',
   								CHR(9)
   						),
   						'\z',
   						CHR(26)
   				),
   				'\\',
   				'\'
   		); 		
   		
SELECT 
	test_id, str1 
FROM
	test
WHERE
	test_id_md5 != MD5(test_id)
		OR
	str1_md5 != MD5(str1)
		OR
	str2_md5 != MD5(str2)
		OR
	str3_md5 != MD5(str3)
		OR
	str4_md5 != MD5(str4)
ORDER BY test_id, str1;

DROP TABLE test;


create table t1(s varchar(10));

insert into t1 values(null);

select md5(s) from t1;

drop table t1;

--1. Test string types
select if(md5('a') = '0cc175b9c0f1b6a831c399e269772661', 'ok', 'nok');
select if(md5('abcdefghijklmnopqrstuvwxyz') = 'c3fcd3d76192e4007dfb496cca67e13b', 'ok', 'nok');
select if(md5('') = 'd41d8cd98f00b204e9800998ecf8427e', 'ok', 'nok');
select if(md5(null) is null, 'ok', 'nok');

select if(md5(n'a') = md5('a'), 'ok', 'nok');
select if(md5(n'abcdefghijklmnopqrstuvwxyz') = md5('abcdefghijklmnopqrstuvwxyz'), 'ok', 'nok');
select if(md5(n'') = md5(''), 'ok', 'nok');

-- server side
create table t (c char(128), vc varchar(128), nc nchar(128), vnc nchar varying(128));
insert into t values('a', 'a', n'a', n'a');
select if(md5(c) = md5(cast('a' as char(128))), 'ok', 'nok') from t;
select if(md5(vc) = md5(cast('a' as char varying(128))), 'ok', 'nok') from t;
select if(md5(nc) = md5(cast(n'a' as nchar(128))), 'ok', 'nok') from t;
select if(md5(vnc) = md5(cast(n'a' as nchar varying(128))), 'ok', 'nok') from t;
drop table t;

--2. Test numeric types (conversion)
select if(md5('1') = md5(cast(1 as short)), 'ok', 'nok');
select if(md5('1') = md5(cast(1 as integer)), 'ok', 'nok');
select if(md5('1') = md5(cast(1 as bigint)), 'ok', 'nok');
--float and double tests will fail because of precision
select if(md5('1.1') = md5(cast(1.1 as float)), 'ok', 'nok');
select if(md5('1.1') = md5(cast(1.1 as double)), 'ok', 'nok');
select if(md5('1.1') = md5(cast(1.1 as numeric(10,1))), 'ok', 'nok');
select if(md5('$1.1') = md5(cast(1.1 as monetary)), 'ok', 'nok');

--3. Test bit types (conversion)
select if(md5(b'1') = md5('8'), 'ok', 'nok');
select if(md5(cast(b'1' as bit(8))) = md5('80'), 'ok', 'nok');
drop variable @x,@A,@a,@gc,@x2,@g1,@g2,@pt;

