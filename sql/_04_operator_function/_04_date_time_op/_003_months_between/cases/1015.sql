--[er]tests months_between function using time type as its operands

select months_between(date'11/10/2000', time'8:8:8 am') from db_root;
select months_between(time'8:8:8 am', date'11/10/2000') from db_root;
select months_between(time'8:8:8 am', time'8:8:8 am') from db_root;
