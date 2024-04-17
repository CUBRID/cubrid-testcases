--+ server-message on

-- PRAGMA AUTONOMOUS_TRANSACTION Test when writing location is wrong

CREATE PROCEDURE insert_athlete(
    a_name VARCHAR,
    a_gender VARCHAR,
    a_nation_code VARCHAR,
    a_event VARCHAR)
AS
BEGIN
    PRAGMA AUTONOMOUS_TRANSACTION;
    
    INSERT INTO athlete (name, gender, nation_code, event)
        VALUES (a_name, a_gender, a_nation_code, a_event);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN ROLLBACK;
END;

CREATE PROCEDURE insert_athlete(
    a_name VARCHAR,
    a_gender VARCHAR,
    a_nation_code VARCHAR,
    a_event VARCHAR)
AS
BEGIN
    
    INSERT INTO athlete (name, gender, nation_code, event)
        VALUES (a_name, a_gender, a_nation_code, a_event);
    COMMIT;
EXCEPTION
    PRAGMA AUTONOMOUS_TRANSACTION;
    WHEN OTHERS THEN ROLLBACK;
END;


--+ server-message off
