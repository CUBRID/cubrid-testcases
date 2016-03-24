--[er]test to_time function with a invalid format value 
select to_time('10/00/00 am') from db_root order by 1;