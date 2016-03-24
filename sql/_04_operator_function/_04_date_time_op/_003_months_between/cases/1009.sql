--[er]tests months_between function using int type as its operands
select months_between(date'10/10/2000', 1) from db_root;
select months_between(1, date'11/10/2000') from db_root;
select months_between(1, 1) from db_root;
