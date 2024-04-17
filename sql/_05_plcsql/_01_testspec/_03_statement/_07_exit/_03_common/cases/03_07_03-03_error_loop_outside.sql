--+ server-message on

-- If the EXIT and CONTINUE statements are placed outside the loop statement, check whether a semantic error occurs.

CREATE OR REPLACE PROCEDURE t
AS
BEGIN
    FOR i IN 1 .. 9 LOOP
        put_line('i: ' || i );
    END LOOP;
    EXIT WHEN i > 3 ;
END;

CREATE OR REPLACE PROCEDURE t
AS
BEGIN
    FOR i IN 1 .. 9 LOOP
        put_line('i: ' || i );
    END LOOP;
    CONTINUE WHEN i > 3 ;
END;


--+ server-message off
