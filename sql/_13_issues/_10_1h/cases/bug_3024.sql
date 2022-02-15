create table tbisnull (a int);
insert into tbisnull values (null), (0), (1);

select isnull (null), isnull (0), isnull (1); 

prepare s from 'select isnull( ? ), isnull ( ? ), isnull ( ? )';
execute s using null, 0, 1;
deallocate prepare s;

select a, isnull (a) from tbisnull order by 1; 
select a, isnull (a + 1) from tbisnull order by 1; 

select a from tbisnull where isnull (a) <> 1 order by 1; 

drop table tbisnull;
