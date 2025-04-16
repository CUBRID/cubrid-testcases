--+ server-message on
-- verified the CBRD-25882

drop table if exists athlete;

CREATE TABLE athlete (
    name varchar(40) NOT NULL,
    gender char(1),
    nation_code char(3),
    event varchar(30)
);

CREATE OR REPLACE PROCEDURE insert_athlete(
    p_name VARCHAR,
    p_gender VARCHAR,
    p_nation_code VARCHAR,
    p_event VARCHAR)
AS
BEGIN
    INSERT INTO athlete (name, gender, nation_code, event)
    VALUES (p_name, p_gender, p_nation_code, p_event);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
END;

call insert_athlete('test', 'M', 'KOR', 'test');
select * from athlete;

drop procedure insert_athlete;
drop table athlete;
--+ server-message off