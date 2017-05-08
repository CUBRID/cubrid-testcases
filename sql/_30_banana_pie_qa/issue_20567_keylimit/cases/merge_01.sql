--bug:CBRD-21255
drop if exists source_table,target_table;
-- source_table
CREATE TABLE source_table (a INT, b INT, c INT);
INSERT INTO source_table VALUES (1, 1, 1);
INSERT INTO source_table VALUES (1, 3, 2);
INSERT INTO source_table VALUES (2, 4, 5);
INSERT INTO source_table VALUES (3, 1, 3);

-- target_table
CREATE TABLE target_table (a INT, b INT, c INT);
INSERT INTO target_table VALUES (1, 1, 4);
INSERT INTO target_table VALUES (1, 2, 5);
INSERT INTO target_table VALUES (1, 3, 2);
INSERT INTO target_table VALUES (3, 1, 6);
INSERT INTO target_table VALUES (5, 5, 2);
MERGE INTO target_table tt USING source_table st
ON (st.a=tt.a AND st.b=tt.b)
WHEN MATCHED THEN UPDATE SET tt.c=st.c
     DELETE WHERE tt.c in (select st.a from source_table st limit 0,5)
WHEN NOT MATCHED THEN INSERT VALUES (st.a, st.b, st.c);

select * from target_table order by 1,2,3;

--below error
MERGE INTO target_table tt USING source_table st
ON (st.a=tt.a AND st.b=tt.b)
WHEN MATCHED THEN UPDATE SET tt.c=st.c
     DELETE WHERE tt.c in (select st.a from source_table st order by 1 limit 0,0+1)
WHEN NOT MATCHED THEN INSERT VALUES (st.a, st.b, st.c);
select * from target_table order by 1,2,3;

drop if exists target_table;
CREATE TABLE target_table (a INT, b INT, c INT);
INSERT INTO target_table VALUES (1, 1, 4);
INSERT INTO target_table VALUES (1, 2, 5);
INSERT INTO target_table VALUES (1, 3, 2);
INSERT INTO target_table VALUES (3, 1, 6);
INSERT INTO target_table VALUES (5, 5, 2);
MERGE INTO target_table tt USING source_table st
ON (st.a=tt.a AND st.b=tt.b)
WHEN MATCHED THEN UPDATE SET tt.c=st.c
     DELETE WHERE tt.c in (select st.a from source_table st limit 0,5)
WHEN NOT MATCHED THEN INSERT VALUES (st.a, st.b, st.c);

select * from target_table order by 1,2,3;

MERGE INTO target_table tt USING source_table st
ON (st.a=tt.a AND st.b=tt.b)
WHEN MATCHED THEN UPDATE SET tt.c=st.c
     DELETE WHERE tt.c in (select st.a from source_table st limit 0,0+1)
WHEN NOT MATCHED THEN INSERT VALUES (st.a, st.b, st.c);
select * from target_table order by 1,2,3;

drop if exists target_table;
CREATE TABLE target_table (a INT, b INT, c INT);
INSERT INTO target_table VALUES (1, 1, 4);
INSERT INTO target_table VALUES (1, 2, 5);
INSERT INTO target_table VALUES (1, 3, 2);
INSERT INTO target_table VALUES (3, 1, 6);
INSERT INTO target_table VALUES (5, 5, 2);
MERGE INTO target_table tt USING source_table st
ON (st.a=tt.a AND st.b=tt.b)
WHEN MATCHED THEN UPDATE SET tt.c=st.c
     DELETE WHERE tt.c in (select st.a from source_table st limit 0,5)
WHEN NOT MATCHED THEN INSERT VALUES (st.a, st.b, st.c);

select * from target_table order by 1,2,3;

MERGE INTO target_table tt USING source_table st
ON (st.a=tt.a AND st.b=tt.b)
WHEN MATCHED THEN UPDATE SET tt.c=st.c
     DELETE WHERE tt.c in (select st.a from source_table st limit 0,1)
WHEN NOT MATCHED THEN INSERT VALUES (st.a, st.b, st.c);
select * from target_table order by 1,2,3;

drop if exists target_table;
CREATE TABLE target_table (a INT, b INT, c INT);
INSERT INTO target_table VALUES (1, 1, 4);
INSERT INTO target_table VALUES (1, 2, 5);
INSERT INTO target_table VALUES (1, 3, 2);
INSERT INTO target_table VALUES (3, 1, 6);
INSERT INTO target_table VALUES (5, 5, 2);
MERGE INTO target_table tt USING source_table st
ON (st.a=tt.a AND st.b=tt.b)
WHEN MATCHED THEN UPDATE SET tt.c=st.c
     DELETE WHERE tt.c in (select st.a from source_table st limit 0,5)
WHEN NOT MATCHED THEN INSERT VALUES (st.a, st.b, st.c);

select * from target_table order by 1,2,3;

MERGE INTO target_table tt USING source_table st
ON (st.a=tt.a AND st.b=tt.b)
WHEN MATCHED THEN UPDATE SET tt.c=st.c
     DELETE WHERE tt.c in (select st.a from source_table st limit 1)
WHEN NOT MATCHED THEN INSERT VALUES (st.a, st.b, st.c);
select * from target_table order by 1,2,3;

drop if exists source_table,target_table;
-- source_table
CREATE TABLE source_table (a INT, b INT, c INT);
INSERT INTO source_table VALUES (1, 1, 1);
INSERT INTO source_table VALUES (1, 3, 2);
INSERT INTO source_table VALUES (2, 4, 5);
INSERT INTO source_table VALUES (3, 1, 3);

-- target_table
CREATE TABLE target_table (a INT, b INT, c INT);
INSERT INTO target_table VALUES (1, 1, 4);
INSERT INTO target_table VALUES (1, 2, 5);
INSERT INTO target_table VALUES (1, 3, 2);
INSERT INTO target_table VALUES (3, 1, 6);
INSERT INTO target_table VALUES (5, 5, 2);
MERGE INTO target_table tt USING source_table st
ON (st.a=tt.a AND st.b=tt.b)
WHEN MATCHED THEN UPDATE SET tt.c=st.c
     DELETE WHERE tt.c in (select st.a from source_table st limit 0,2+3)
WHEN NOT MATCHED THEN INSERT VALUES (st.a, st.b, st.c);

-- the result of above query
SELECT * FROM target_table order by 1;
drop if exists source_table,target_table;
