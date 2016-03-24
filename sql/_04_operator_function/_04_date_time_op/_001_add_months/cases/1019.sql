--[er]tests add_months function using set type as its second operand
select add_months({1,2}, 10) from db_root;
select add_months(date'8/8/2008', {1,2}) from db_root;
select add_months({1,2}, {1,2}) from db_root order by 1;