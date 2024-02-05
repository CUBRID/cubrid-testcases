--+ server-message on

-- Check whether errors occur when writing typos in CONTINUES, EXIST and WHEN.

CREATE OR REPLACE PROCEDURE t
AS
BEGIN
    FOR i IN 1 .. 9 LOOP
        EXITs WHEN i>5 ;
    END LOOP;
END;

CREATE OR REPLACE PROCEDURE t
AS
BEGIN
    FOR i IN 1 .. 9 LOOP
        EXIT WHENs i>5 ;
    END LOOP;
END;


CREATE OR REPLACE PROCEDURE t
AS
BEGIN
    FOR i IN 1 .. 9 LOOP
        CONTINUEs WHEN i>5 ;
    END LOOP;
END;

CREATE OR REPLACE PROCEDURE t
AS
BEGIN
    FOR i IN 1 .. 9 LOOP
        CONTINUE WHENs i>5 ;
    END LOOP;
END;


--+ server-message off
