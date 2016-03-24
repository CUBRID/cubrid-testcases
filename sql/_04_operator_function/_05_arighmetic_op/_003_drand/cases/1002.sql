--[er]test functions drandom with int type as its operand 
--select drandom(222) from db_root order by 1;
select substr(to_char(drandom(222)), 0, 11) from db_root order by 1;
