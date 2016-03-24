--[er]tests months_between function using set type as its operands

select months_between(date'11/10/2000', {1,2}) from db_root;
select months_between({1,2}, date'11/10/2000') from db_root;
select months_between({1,2}, {1,2}) from db_root;
