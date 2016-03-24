--[er]test instr function with time type as parameter
select instr(to_time('8:8:8 am'), '') from db_root order by 1;