--[er]tests add_months function using timestamp type as its second operand
select add_months(date'1/1/2222', timestamp'8/8/2008 1:1:1 am') from db_root;
select add_months(timestamp'8/8/2008 1:1:1 am', 12) from db_root order by 1;