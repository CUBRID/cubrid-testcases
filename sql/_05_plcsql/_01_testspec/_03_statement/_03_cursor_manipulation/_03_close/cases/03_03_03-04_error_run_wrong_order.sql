--+ server-message on

-- Cursors are used in the following order: declaration, open, fetch, and close.
-- Check whether errors occur normally by using them in a different order or omitting them in the middle.

drop table IF EXISTS plcsql_tbl;
create table plcsql_tbl ( id  integer, name string );
insert into plcsql_tbl values(1, 'name1');
insert into plcsql_tbl values(2, 'name2');
insert into plcsql_tbl values(3, 'name3');

// normall order : declaration, open, fetch, and close

//error order : declaration, close, open, fetch
//An error occurs during execution.
CREATE OR REPLACE PROCEDURE t(param_name VARCHAR)
AS
    CURSOR my_cursor(a VARCHAR) IS SELECT id, name FROM plcsql_tbl
        WHERE name = a;

    target_id INT;
    target_name STRING;
BEGIN
    CLOSE my_cursor;
    OPEN my_cursor(param_name);
    LOOP
        FETCH my_cursor INTO target_id, target_name;
        EXIT WHEN my_cursor%NOTFOUND;
        put_line('id: ' || target_id || ' name: ' || target_name);
    END LOOP;
END;

call t('name1');


//error order : declaration, fetch, and close
//An error occurs during execution.
CREATE OR REPLACE PROCEDURE t(param_name VARCHAR)
AS
    CURSOR my_cursor(a VARCHAR) IS SELECT id, name FROM plcsql_tbl
        WHERE name = a;

    target_id INT;
    target_name STRING;
BEGIN

//    OPEN my_cursor(param_name);
    LOOP
        FETCH my_cursor INTO target_id, target_name;
        EXIT WHEN my_cursor%NOTFOUND;
        put_line('id: ' || target_id || ' name: ' || target_name);
    END LOOP;
    CLOSE my_cursor;
END;

call t('name1');


//error order : declaration, open, close, fetch
//An error occurs during execution.
CREATE OR REPLACE PROCEDURE t(param_name VARCHAR)
AS
    CURSOR my_cursor(a VARCHAR) IS SELECT id, name FROM plcsql_tbl
        WHERE name = a;

    target_id INT;
    target_name STRING;
BEGIN

    OPEN my_cursor(param_name);
    CLOSE my_cursor;
    LOOP
        FETCH my_cursor INTO target_id, target_name;
        EXIT WHEN my_cursor%NOTFOUND;
        put_line('id: ' || target_id || ' name: ' || target_name);
    END LOOP;
END;

call t('name1');



//error order : declaration, open, close, fetch
//An error occurs during execution.
CREATE OR REPLACE PROCEDURE t(param_name VARCHAR)
AS
    CURSOR my_cursor(a VARCHAR) IS SELECT id, name FROM plcsql_tbl
        WHERE name = a;

    target_id INT;
    target_name STRING;
BEGIN

    OPEN my_cursor(param_name);
    LOOP
        CLOSE my_cursor;
        FETCH my_cursor INTO target_id, target_name;
        EXIT WHEN my_cursor%NOTFOUND;
        put_line('id: ' || target_id || ' name: ' || target_name);
    END LOOP;
END;

call t('name1');



//error order : declaration, fetch, close, close
//An error occurs during execution.
CREATE OR REPLACE PROCEDURE t(param_name VARCHAR)
AS
    CURSOR my_cursor(a VARCHAR) IS SELECT id, name FROM plcsql_tbl
        WHERE name = a;

    target_id INT;
    target_name STRING;
BEGIN

    //OPEN my_cursor(param_name);
    LOOP
        FETCH my_cursor INTO target_id, target_name;
        CLOSE my_cursor;
        EXIT WHEN my_cursor%NOTFOUND;
        put_line('id: ' || target_id || ' name: ' || target_name);
    END LOOP;
    CLOSE my_cursor;
END;

call t('name1');


//error order : declaration, open, open, fetch, close
//An error occurs during execution.
CREATE OR REPLACE PROCEDURE t(param_name VARCHAR)
AS
    CURSOR my_cursor(a VARCHAR) IS SELECT id, name FROM plcsql_tbl
        WHERE name = a;

    target_id INT;
    target_name STRING;
BEGIN

    OPEN my_cursor(param_name);
    OPEN my_cursor(param_name);
    LOOP
        FETCH my_cursor INTO target_id, target_name;
        EXIT WHEN my_cursor%NOTFOUND;
        put_line('id: ' || target_id || ' name: ' || target_name);
    END LOOP;
    CLOSE my_cursor;
END;
call t('name1');


//error order : declaration, open, fetch, fetch, close
//No error occurs. There is no output result.
CREATE OR REPLACE PROCEDURE t(param_name VARCHAR)
AS
    CURSOR my_cursor(a VARCHAR) IS SELECT id, name FROM plcsql_tbl
        WHERE name = a;

    target_id INT;
    target_name STRING;
BEGIN

    OPEN my_cursor(param_name);
    LOOP
        FETCH my_cursor INTO target_id, target_name;
        FETCH my_cursor INTO target_id, target_name;
        EXIT WHEN my_cursor%NOTFOUND;
        put_line('id: ' || target_id || ' name: ' || target_name);
    END LOOP;
    CLOSE my_cursor;
END;

call t('name1');


//error order : declaration, close, open, fetch, close
//An error occurs during execution.
CREATE OR REPLACE PROCEDURE t(param_name VARCHAR)
AS
    CURSOR my_cursor(a VARCHAR) IS SELECT id, name FROM plcsql_tbl
        WHERE name = a;

    target_id INT;
    target_name STRING;
BEGIN

    CLOSE my_cursor;
    OPEN my_cursor(param_name);
    LOOP
        FETCH my_cursor INTO target_id, target_name;
        EXIT WHEN my_cursor%NOTFOUND;
        put_line('id: ' || target_id || ' name: ' || target_name);
    END LOOP;
    CLOSE my_cursor;
END;

call t('name1');

drop table plcsql_tbl;
drop procedure t;


--+ server-message off
