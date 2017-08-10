--+ holdcas on;
set system parameters 'return_null_on_function_errors=yes';
CREATE  function   testresult(q string)  return string as language java name 'jdbc_cubrid415.testresult(java.lang.String) return java.lang.String ';
CREATE  function   testResultSet(q string)  return cursor as language java name 'jdbc_cubrid415.testResultSet(java.lang.String) return java.sql.ResultSet ';

select testresult('select charset,lang from db_root') from db_root;

drop function  testresult;
drop function  testResultSet ;

create table y (a int, b int, c int);
select /*+ recompile */ * from y where a > 0;
select /*+ recompile */ * from y where a > 0;
select /*+ recompile */ * from y where a > 0;

drop table y;
set system parameters 'return_null_on_function_errors=no';
commit;
--+ holdcas off;
