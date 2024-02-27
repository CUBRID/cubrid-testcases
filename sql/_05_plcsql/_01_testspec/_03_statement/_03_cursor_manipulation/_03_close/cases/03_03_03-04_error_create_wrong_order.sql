--+ server-message on

-- Cursors are used in the following order: declaration, open, fetch, and close.
-- Check whether errors occur normally by using them in a different order or omitting them in the middle.

drop table IF EXISTS plcsql_tbl; 
create table plcsql_tbl ( id  integer, name string );
insert into plcsql_tbl values(1, 'name1');
insert into plcsql_tbl values(2, 'name2');
insert into plcsql_tbl values(3, 'name3');

// normall order : declaration, open, fetch, and close

//error order : open, fetch, close
CREATE OR REPLACE PROCEDURE t(param_name VARCHAR)
AS
//    CURSOR my_cursor(a VARCHAR) IS SELECT id, name FROM plcsql_tbl
//        WHERE name = a;

    target_id INT;
    target_name STRING;
BEGIN

    OPEN my_cursor(param_name);
    LOOP
        FETCH my_cursor INTO target_id, target_name;
        EXIT WHEN my_cursor%NOTFOUND;
        put_line('id: ' || target_id || ' name: ' || target_name);
    END LOOP;
    CLOSE my_cursor;
END;


drop table plcsql_tbl;

--+ server-message off
