--[er]test nvl, nvl2 with char and other type
select nvl(n'sss', 'ok') from db_root;
select nvl2(n'sss', 'ok1', 'ok2') from db_root;

select nvl(10, 'ok') from db_root;
select nvl2(10, 'ok1', 'ok2') from db_root;

select nvl(10.22, 'ok') from db_root;
select nvl2(10.23, 'ok1', 'ok2') from db_root;

select nvl({1,2}, 'ok') from db_root;
select nvl2({1,2}, 'ok1', 'ok2') from db_root;

select nvl(date'2/2/2002', 'ok') from db_root;
select nvl2(date'2/2/2002', 'ok1', 'ok2') from db_root;

select nvl(time'3:3:3 am', 'ok') from db_root;
select nvl2(time'3:3:3 am', 'ok1', 'ok2') from db_root;

select nvl(timestamp'2/2/2001 2:2:2 am', 'ok') from db_root;
select nvl2(timestamp'2/2/2001 2:2:2 am', 'ok1', 'ok2') from db_root;
