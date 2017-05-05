drop if exists st,tt;
-- source_table
CREATE TABLE st (a INT, b INT, c INT);
INSERT INTO st VALUES (1, 1, 1);
INSERT INTO st VALUES (1, 3, 2);
INSERT INTO st VALUES (3, 1, 3);
INSERT INTO st VALUES (2, 4, 5);
-- target_table
CREATE TABLE tt (a INT, b INT, c INT);
INSERT INTO tt VALUES (1, 1, 4);
INSERT INTO tt VALUES (1, 3, 2);
INSERT INTO tt VALUES (3, 1, 6);
INSERT INTO tt VALUES (5, 5, 2);

MERGE INTO tt USING st
ON (st.a=tt.a AND st.b=tt.b)
WHEN MATCHED THEN UPDATE SET tt.c=st.c
     DELETE WHERE tt.c in (select a from st order by 1 limit 0,2)
WHEN NOT MATCHED THEN INSERT VALUES (st.a, st.b, st.c);

select * from tt;

MERGE INTO tt USING st
ON (st.a=tt.a AND st.b=tt.b)
WHEN MATCHED THEN UPDATE SET tt.c=st.c
     DELETE WHERE tt.c in (1,1)
WHEN NOT MATCHED THEN INSERT VALUES (st.a, st.b, st.c);

MERGE INTO tt USING st
ON (st.a=tt.a AND st.b=tt.b)
WHEN MATCHED THEN UPDATE SET tt.c=st.c where tt.a in (select a from st order by 1 desc limit 1)
WHEN NOT MATCHED THEN INSERT VALUES (st.a, st.b, st.c);

drop if exists st,tt;
