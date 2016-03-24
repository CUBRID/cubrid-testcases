--[er]test abs function with timestamp type as its operand
select abs(timestamp'8/8/2008 8:8:8 am') from db_root order by 1;