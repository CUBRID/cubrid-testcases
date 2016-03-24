--[er]test substring with time type
select substring(to_time('8:8:8 am') from 3) from db_root order by 1;