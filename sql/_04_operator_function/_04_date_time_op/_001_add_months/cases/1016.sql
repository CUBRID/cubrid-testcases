--[er]tests add_months function using bit type as its second operands
select add_months(date'1/1/2222', b'0001') from db_root;
select add_months(b'0001', 10) from db_root order by 1;