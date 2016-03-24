--test nvl, nvl2 with nchar type
select nvl(null, n'ok') from db_root;
select nvl2(null, n'ok1', n'ok2') from db_root;

select nvl(n'sss', n'ok') from db_root;
select nvl2(n'sss', n'ok1', n'ok2') from db_root;
