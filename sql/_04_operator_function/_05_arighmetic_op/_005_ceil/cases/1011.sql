--[er]test ceil function with time type as its operand
select ceil(time'8:8:8 am') from db_root order by 1;