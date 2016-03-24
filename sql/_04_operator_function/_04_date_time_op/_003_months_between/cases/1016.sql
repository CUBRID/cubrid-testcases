--[er]tests months_between function using timestamp type as its operands

select months_between(date'11/10/2000', timestamp'8/8/2008 8:8:8 am') from db_root;
select months_between(timestamp'8/8/2008 8:8:8 am', date'11/10/2000') from db_root;
select months_between(timestamp'8/8/2008 8:8:8 am', timestamp'8/8/2008 8:8:8 am') from db_root;
