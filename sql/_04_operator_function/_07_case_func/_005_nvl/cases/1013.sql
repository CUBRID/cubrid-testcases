--test nvl, nvl2 with time type
select nvl(null, time'2:2:2 am') from db_root;
select nvl2(null, time'2:2:2 am', time'2:3:2 am') from db_root;

select nvl(time'2:2:2 am', time'2:2:2 am') from db_root;
select nvl2(time'2:2:2 am', time'2:2:2 am', time'2:3:2 am') from db_root;

select nvl('2:2:2 am', time'2:2:2 am') from db_root;
select nvl2('2:2:2 am', time'2:2:2 am', time'2:3:2 am') from db_root;
