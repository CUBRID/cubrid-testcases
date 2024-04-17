--+ server-message on

-- PRAGMA AUTONOMOUS_TRANSACTION Test for grammar typos

CREATE PROCEDURE insert_athlete(
    a_name VARCHAR,
    a_gender VARCHAR,
    a_nation_code VARCHAR,
    a_event VARCHAR)
AS
    PRAGMAA AUTONOMOUS_TRANSACTION;
BEGIN
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
    PRAGMA AUTONOMOUS_TRANSACTIONS;
BEGIN
    INSERT INTO athlete (name, gender, nation_code, event)
        VALUES (a_name, a_gender, a_nation_code, a_event);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN ROLLBACK;
END;


--+ server-message off
