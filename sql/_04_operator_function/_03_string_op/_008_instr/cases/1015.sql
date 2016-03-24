--[er]test instr function with timestamp type as parameter
select instr(to_timestamp('8/8/2008 8:8:8 am'), '') from db_root order by 1;