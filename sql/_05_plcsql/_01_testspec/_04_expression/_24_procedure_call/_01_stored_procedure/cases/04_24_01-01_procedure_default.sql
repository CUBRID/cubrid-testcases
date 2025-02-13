--+ server-message on

-- Verifies : CBRD-25658
-- default : procedure default 
-- If CUBRID string and NULL are bundled, NULL is output.
-- empty string is 'null' value when expressed in Oracle style, set the system parameter in ".conf" to 'oracle_style_empty_string=yes' and run the database.

CREATE OR REPLACE PROCEDURE default_procedure_simple (
    p_id INTEGER DEFAULT 100
) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('1: ' || p_id);
END;

CREATE OR REPLACE PROCEDURE default_procedure_with_pseudo (
    p_date DATE DEFAULT SYSDATE,
    p_null_value INTEGER DEFAULT NULL,
    p_null_string VARCHAR DEFAULT 'NULL',
    p_empty_string VARCHAR DEFAULT '',
    p_user VARCHAR DEFAULT USER,
    p_fuser VARCHAR DEFAULT USER(),
    p_cuser VARCHAR DEFAULT CURRENT_USER,
    p_unix_timestamp INTEGER DEFAULT UNIX_TIMESTAMP(),
    p_sys_timestamp TIMESTAMP DEFAULT SYS_TIMESTAMP,
    p_curr_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    p_sys_datetime DATETIME DEFAULT SYS_DATETIME,
    p_curr_datetime DATETIME DEFAULT CURRENT_DATETIME,
    p_curr_date DATE DEFAULT CURRENT_DATE,
    p_sys_time TIME DEFAULT SYS_TIME,
    p_curr_time TIME DEFAULT CURRENT_TIME,
    p_var_number VARCHAR DEFAULT '12345',
    p_var_datetime VARCHAR DEFAULT TO_CHAR(sysdatetime, 'YYYY-MM-DD HH24:MI:SS')
) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE(' 0: ' || CASE isnull(p_date) WHEN 0 THEN 'ok' WHEN 1 THEN 'nok' END);  
    DBMS_OUTPUT.PUT_LINE(' 1: ' || CASE WHEN p_null_value IS NULL THEN 'ok' ELSE 'nok' END);
    DBMS_OUTPUT.PUT_LINE(' 2: ' || CASE WHEN p_null_string = 'NULL' THEN 'ok' ELSE 'nok' END);
    DBMS_OUTPUT.PUT_LINE(' 3: ' || CASE WHEN p_empty_string = ''  THEN 'ok' ELSE 'nok' END);
    DBMS_OUTPUT.PUT_LINE(' 4: ' || CASE WHEN p_user = 'DBA' THEN 'ok' ELSE 'nok' END);
    DBMS_OUTPUT.PUT_LINE(' 5: ' || CASE WHEN p_fuser = USER() THEN 'ok' ELSE 'nok' END);
    DBMS_OUTPUT.PUT_LINE(' 6: ' || CASE WHEN p_cuser = 'DBA' THEN 'ok' ELSE 'nok' END);
    DBMS_OUTPUT.PUT_LINE(' 7: ' || CASE WHEN p_unix_timestamp > 0 THEN 'ok' ELSE 'nok' END);
    DBMS_OUTPUT.PUT_LINE(' 8: ' || CASE isnull(p_sys_timestamp) WHEN 0 THEN 'ok' WHEN 1 THEN 'nok' END);
    DBMS_OUTPUT.PUT_LINE(' 9: ' || CASE isnull(p_curr_timestamp) WHEN 0 THEN 'ok' WHEN 1 THEN 'nok' END);
    DBMS_OUTPUT.PUT_LINE('10: ' || CASE isnull(p_sys_datetime) WHEN 0 THEN 'ok' WHEN 1 THEN 'nok' END);
    DBMS_OUTPUT.PUT_LINE('11: ' || CASE isnull(p_curr_datetime) WHEN 0 THEN 'ok' WHEN 1 THEN 'nok' END);
    DBMS_OUTPUT.PUT_LINE('12: ' || CASE isnull(p_curr_date) WHEN 0 THEN 'ok' WHEN 1 THEN 'nok' END);
    DBMS_OUTPUT.PUT_LINE('13: ' || CASE isnull(p_sys_time) WHEN 0 THEN 'ok' WHEN 1 THEN 'nok' END);
    DBMS_OUTPUT.PUT_LINE('14: ' || CASE isnull(p_curr_time) WHEN 0 THEN 'ok' WHEN 1 THEN 'nok' END);
    DBMS_OUTPUT.PUT_LINE('15: ' || CASE WHEN p_var_number = '12345' THEN 'ok' ELSE 'nok' END);
    DBMS_OUTPUT.PUT_LINE('16: ' || CASE length(p_var_datetime) WHEN 19 THEN 'ok' WHEN 1 THEN 'nok' END);
END;

CREATE OR REPLACE PROCEDURE default_proc_tochar (
    p_formatted_date VARCHAR DEFAULT TO_CHAR(SYSDATE, 'YYYY-MM-DD'),
    p_formatted_sys_date VARCHAR DEFAULT TO_CHAR(SYS_DATE, 'YYYY-MM-DD')
) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Formatted Date: ' || CASE length(p_formatted_date) WHEN 10 THEN 'ok' ELSE 'nok' END);
    DBMS_OUTPUT.PUT_LINE('Formatted SYS_Date: ' || CASE length(p_formatted_sys_date) WHEN 10 THEN 'ok' ELSE 'nok' END);
END;

call default_procedure_simple ();
call default_procedure_with_pseudo ();
call default_proc_tochar ();

select * from _db_stored_procedure_args where sp_of.sp_name = 'default_procedure_simple';
select * from _db_stored_procedure_args where sp_of.sp_name = 'default_procedure_with_pseudo' order by index_of;
select * from _db_stored_procedure_args where sp_of.sp_name = 'default_proc_tochar' order by index_of;

drop procedure default_procedure_simple;
drop procedure default_procedure_with_pseudo;
drop procedure default_proc_tochar;

--+ server-message off
