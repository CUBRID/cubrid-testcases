-- Verified for CBRD-25015

--+ server-message on

DROP TABLE IF EXISTS t1;
CREATE TABLE t1 (a INT);
INSERT INTO t1 VALUES (1), (3), (5), (7), (9);

create or replace function a1_u2(k int) return int as
i int := 0;
begin
    for r in (select a from t1 ORDER BY a LIMIT k) loop
        i := i + r.a;
        DBMS_OUTPUT.put_line('v = ' || r.a);
    end loop;
    return i;
end;

SELECT a1_u2(5);

DROP TABLE t1;
drop function a1_u2;

--+ server-message off
