-- TEST CASE For:
-- [CBRD-20975]
--   Truncate a TABLE whose name is belongs to the
--   reserved words of the CUBRID,
--   such as 'create', 'convert'

DROP TABLE IF EXISTS [convert];

-- 1. CREATE a TABLE named 'convert' which is a reserved word
--    of the CUBRID
create table [convert] ( col_id varchar(100), col1 varchar(100) );

-- 2. Insert 2 rows into it
insert into [convert] values ( 'abc', '12345' );
insert into [convert] values ( 'abc', '12345' );
select count (*) from [convert] ;

-- 3. Truncate table [convert]
truncate table [convert];

-- 4. count number of rows from [truncate]
--    after truncate
select count (*) from [convert] ;

drop [convert];

