--[er]test sign function using timestamp type as its operand 
select sign(timestamp'7/7/2007 4:20:3 am') from db_root order by 1;