--[er]test coalesce function with many operands 
select COALESCE(20, 10, 30, 40, 50, 60, 70, 80) from db_root order by 1;