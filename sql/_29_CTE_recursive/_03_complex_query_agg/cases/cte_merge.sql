drop if exists source_table,target_table;
CREATE TABLE source_table (a INT, b INT, c INT);
INSERT INTO source_table VALUES (1, 1, 1);
INSERT INTO source_table VALUES (1, 3, 2);
INSERT INTO source_table VALUES (2, 4, 5);
INSERT INTO source_table VALUES (3, 1, 3);

CREATE TABLE target_table (a INT, b INT, c INT);
INSERT INTO target_table VALUES (1, 1, 4);
INSERT INTO target_table VALUES (1, 2, 5);
INSERT INTO target_table VALUES (1, 3, 2);
INSERT INTO target_table VALUES (3, 1, 6);
INSERT INTO target_table VALUES (5, 5, 2);
MERGE INTO  target_table tt USING (with cte2 as (select x.a,x.b,x.c from source_table x,target_table y where x.a=y.a  ) select distinct * from cte2)  st
ON (st.a=tt.a AND st.b=tt.b)
WHEN MATCHED THEN UPDATE SET tt.c=st.c
     DELETE WHERE tt.c = 1
WHEN NOT MATCHED THEN INSERT VALUES (st.a, st.b, st.c);


SELECT * FROM target_table order by 1, 2;
with cte2 as (select x.a,x.b,x.c from source_table x,target_table y where x.a=y.a  ) select distinct * from cte2 order by 1, 2;
drop if exists source_table,target_table;
