
--+ server-message on

-- Check if an error occurs when OUT parameters are used like IN parameters.


create table plcsql_tbl ( id  integer, name string );
insert into plcsql_tbl values(1, 'name1');
insert into plcsql_tbl values(2, 'name2');
insert into plcsql_tbl values(3, 'name3');

CREATE OR REPLACE PROCEDURE t(param_name IN VARCHAR, out_value OUT VARCHAR)
AS
    CURSOR my_cursor(a VARCHAR) IS SELECT id, name FROM plcsql_tbl
        WHERE name = a;

    target_id INT;
    target_name STRING;
    target_temp STRING;
BEGIN
-- If you try to read the OUT parameter before assigning it, no error occurs and it is treated as a null value. Oracle handles the same thing.
    
    put_line('out_value: ' || out_value);
    OPEN my_cursor(out_value );
    LOOP
        FETCH my_cursor INTO target_id, target_name ;
        EXIT WHEN my_cursor%NOTFOUND;
        put_line('id: ' || target_id || ' name: ' || target_name);
    END LOOP;
    CLOSE my_cursor;
END;

select '12' into :a ;

call t('1234', :a);

call t('1234', '12'); --bug
--If called as above, an error occurs in Oracle. CUBRID runs normally (confirmed on 2023-12-28)

drop procedure t;
drop table plcsql_tbl;

--+ server-message off


