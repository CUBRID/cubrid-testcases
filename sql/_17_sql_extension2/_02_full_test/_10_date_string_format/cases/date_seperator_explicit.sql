--test sepokators in date format with explicit conversion



select cast('2010-11-10' as date);

select cast('11/10/2010' as date);

--[ok]
select cast('2010|11|10' as date);
--[er]
select cast('11|10|2010' as date);
--[ok]
select cast('2010@11@10' as date);
--[er]
select cast('11@10@2010' as date);
--[ok]
select cast('2010\11\10' as date);
--[er]
select cast('11\10\2010' as date);
--[ok]
select cast('2010:11:10' as date);
--[er]
select cast('11+10+2010' as date);
