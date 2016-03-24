--test random function with bit type and operators /,*,+,-
select random()/b'000100' from db_root;
select random()*b'000100' from db_root;
select random()+b'000100' from db_root;
select random()-b'000100' from db_root;
