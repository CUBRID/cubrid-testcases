autocommit off;

CREATE  function   testresult(q string)  return string as language java name 'jdbc_cubrid415.testresult(java.lang.String) return java.lang.String ';
CREATE  function   testResultSet(q string)  return cursor as language java name 'jdbc_cubrid415.testResultSet(java.lang.String) return java.sql.ResultSet ';
create function func(a int, b int) return int as language java name 'SpTest.testInt(int, int) return int';

create class kor ( id int, name string);
insert into kor values(1000, 'xxx');
insert into kor values(2000, 'yyy');
insert into kor values(3000, 'zzz');

CREATE  function   testresult10()  return string as language java name 'jdbc_cubrid415.testresult10() return java.lang.String ';
CREATE  function   testResultSet10()  return cursor as language java name 'jdbc_cubrid415.testResultSet10() return java.sql.ResultSet ';

call testresult('select * from kor');
select testresult('select * from kor') from db_root;
call testresult('select name,id,password from db_user order by 1');
--select testresult('select name,id,password from db_user') from db_root;
call testresult('select * from kor union all select * from kor');
call testresult('select id first_row, name second_row  from kor');
call testresult('select func(id, id) func_result  from kor');
$out:varchar,$NULL,$integer,$1000,$integer,$1000;
? = call func(?,?) ;
$out:varchar,$NULL,$varchar,$select * from kor;
? = call testresult(?) ;
$out:varchar,$NULL,$varchar,$select * from kor;
? = call testresult(?) ;
$varchar,$select func(id, id) func_result  from kor where id > 0;
select  testresult(?) from db_root ;

call testResultSet('select * from kor');
select testResultSet('select * from kor') from db_root;
select testResultSet('select * from kor') + 1 from db_root;

call testResultSet10();
select testResultSet10() from db_root;
select testResultSet10() + 1 from db_root;
call testresult10();

CREATE  procedure   testResultSet2(x out cursor)  as language java name 'jdbc_cubrid415.testResultSet2(java.sql.ResultSet ) ';
drop procedure testResultSet2;
CREATE  procedure   testResultSet2(x in out cursor)  as language java name 'jdbc_cubrid415.testResultSet2(java.sql.ResultSet ) ';
CREATE  procedure   testResultSet2(x in  cursor)  as language java name 'jdbc_cubrid415.testResultSet2(java.sql.ResultSet ) ';

CREATE  function   testresult1()  return string as language java name 'jdbc_cubrid415.testresult1() return java.lang.String ';
CREATE  function   testResultSet1()  return cursor as language java name 'jdbc_cubrid415.testResultSet1() return java.sql.ResultSet ';
call testresult1();

create class xoo ( xxx object);
call testResultSet('select * from kor') into :x;

drop function  testresult,testResultSet ;
drop table kor;

rollback;

autocommit on;

