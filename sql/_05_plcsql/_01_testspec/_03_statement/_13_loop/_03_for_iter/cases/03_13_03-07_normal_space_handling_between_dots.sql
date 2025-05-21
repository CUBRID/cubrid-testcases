--+ server-message on

-- Verified for CBRD-25830
-- A procedure can be successfully created even if there are no spaces around the range operator (..) in a FOR loop.

--case1: No spaces on both sides
evaluate 'case1';
CREATE OR REPLACE PROCEDURE PROC_FOR_TEST IS 
BEGIN 
    FOR i IN 1..5 LOOP 
        DBMS_OUTPUT.PUT_LINE('Number: ' || i); 
    END LOOP; 
END;
CALL PROC_FOR_TEST();

--case2: No space on the left side
evaluate 'case2';
CREATE OR REPLACE PROCEDURE PROC_FOR_TEST IS
BEGIN
    FOR i IN 1.. 5 LOOP
        DBMS_OUTPUT.PUT_LINE('Number: ' || i);
    END LOOP;
END;
CALL PROC_FOR_TEST();

--case3: No space on the right side
evaluate 'case3';
CREATE OR REPLACE PROCEDURE PROC_FOR_TEST IS
BEGIN
    FOR i IN 1 ..5 LOOP
        DBMS_OUTPUT.PUT_LINE('Number: ' || i);
    END LOOP;
END;
CALL PROC_FOR_TEST();

--case4: Incorrect usage of the range operator with four dots ('....')
evaluate 'case4';
DROP PROCEDURE PROC_FOR_TEST;
CREATE OR REPLACE PROCEDURE PROC_FOR_TEST IS
BEGIN
    FOR i IN 1....5 LOOP
        DBMS_OUTPUT.PUT_LINE('Number: ' || i);
    END LOOP;
END;
CALL PROC_FOR_TEST();

--case5: Incorrect usage of the range operator with three dots ('...')
evaluate 'case5';
CREATE OR REPLACE PROCEDURE PROC_FOR_TEST IS
BEGIN
    FOR i IN 1...5 LOOP
        DBMS_OUTPUT.PUT_LINE('Number: ' || i);
    END LOOP;
END;
CALL PROC_FOR_TEST();
DROP PROCEDURE PROC_FOR_TEST;


--+ server-message off
