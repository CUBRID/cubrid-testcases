--[er]test floor function with time type as its operand
select floor(time'8:8:8 am') from db_root order by 1;