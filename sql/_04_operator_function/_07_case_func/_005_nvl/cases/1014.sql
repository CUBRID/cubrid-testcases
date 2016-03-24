--test nvl, nvl2 with time type
select nvl(null, timestamp'2/2/2002 2:2:2 am') from db_root;
select nvl2(null, timestamp'2/2/2002 2:2:2 am', timestamp'2/2/2002 2:3:2 am') from db_root;

select nvl(timestamp'2/2/2002 2:2:2 am', timestamp'2/2/2002 2:2:2 am') from db_root;
select nvl2(timestamp'2/2/2002 2:2:2 am', timestamp'2/2/2002 2:2:2 am', timestamp'2/2/2002 2:3:2 am') from db_root;

select nvl('2/2/2002 2:2:2 am', timestamp'2/2/2002 2:2:2 am') from db_root;
select nvl2('2/2/2002 2:2:2 am', timestamp'2/2/2002 2:2:2 am', timestamp'2/2/2002 2:3:2 am') from db_root;
