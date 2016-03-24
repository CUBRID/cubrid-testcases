--[er]test nvl, nvl2 with nchar and other type
select nvl('sss', n'ok') from db_root;
select nvl2('sss', n'ok1', n'ok2') from db_root;

select nvl(10, n'ok') from db_root;
select nvl2(10, n'ok1', n'ok2') from db_root;

select nvl(10.22, n'ok') from db_root;
select nvl2(10.23, n'ok1', n'ok2') from db_root;

select nvl({1,2}, n'ok') from db_root;
select nvl2({1,2}, n'ok1', n'ok2') from db_root;

select nvl(date'2/2/2002', n'ok') from db_root;
select nvl2(date'2/2/2002', n'ok1', n'ok2') from db_root;

select nvl(time'3:3:3 am', n'ok') from db_root;
select nvl2(time'3:3:3 am', n'ok1', n'ok2') from db_root;

select nvl(timestamp'2/2/2001 2:2:2 am', n'ok') from db_root;
select nvl2(timestamp'2/2/2001 2:2:2 am', n'ok1', n'ok2') from db_root;
