--+ holdcas on;

drop table if exists t1;

create table t1(i1 int,s1 varchar, s2 char(300));

insert into t1 values(1,repeat('abc',100),repeat('def',100));

select t1 into :a from t1 where i1=1;

select disk_size(:a.s1),disk_size(:a.s2), :a.s1, :a.s2 from t1;

select s1 into b from t1;

select b,length(b),disk_size(b);

select s2 into c from t1;

select c,length(c),disk_size(c);

select @b:=s1, @a := @b+s2 from t1 group by @a having @b>'a' order by 1,2 limit 1;

drop table t1;


set @a=repeat('a',300);

set @b='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';

select length(@a),disk_size(@a),@a;

select length(@b),disk_size(@b),@b;

select @c:=cast(@b as string);

select length(@c),disk_size(@c),@c;


prepare st from 'select ?,disk_size(?)';

set @a=repeat('a',300);

set @b := repeat('abc',100);

execute st using @a,@a;

execute st using @b,@b;

deallocate prepare st;

--+ holdcas off;