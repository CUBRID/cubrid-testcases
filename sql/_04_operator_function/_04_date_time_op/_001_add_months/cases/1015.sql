--[er]tests add_months function using nchar type as its operands
select add_months(date'1/1/2222', n'nchar') from db_root;
select add_months(n'nchar', n'nchar') from db_root;
select add_months(n'nchar', 20) from db_root;
