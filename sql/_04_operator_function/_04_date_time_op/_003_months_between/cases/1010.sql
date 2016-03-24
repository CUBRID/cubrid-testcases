--[er]tests months_between function using numeric type as its operands

select months_between(date'10/10/2000', 1.111) from db_root;
select months_between(1.111, date'11/10/2000') from db_root;
select months_between(1.11, 1.112) from db_root;
