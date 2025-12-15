-- Verification for CBRD-25842 : partition-key function crash (TZ_OFFSET, RAND)
-- 
-- Description:
-- When the following functions are used in a partition key expression, a segmentation fault occurs when inserting into the table:
-- TZ_OFFSET
-- RAND

-- This test verifies that all such cases now execute safely without crashes.

drop table if exists TZ_OFFSET_TBL, RAND_TBL, FUNC_EXPR_TBL, RAND_ABS_TBL;
drop table if exists CURTIME_TBL;
drop table if exists CURRENT_TIMESTAMP_TBL;
drop table if exists SYS_TIME_TBL;
drop table if exists SYS_TIMESTAMP_TBL;
drop table if exists UTC_DATE_TBL;
drop table if exists UTC_TIME_TBL;
drop table if exists WEEKDAY_TBL;

-- Partitioned by TZ_OFFSET function
create table TZ_OFFSET_TBL(col1 varchar)
partition by list (TZ_OFFSET(col1)) (
  partition p1 values in ('+09:00'),
  partition p2 values in (NULL)
);

-- Partitioned by RAND function
create table RAND_TBL(col1 int)
partition by hash (RAND(col1)) partitions 10;

--==============================
--  INSERT TESTS
--==============================

evaluate 'Case 1: INSERT with TZ_OFFSET(col1)';
insert into TZ_OFFSET_TBL values('Asia/Seoul');
insert into TZ_OFFSET_TBL values(NULL);

evaluate 'Case 2: INSERT with RAND(col1)';
insert into RAND_TBL values(456);
insert into RAND_TBL values(NULL);

--==============================
--  UPDATE TESTS
--==============================

evaluate 'Case 3: UPDATE with TZ_OFFSET in partition key';
update TZ_OFFSET_TBL set col1 = 'Asia/Tokyo' where col1 = 'Asia/Seoul';

evaluate 'Case 4: UPDATE with RAND in partition key';
update RAND_TBL set col1 = 123 where col1 is null;

--==============================
--  SELECT / DELETE TESTS
--==============================

evaluate 'Case 5: SELECT using TZ_OFFSET partition pruning';
select * from TZ_OFFSET_TBL order by 1;

evaluate 'Case 6: DELETE using TZ_OFFSET partition pruning';
delete from TZ_OFFSET_TBL where col1 = 'Asia/Tokyo';

evaluate 'Case 7: SELECT using RAND partition pruning';
select * from RAND_TBL order by 1;

evaluate 'Case 8: DELETE using RAND partition pruning';
delete from RAND_TBL where col1 = 123;

--==============================
--  FUNCTIONAL EXPRESSION TEST
--==============================

evaluate 'Case 9: Nested function SUBSTR + TZ_OFFSET in partition key';
create table FUNC_EXPR_TBL(col1 varchar)
partition by list (SUBSTR(TZ_OFFSET(col1), 1, 3)) (
  partition p1 values in ('+09'),
  partition p2 values in (NULL)
);
insert into FUNC_EXPR_TBL values('Asia/Seoul'), (NULL);

evaluate 'Case 10: Nested function RAND + ABS in partition key';
create table RAND_ABS_TBL(col1 int)
partition by hash (ABS(RAND(col1))) partitions 3;
insert into RAND_ABS_TBL values (1), (NULL);

evaluate 'Case 11: CURTIME, CURRENT_TIME';
CREATE TABLE CURTIME_TBL (
    col1 TIME
)
PARTITION BY HASH (
    TIME_TO_SEC(col1)
  + TIME_TO_SEC(CURTIME())        -- CURTIME()
  + TIME_TO_SEC(CURRENT_TIME())   -- CURRENT_TIME()
)
PARTITIONS 10;

INSERT INTO CURTIME_TBL VALUES (TIME '12:34:56');
INSERT INTO CURTIME_TBL VALUES (NULL);

evaluate 'Case 12: CURRENT_TIMESTAMP, LOCALTIME, LOCALTIMESTAMP';
CREATE TABLE CURRENT_TIMESTAMP_TBL (
    col1 TIMESTAMP
)
PARTITION BY HASH (
      CAST(UNIX_TIMESTAMP(col1) AS BIGINT)
    + CAST(UNIX_TIMESTAMP(CURRENT_TIMESTAMP) AS BIGINT)
    + CAST(UNIX_TIMESTAMP(LOCALTIME) AS BIGINT)
    + CAST(UNIX_TIMESTAMP(LOCALTIMESTAMP) AS BIGINT)
)
PARTITIONS 10;

INSERT INTO CURRENT_TIMESTAMP_TBL VALUES (TIMESTAMP '2020-01-01 12:34:56');
INSERT INTO CURRENT_TIMESTAMP_TBL VALUES (NULL);

evaluate 'Case 13: SYS_TIME, SYSTIME';
CREATE TABLE SYS_TIME_TBL (
    col1 TIME
)
PARTITION BY HASH (
    TIME_TO_SEC(col1)
  + TIME_TO_SEC(SYS_TIME)
  + TIME_TO_SEC(SYSTIME)
)
PARTITIONS 10;

INSERT INTO SYS_TIME_TBL VALUES (TIME '23:00:00');
INSERT INTO SYS_TIME_TBL VALUES (NULL);

evaluate 'Case 14: SYS_TIMESTAMP, SYSTIMESTAMP';
CREATE TABLE SYS_TIMESTAMP_TBL (
    col1 TIMESTAMP
)
PARTITION BY HASH (
      CAST(UNIX_TIMESTAMP(col1) AS BIGINT)
    + CAST(UNIX_TIMESTAMP(SYS_TIMESTAMP) AS BIGINT)
    + CAST(UNIX_TIMESTAMP(SYSTIMESTAMP) AS BIGINT)
)
PARTITIONS 10;

INSERT INTO SYS_TIMESTAMP_TBL VALUES (TIMESTAMP '2016-02-05 16:34:16');
INSERT INTO SYS_TIMESTAMP_TBL VALUES (NULL);

evaluate 'Case 15: UTC_DATE()';
CREATE TABLE UTC_DATE_TBL (
    col1 INT
)
PARTITION BY HASH (
    col1 + TO_DAYS(UTC_DATE())
)
PARTITIONS 10;

INSERT INTO UTC_DATE_TBL VALUES (1);
INSERT INTO UTC_DATE_TBL VALUES (NULL);

evaluate 'Case 16: UTC_TIME()';
CREATE TABLE UTC_TIME_TBL (
    col1 INT
)
PARTITION BY HASH (
    col1 + LENGTH(UTC_TIME())
)
PARTITIONS 10;

INSERT INTO UTC_TIME_TBL VALUES (1);
INSERT INTO UTC_TIME_TBL VALUES (NULL);

evaluate 'Case 17: WEEKDAY(date)';
CREATE TABLE WEEKDAY_TBL (
    col1 DATE
)
PARTITION BY HASH (WEEKDAY(col1))
PARTITIONS 10;

INSERT INTO WEEKDAY_TBL VALUES (DATE '2010-09-09');
INSERT INTO WEEKDAY_TBL VALUES (NULL);

drop table if exists TZ_OFFSET_TBL, RAND_TBL, FUNC_EXPR_TBL, RAND_ABS_TBL;
drop table if exists CURTIME_TBL;
drop table if exists CURRENT_TIMESTAMP_TBL;
drop table if exists SYS_TIME_TBL;
drop table if exists SYS_TIMESTAMP_TBL;
drop table if exists UTC_DATE_TBL;
drop table if exists UTC_TIME_TBL;
drop table if exists WEEKDAY_TBL;
