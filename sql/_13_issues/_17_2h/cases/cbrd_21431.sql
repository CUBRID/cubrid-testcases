drop table if exists tmp;
create table tmp (a int, b varchar(10), c int);
create index idx1 on tmp(a,b);
insert into tmp values (1, 'abcd', 1), (2, 'abcd', 1), (3, 'abcd', 2), (4, 'efgh', 3);

prepare st from 'select * from tmp where a = ? and b like ?';
execute st using 1, '%bc%';

prepare st from 'select * from tmp where a > ? and b not like ?';
execute st using 1, '%bc%';

prepare st from 'select * from tmp where b like ? and a = ? and c like ?';
execute st using  '%bc%', 1, '%1%';

prepare st from 'select * from tmp where a like ? and c like ? order by a';
execute st using   '%%', '%1%';

alter table tmp drop index idx1;
prepare st from 'select * from tmp where a = ? and b like ?';
execute st using 1, '%bc%';

create index idx2 on tmp(a);
create index idx3 on tmp(b);
prepare st from 'select * from tmp where a = ? and b like ?';
execute st using 1, '%bc%';

alter table tmp drop index idx2;
alter table tmp drop index idx3;
create index idx4 on tmp(a,b,c);
insert into tmp values (5, null, null);

prepare st from 'select * from tmp where b like ? and a = ? and c like ?';
execute st using '%bc%', 1, '%1%';

prepare st from 'select * from tmp where a like ? and c like ? order by a';
execute st using   '%%', '%1';

prepare st from 'select * from tmp where b like ? and c = ? order by a';
execute st using '%bc%' , 1;

prepare st from 'select * from tmp where a <> ? and b not like ? and c is null ';
execute st using 1, '%bc%';

prepare st from 'select * from tmp where a not like ? and c is null ';
execute st using '%1%';

deallocate prepare st;
drop table if exists tmp; 

