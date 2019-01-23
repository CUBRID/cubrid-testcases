drop if exists source_table,target_table;
-- source_table
CREATE TABLE source_table (a INT, b INT, c INT,d timestamp on update current_timestamp,e varchar(10));
INSERT INTO source_table(a,b,c) VALUES (1, 1, 1);
INSERT INTO source_table(a,b,c) VALUES (1, 3, 2);
INSERT INTO source_table(a,b,c) VALUES (2, 4, 5);
INSERT INTO source_table(a,b,c) VALUES (3, 1, 3);

-- target_table
CREATE TABLE target_table (a INT, b INT, c INT,d timestamp on update current_timestamp,e varchar(10));
INSERT INTO target_table(a,b,c) VALUES (1, 1, 4);
INSERT INTO target_table(a,b,c) VALUES (1, 2, 5);
INSERT INTO target_table(a,b,c) VALUES (1, 3, 2);
INSERT INTO target_table(a,b,c) VALUES (3, 1, 6);
INSERT INTO target_table(a,b,c) VALUES (5, 5, 2);

MERGE INTO target_table tt USING source_table st
ON (st.a=tt.a AND st.b=tt.b)
WHEN MATCHED THEN UPDATE SET tt.c=st.c,tt.e='updated'
     DELETE WHERE tt.c = 1
WHEN NOT MATCHED THEN INSERT VALUES (st.a, st.b, st.c,null,null);

-- the result of above query
SELECT if(current_timestamp -d >=0 and current_timestamp -d <10,'ok','nok') FROM target_table where e='updated';



drop if exists source_table,target_table;
-- source_table
CREATE TABLE source_table (a INT, b INT, c INT,d datetime on update current_timestamp,e varchar(10));
INSERT INTO source_table(a,b,c) VALUES (1, 1, 1);
INSERT INTO source_table(a,b,c) VALUES (1, 3, 2);
INSERT INTO source_table(a,b,c) VALUES (2, 4, 5);
INSERT INTO source_table(a,b,c) VALUES (3, 1, 3);

-- target_table
CREATE TABLE target_table (a INT, b INT, c INT,d datetime on update current_timestamp,e varchar(10));
INSERT INTO target_table(a,b,c) VALUES (1, 1, 4);
INSERT INTO target_table(a,b,c) VALUES (1, 2, 5);
INSERT INTO target_table(a,b,c) VALUES (1, 3, 2);
INSERT INTO target_table(a,b,c) VALUES (3, 1, 6);
INSERT INTO target_table(a,b,c) VALUES (5, 5, 2);

MERGE INTO target_table tt USING source_table st
ON (st.a=tt.a AND st.b=tt.b)
WHEN MATCHED THEN UPDATE SET tt.c=st.c,tt.e='updated'
     DELETE WHERE tt.c = 1
WHEN NOT MATCHED THEN INSERT VALUES (st.a, st.b, st.c,null,null);

-- the result of above query
SELECT if(current_datetime -d >=0 and current_datetime -d <10000,'ok','nok') FROM target_table where e='updated';
drop if exists source_table,target_table;

