create table x (a set(int));
insert into x values({1,2});
prepare s from 'select a + ? from x'; execute s using 1;
deallocate prepare s;
drop table x;
