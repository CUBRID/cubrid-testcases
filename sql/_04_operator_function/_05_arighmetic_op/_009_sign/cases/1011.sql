--[er]test sign function using time type as its operand 
select sign(time'4:20:3 am') from db_root order by 1;