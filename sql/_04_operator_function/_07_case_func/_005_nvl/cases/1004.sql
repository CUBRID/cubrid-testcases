--test nvl, nvl2 with char type
select nvl(null, 'ok') from db_root;
select nvl2(null, 'ok1', 'ok2') from db_root;

select nvl('sss', 'ok') from db_root;
select nvl2('sss', 'ok1', 'ok2') from db_root;
