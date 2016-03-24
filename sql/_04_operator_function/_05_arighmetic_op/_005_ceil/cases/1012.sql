--[er]test ceil function with timestamp type as its operand
select ceil(timestamp'8/8/2008 8:8:8 am') from db_root order by 1;