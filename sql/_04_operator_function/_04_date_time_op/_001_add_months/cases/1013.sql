--tests add_months function using decimal as its second operand
select add_months(date'1/1/2222', 10.22) from db_root order by 1;