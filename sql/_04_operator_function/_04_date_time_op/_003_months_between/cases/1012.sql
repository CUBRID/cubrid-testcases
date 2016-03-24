--[er]tests months_between function using nchar type as its operands

select months_between(date'10/10/2000', n'aaa') from db_root;
select months_between(n'aaa', date'11/10/2000') from db_root;
select months_between(n'aaa', n'aaa') from db_root;
