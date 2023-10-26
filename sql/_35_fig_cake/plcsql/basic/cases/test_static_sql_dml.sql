--+ server-message on

create or replace procedure test_ddl(table_name VARCHAR, signature VARCHAR) as
begin
    EXECUTE IMMEDIATE 'drop table if exists ' || table_name;

    // ex) CREATE TABLE 'table_name' (id INT UNIQUE, name VARCHAR, phone VARCHAR DEFAULT ''000-0000'');

    EXECUTE IMMEDIATE 'CREATE TABLE ' || table_name || signature;
    DBMS_OUTPUT.put_line ('creating ' || table_name || ' table is succeeded!');
end;

CALL test_ddl ('test_tbl', '(id INT UNIQUE, name VARCHAR, phone VARCHAR DEFAULT ''000-0000'')');

/* https://www.cubrid.org/manual/en/11.2/sql/query/insert.html */
create or replace procedure test_dml_insert() as
    i int;
    n varchar;
    p varchar;

    temp VARCHAR := '';
begin
-- 0)
--insert default values with DEFAULT keyword before VALUES
    INSERT INTO test_tbl DEFAULT VALUES;

--insert multiple rows
    INSERT INTO test_tbl VALUES (1,'aaa', DEFAULT),(2,'bbb', DEFAULT);

--insert a single row specifying column values for all
    INSERT INTO test_tbl VALUES (3,'ccc', '333-3333');

--insert two rows specifying column values for only
    INSERT INTO test_tbl(id) VALUES (4), (5);

--insert a single row with SET clauses

    temp := temp || '/* ((';
    temp := temp || '(((( */';
    
    temp := temp || 'INSERT INTO test_tbl SET id=6, name=''eee'';';

    temp := temp || '/* ((';
    temp := temp || '(((( */';

    DBMS_OUTPUT.put_line (temp);

    EXECUTE IMMEDIATE temp;
    DBMS_OUTPUT.put_line(temp || ' is succeeded');

    INSERT INTO test_tbl SET id=7, phone='777-7777';

-- 1)
    DBMS_OUTPUT.PUT_LINE('[Test 1] =====================================================================');
    INSERT INTO test_tbl SET id=6, phone='000-0000' ON DUPLICATE KEY UPDATE phone='666-6666';

-- 2)
    DBMS_OUTPUT.PUT_LINE('Expected: ');
    DBMS_OUTPUT.PUT_LINE(6 || ' ' || 'eee' || ' ' || '666-6666');

    DBMS_OUTPUT.PUT_LINE('Actual: ');
    for r in (SELECT id, name, phone FROM test_tbl WHERE id=6) loop
        i := r.id;
        n := r.name;
        p := r.phone;
        DBMS_OUTPUT.PUT_LINE(i || ' ' || n || ' ' || p);
    end loop;
    DBMS_OUTPUT.PUT_LINE('[Test 1] OK');

-- 3)
    DBMS_OUTPUT.PUT_LINE('[Test 2] =====================================================================');
    DBMS_OUTPUT.PUT_LINE('Expected: ');
    DBMS_OUTPUT.PUT_LINE(7 || ' ' || 'ggg' || ' ' || '777-7777');

    INSERT INTO test_tbl SELECT * FROM test_tbl WHERE id=7 ON DUPLICATE KEY UPDATE name='ggg';

    DBMS_OUTPUT.PUT_LINE('Actual: ');
    for r in (SELECT id, name, phone FROM test_tbl WHERE id=7) loop
        i := r.id;
        n := r.name;
        p := r.phone;
        DBMS_OUTPUT.PUT_LINE(i || ' ' || n || ' ' || p);
    end loop;

    DBMS_OUTPUT.PUT_LINE('[Test 2] OK');
end;

/* https://www.cubrid.org/manual/en/11.2/sql/query/update.html */
create or replace procedure test_dml_delete() as
    p varchar;
begin
    DELETE FROM test_tbl WHERE phone IS NULL;

/*
           id  phone
===================================
            1  '111-1111'
            2  '222-2222'
            3  '333-3333'
            5  NULL
*/

    for r in (SELECT phone FROM test_tbl) loop
        p := r.phone;
        DBMS_OUTPUT.PUT_LINE(p);
    end loop;
end;

/* https://www.cubrid.org/manual/en/11.2/sql/query/truncate.html */
create or replace procedure test_dml_truncate() as
begin
    truncate TABLE test_tbl;
end;

call test_dml_insert ();
SELECT * FROM test_tbl;
call test_dml_truncate ();
SELECT * FROM test_tbl;
call test_dml_insert ();
SELECT * FROM test_tbl;


CALL test_ddl ('test_tbl', '(
        id INT NOT NULL,
        phone VARCHAR(10));');
INSERT INTO test_tbl VALUES (1,'111-1111'), (2,'222-2222'), (3, '333-3333'), (4, NULL), (5, NULL);
call test_dml_delete ();
SELECT * FROM test_tbl;

DROP PROCEDURE test_dml_truncate, test_dml_delete, test_dml_insert, test_ddl;
DROP TABLE test_tbl;
