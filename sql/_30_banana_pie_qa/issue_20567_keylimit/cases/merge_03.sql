drop if exists st,tt;
-- source_table
CREATE TABLE st (a INT, b INT, c INT);
INSERT INTO st VALUES (1, 1, 1);
INSERT INTO st VALUES (1, 3, 2);
INSERT INTO st VALUES (2, 4, 5);
INSERT INTO st VALUES (3, 1, 3);

-- target_table
CREATE TABLE tt(a INT, b INT, c INT);
INSERT INTO tt VALUES (1, 1, 4);
INSERT INTO tt VALUES (1, 2, 5);
INSERT INTO tt VALUES (1, 3, 2);
INSERT INTO tt VALUES (3, 1, 6);
INSERT INTO tt VALUES (5, 5, 2);
MERGE INTO tt USING st
ON (st.a=tt.a AND st.b=tt.b)
WHEN MATCHED THEN UPDATE SET tt.c=st.c
     DELETE WHERE tt.c in (select a from st limit 0+1)
WHEN NOT MATCHED THEN INSERT VALUES (st.a, st.b, st.c);
select * from tt order by 1;

MERGE INTO tt USING st
ON (st.a=tt.a AND st.b=tt.b)
WHEN MATCHED THEN UPDATE SET tt.c=st.c
     DELETE WHERE tt.c in (select a from st limit 1-1,0+1)
WHEN NOT MATCHED THEN INSERT VALUES (st.a, st.b, st.c);
select * from tt order by 1;
drop if exists st,tt;

