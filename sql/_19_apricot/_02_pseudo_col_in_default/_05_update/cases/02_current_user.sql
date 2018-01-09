CREATE TABLE tst (i int, s string default current_user);

insert into tst values (1, 'user_string1');

insert into tst values (2, 'user_string2');

insert into tst values (3, 'user_string3');

insert into tst values (4, 'user_string4');

select * from tst order by 1,2;

update tst set s = default where i > 2;

select if (lower(substring_index(s,'@',1)) = lower(substring_index(user(),'@',1)), 'ok', 'nok') from tst where s is not null and i > 2;

update tst set s = default, i = i + 10 where i <= 2;

select if (lower(substring_index(s,'@',1)) = lower(substring_index(user(),'@',1)), 'ok', 'nok') from tst where s is not null and i > 10;

drop table tst;

CREATE TABLE tst (i int, s string default current_user, d double default 10);

insert into tst values (1, 'user_string1', 11);

insert into tst values (2, 'user_string2', 12);

insert into tst values (3, 'user_string3', 13);

insert into tst values (4, 'user_string4', 14);

select * from tst order by 1,2;

update tst set s = default, d = default where i > 2;

select if (lower(substring_index(s,'@',1)) = lower(substring_index(user(),'@',1)) and d = 10, 'ok', 'nok') from tst where s is not null and i > 2;

update tst set s = default, d = default,i = i + 10 where i <= 2;

select if (lower(substring_index(s,'@',1)) = lower(substring_index(user(),'@',1)) and d = 10, 'ok', 'nok') from tst where s is not null and i > 10;

drop table tst;


