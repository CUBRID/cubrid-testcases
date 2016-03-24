--[er]test instr function with date type as parameter
select instr(to_date('7/7/2007'), '') from db_root order by 1;