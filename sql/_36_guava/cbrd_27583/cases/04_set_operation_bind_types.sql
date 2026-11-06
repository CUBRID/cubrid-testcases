/**
 *  This test case verifies CBRD-27583: a host variable in a set operation or in a VALUES
 *  list of several rows decides the column's type as a literal of its value's type does, when
 *  the other branch is neither a number nor a string (JSON, TIMESTAMP).
 *
 *  Before the change the plan compiled without the value could not decide the column's type,
 *  so the host variable's branch kept a cast to an undecided type, and a row of that branch
 *  failed with -181, Cannot coerce value of domain json to domain *variable*, while the same
 *  value written as a literal answered rows of the compatible type.
 *  Now a typed host variable answers as the literal (specification change 25), and a NULL
 *  takes the other branch's type as a NULL literal does.  Where the other branch is a number
 *  or a string, and between the two parts of a recursive CTE, the value converts as before.
 *
 *  Judged by the literal results: every EXECUTE answers the rows of the literal statement
 *  beside it.  Before the change the EXECUTE statements of Cases 1 to 4 failed with -181.
 *
 *  Coverage:
 *    Case 1:  JSON UNION ALL and UNION a string host variable, in both branch orders
 *    Case 2:  JSON DIFFERENCE and INTERSECT a string host variable
 *    Case 3:  TIMESTAMP UNION a string host variable, and VALUES of two rows
 *    Case 4:  TIMESTAMP inserted from UNION ALL with a string and a NULL host variable
 *    Case 5:  a number and a string branch, and a recursive CTE, convert as before
 */

drop table if exists t_json, t_stamp;

create table t_json (j json);
insert into t_json values ('{"a":1}');
create table t_stamp (x timestamp);


evaluate 'Case 1: JSON UNION ALL and UNION a string host variable, in both branch orders';
prepare s_all from 'select j from t_json union all select ? from db_root order by 1';
execute s_all using 'ab';
execute s_all using '[1]';
select j from t_json union all select 'ab' from db_root order by 1;
prepare s_first from 'select ? from db_root union select j from t_json order by 1';
execute s_first using 'ab';
select 'ab' from db_root union select j from t_json order by 1;


evaluate 'Case 2: JSON DIFFERENCE and INTERSECT a string host variable';
prepare s_diff from 'select j from t_json difference select ? from db_root order by 1';
execute s_diff using 'ab';
select j from t_json difference select 'ab' from db_root order by 1;
prepare s_inter from 'select j from t_json intersect select ? from db_root order by 1';
execute s_inter using 'ab';
select j from t_json intersect select 'ab' from db_root order by 1;
-- held out until CBRD-27679: a NULL host variable against the JSON branch, whose rows the JDBC driver reads with the column type of the prepare


evaluate 'Case 3: TIMESTAMP UNION a string host variable, and VALUES of two rows';
prepare s_stamp from 'select (timestamp ''23:15:45 10/31/2009'') union select (?) order by 1';
execute s_stamp using '2010-01-01 10:00:00';
select (timestamp '23:15:45 10/31/2009') union select ('2010-01-01 10:00:00') order by 1;
prepare s_values from 'values (timestamp ''23:15:45 10/31/2009''), (?)';
execute s_values using '2010-01-01 10:00:00';
values (timestamp '23:15:45 10/31/2009'), ('2010-01-01 10:00:00');


evaluate 'Case 4: TIMESTAMP inserted from UNION ALL with a string and a NULL host variable';
prepare s_insert from 'insert into t_stamp select timestamp ''23:15:45 10/31/2009'' from db_root union all select ? from db_root';
execute s_insert using '2010-01-01 10:00:00';
execute s_insert using null;
select x from t_stamp order by 1;


evaluate 'Case 5: a number and a string branch, and a recursive CTE, convert as before';
prepare s_number from 'select round (x, 2) from (select 7 x from db_root union all select ? from db_root) dt order by 1';
execute s_number using '1.5';
prepare s_char from 'select cast (''abc'' as char(5)) from db_root union all select ? from db_root order by 1';
execute s_char using 123;
prepare s_cte from 'with recursive c (n, s) as (select 1, ? from db_root union all select n + 1, s from c where n < 3) select n, s from c order by 1';
execute s_cte using 'q';
execute s_cte using null;

deallocate prepare s_all;
deallocate prepare s_first;
deallocate prepare s_diff;
deallocate prepare s_inter;
deallocate prepare s_stamp;
deallocate prepare s_values;
deallocate prepare s_insert;
deallocate prepare s_number;
deallocate prepare s_char;
deallocate prepare s_cte;
drop table t_json, t_stamp;
