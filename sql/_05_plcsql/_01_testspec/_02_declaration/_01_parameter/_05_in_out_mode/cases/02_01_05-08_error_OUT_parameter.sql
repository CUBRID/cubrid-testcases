
--+ server-message on

-- Check if an error occurs when OUT parameters are used like IN parameters.


drop table if exists plcsql_tbl;
create table plcsql_tbl ( id  integer, name string );
insert into plcsql_tbl values(1, 'name1');
insert into plcsql_tbl values(2, 'name2');
insert into plcsql_tbl values(3, 'name3');


CREATE OR REPLACE PROCEDURE t(in_value IN int, out_value OUT VARCHAR)
AS
    CURSOR my_cursor(a NUMERIC) IS SELECT name FROM plcsql_tbl
        WHERE id = a;
    target_name STRING;
BEGIN
    -- If you try to read the OUT parameter before assigning it, no error occurs and it is treated as a null value. Oracle handles the same thing.
    OPEN my_cursor(in_value);
    LOOP
        FETCH my_cursor INTO target_name ;
        EXIT WHEN my_cursor%NOTFOUND;
		dbms_output.put_line('id: ' || in_value || ' name: ' || target_name);
        out_value := target_name;
    END LOOP;
    CLOSE my_cursor;
END;

select '12' into :a from dual;

call t('1', :a);
select :a as "out parameter result" from dual;

--bug: If called as above, an error occurs in Oracle. CUBRID runs normally (confirmed on 2023-12-28)
call t('1234', '12');

drop procedure t;
drop table plcsql_tbl;

--+ server-message off


