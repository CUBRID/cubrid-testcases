create table foo(a int, b int, c int);
create index i on foo(a,b desc, c);
insert into foo values(1,10,100);
insert into foo values(1,11,100);

select a,b from foo where a=1 and ((b=10 and c<100) or b>10);

prepare stmt from 'select a,b from foo where a=1 and ((b=? and c<?) or b>?)';
execute stmt using 10,100,10;


select * from foo where a>1 or ((b=10 and c<100) or b>10);

prepare stmt from 'select * from foo where a>? or ((b=? and c<?) or b>?)';
execute stmt using 1,10,100,10;
deallocate prepare stmt;


drop table foo;
