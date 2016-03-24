--[er]tests add_months using char type as its operands
select add_months(date'1/1/2222','abc') from db_root;
select add_months('abc',10) from db_root;
select add_months('abc','abc') from db_root order by 1;