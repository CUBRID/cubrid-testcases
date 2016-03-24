--[er]test substring with timestamp type
select substring(to_timestamp('5/5/2005 8:8:8 am') from 3) from db_root order by 1;