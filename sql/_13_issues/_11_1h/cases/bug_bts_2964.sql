--+ holdcas on;
create table foo (id int, name varchar(20));
insert into foo values(1, 'aaa');
prepare s from 'select * from foo where id=?';
 execute s using 1 ;
deallocate prepare s;
--+ holdcas off;
drop table foo;
