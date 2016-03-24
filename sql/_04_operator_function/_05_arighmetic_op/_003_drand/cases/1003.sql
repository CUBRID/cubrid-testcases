--test drandom function with bit type and operators /,*,+,-
select drandom()/b'000100' from db_root;
select drandom()*b'000100' from db_root;
select drandom()+b'000100' from db_root;
select drandom()-b'000100' from db_root;
