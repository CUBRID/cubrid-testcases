--[er]test substring with date type
select substring(to_date('5/5/2005') from 3) from db_root order by 1;