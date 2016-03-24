--[er]tests add_months function using date type as its second operand
select add_months(date'1/1/2222', date'1/1/2001') from db_root order by 1;