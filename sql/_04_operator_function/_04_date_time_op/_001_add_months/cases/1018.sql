--[er]tests add_months function using numeric type as its second operand
select add_months(10, 10) from db_root;
select add_months(10.10, 10) from db_root;
