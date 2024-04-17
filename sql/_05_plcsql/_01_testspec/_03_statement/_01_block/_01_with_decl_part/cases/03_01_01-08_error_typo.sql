--+ server-message on

--Check the grammar of the block execution statement. 

CREATE OR REPLACE PROCEDURE t
AS
BEGIN
    DECLAREE
        out_msg VARCHAR(100) := '1';
    BEGIN
        DBMS_OUTPUT.put_line('inner block ' || out_msg || ' ran.');
    END;
END;

CREATE OR REPLACE PROCEDURE t
AS
BEGIN
    DECLARE
        out_msg VARCHAR(100) := '1';
    BEGINS
        DBMS_OUTPUT.put_line('inner block ' || out_msg || ' ran.');
    END;
END;

CREATE OR REPLACE PROCEDURE t
AS
BEGIN
    DECLARE
        out_msg VARCHAR(100) := '1';
    BEGIN
        DBMS_OUTPUT.put_line('inner block ' || out_msg || ' ran.');
    ENDS;
END;
end;



CREATE OR REPLACE PROCEDURE t
AS
BEGIN
    DECLARE
        out_msg VARCHAR(100) := '1';
        invalid_input EXCEPTIONS;
    BEGIN
        DBMS_OUTPUT.put_line('inner block ' || out_msg || ' ran.');
        EXCEPTION
            WHEN invalid_input THEN
                put_line('invalid input: ' || out_msg);
                RAISE;      -- 현재 처리 중인 invalid_input을 다시 일으킴
            WHEN OTHERS THEN
                put_line('unknown exception');
                RAISE;      -- 현재 처리 중인 Exception을 다시 일으킴
    END;
END;


CREATE OR REPLACE PROCEDURE t
AS
BEGIN
    DECLARE
        out_msg VARCHAR(100) := '1';
        invalid_input EXCEPTION;
    BEGIN
        DBMS_OUTPUT.put_line('inner block ' || out_msg || ' ran.');
        EXCEPTIONS
            WHEN invalid_input THEN
                put_line('invalid input: ' || out_msg);
                RAISE;      -- 현재 처리 중인 invalid_input을 다시 일으킴
            WHEN OTHERS THEN
                put_line('unknown exception');
                RAISE;      -- 현재 처리 중인 Exception을 다시 일으킴
    END;
END;

CREATE OR REPLACE PROCEDURE t
AS
BEGIN
    DECLARE
        out_msg VARCHAR(100) := '1';
        invalid_input EXCEPTION;
    BEGIN
        DBMS_OUTPUT.put_line('inner block ' || out_msg || ' ran.');
        EXCEPTION
            WHENS invalid_input THEN
                put_line('invalid input: ' || out_msg);
                RAISE;      -- 현재 처리 중인 invalid_input을 다시 일으킴
            WHEN OTHERS THEN
                put_line('unknown exception');
                RAISE;      -- 현재 처리 중인 Exception을 다시 일으킴
    END;
END;

CREATE OR REPLACE PROCEDURE t
AS
BEGIN
    DECLARE
        out_msg VARCHAR(100) := '1';
        invalid_input EXCEPTION;
    BEGIN
        DBMS_OUTPUT.put_line('inner block ' || out_msg || ' ran.');
        EXCEPTION
            WHEN invalid_input THENS
                put_line('invalid input: ' || out_msg);
                RAISE;      -- 현재 처리 중인 invalid_input을 다시 일으킴
            WHEN OTHERS THEN
                put_line('unknown exception');
                RAISE;      -- 현재 처리 중인 Exception을 다시 일으킴
    END;
END;

CREATE OR REPLACE PROCEDURE t
AS
BEGIN
    DECLARE
        out_msg VARCHAR(100) := '1';
        invalid_input EXCEPTION;
    BEGIN
        DBMS_OUTPUT.put_line('inner block ' || out_msg || ' ran.');
        EXCEPTION
            WHEN invalid_input THEN
                put_line('invalid input: ' || out_msg);
                RAISE;      -- 현재 처리 중인 invalid_input을 다시 일으킴
            WHEN OTHERSE THEN
                put_line('unknown exception');
                RAISE;      -- 현재 처리 중인 Exception을 다시 일으킴
    END;
END;

CREATE OR REPLACE PROCEDURE t
AS
BEGIN
    DECLARE
        out_msg VARCHAR(100) := '1';
        invalid_input EXCEPTION;
    BEGIN
        DBMS_OUTPUT.put_line('inner block ' || out_msg || ' ran.');
        EXCEPTION
            WHEN invalid_input THEN
                put_line('invalid input: ' || out_msg);
                RAISE;      -- 현재 처리 중인 invalid_input을 다시 일으킴
            WHEN OTHERS THEN
                put_line('unknown exception');
                RAISES;      -- 현재 처리 중인 Exception을 다시 일으킴
    END;
END;
   


--+ server-message off
