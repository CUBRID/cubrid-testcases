create table foo3 ( a varchar(10), b varchar(10)); 
insert into foo3 values ( 'a','b');

prepare stmt1 from 'select a, b from foo3 union all select ? as a , ? as b from db_root';
execute stmt1 using 'aaaa','bbbb';
deallocate prepare stmt1;

prepare stmt1 from 'select ? as a , ? as b from db_root';
execute stmt1 using 'aaaa','bbbb';
deallocate prepare stmt1;

prepare stmt1 from 'select a, b from foo3 union select ? as a , ? as b from db_root';
execute stmt1 using 'aaaa','bbbb';
deallocate prepare stmt1;


create table tint(i int, j int);
insert into tint values(1,2);
prepare stmt1 from 'select i, j from tint union all select ? as i , ? as j from db_root';
execute stmt1 using 1,2;
deallocate prepare stmt1;

prepare stmt1 from 'select i, j from tint union select ? as i , ? as j from db_root';
execute stmt1 using 1,2;
deallocate prepare stmt1;


prepare stmt1 from 'select ? as i , ? as j from db_root';
execute stmt1 using 1,2;
deallocate prepare stmt1;

drop table tint;
drop table foo3;
