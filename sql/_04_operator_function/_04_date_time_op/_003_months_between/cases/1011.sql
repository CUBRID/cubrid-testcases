--[er]tests months_between function using char type as its operands

select months_between(date'10/10/2000', 'aaa') from db_root;
select months_between('aaa', date'11/10/2000') from db_root;
select months_between('aaa', 'aaa') from db_root;
