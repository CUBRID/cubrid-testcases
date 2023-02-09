;au off

CREATE FUNCTION stringTest(x String) RETURN String AS LANGUAGE JAVA NAME 'SpTest7.typeteststring(java.lang.String) return java.lang.String';

CREATE TABLE a_tbl1( id INT UNIQUE,  name VARCHAR, phone VARCHAR DEFAULT '000-0000' );

INSERT INTO a_tbl1 VALUES (1,'aaa', DEFAULT),(2,'bbb', DEFAULT);
INSERT INTO a_tbl1 VALUES (3,'ccc', '333-3333');
INSERT INTO a_tbl1(id) VALUES (4), (5);
INSERT INTO a_tbl1 SET id=6, name='eee';
INSERT INTO a_tbl1 SET id=7, phone='777-7777';

INSERT INTO a_tbl1 VALUES(8, stringTest('ggg'), stringTest((select phone from a_tbl1 where id=7)));

REPLACE INTO a_tbl1 VALUES(1, stringTest('aaaa'), stringTest('111-1111')),(2, stringTest('bbb'), stringTest('222-2222'));
REPLACE INTO a_tbl1 SET id=stringTest(6), name=stringTest('fff'), phone=DEFAULT;
REPLACE INTO a_tbl1 SET id=stringTest(5), name=stringTest((select name from a_tbl1 where id=3)), phone=stringTest((select phone from a_tbl1 where id=1));

-- ON DUPLICATE KEY UPDATE
INSERT INTO a_tbl1 VALUES(2, stringTest('ggg'), stringTest('222-2222')) ON DUPLICATE KEY UPDATE name=stringTest('zzz'), phone = stringTest('999-9999');
INSERT INTO a_tbl1 VALUES(6, stringTest('qqq'), stringTest('444-4444')) ON DUPLICATE KEY UPDATE name=stringTest((select 'qqq' from dual)), phone = stringTest((select phone from a_tbl1 where id=7));

select * from a_tbl1 order by id;


drop a_tbl1;
drop function stringTest;

;au on
