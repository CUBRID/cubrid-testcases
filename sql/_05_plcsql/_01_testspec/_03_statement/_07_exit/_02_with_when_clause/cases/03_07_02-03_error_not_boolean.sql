--+ server-message on

-- In the WHEN clause, check if an error occurs if it is not a boolean type.

CREATE OR REPLACE PROCEDURE t
AS
BEGIN
    FOR i IN 1 .. 9 LOOP
        EXIT WHEN i := 3 ;
    END LOOP;
END;

CREATE OR REPLACE PROCEDURE t
AS
BEGIN
    FOR i IN 1 .. 9 LOOP
        EXIT WHEN i >> 3 ;
    END LOOP;
END;

CREATE OR REPLACE PROCEDURE t
AS
BEGIN
    FOR i IN 1 .. 9 LOOP
        EXIT WHEN i << 3 ;
    END LOOP;
END;


CREATE OR REPLACE PROCEDURE t
AS
BEGIN
    FOR i IN 1 .. 9 LOOP
        EXIT WHEN !i ;
    END LOOP;
END;


--+ server-message off
