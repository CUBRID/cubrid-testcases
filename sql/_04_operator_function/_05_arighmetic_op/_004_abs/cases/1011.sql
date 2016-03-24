--[er]test abs function with time type as its operand
select abs(time'8:8:8 am') from db_root order by 1;