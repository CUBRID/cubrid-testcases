autocommit off;
/* client side calls */
select position('abc' in '123abc134')
from class db_user;
select position('abc' in '')
from class db_user;
select position('' in '123abc134')
from class db_user;
select position('' in '')
from class db_user;
select substring('this is a test' from 6)
from class db_user;
select substring('this is a test' from 6 for 3)
from class db_user;
select substring('1234567' from 4 for 12)
from class db_user;
select substring('' from 4 for 12)
from class db_user;
select octet_length('123456789012')
from class db_user;
select bit_length(b'101011011')
from class db_user;
select char_length('123456789012')
from class db_user;
select lower('THIS IS A TEST')
from class db_user;
select upper('this is a test')
from class db_user;
select trim ('   this is a test    ')
from class db_user;
select trim ('       ')
from class db_user;
select trim (leading from '       ')
from class db_user;
select trim (trailing from '       ')
from class db_user;
select trim (both from '       ')
from class db_user;
select trim (leading from '   this is a test    ')
from class db_user;
select trim (trailing from '   this is a test    ')
from class db_user;
select trim (both from '   this is a test    ')
from class db_user;
select trim (leading '1' from '1111211this is a test11211')
from class db_user;
select trim (trailing '1' from '1111211this is a test11211')
from class db_user;
select trim (both '1' from '1111211this is a test11211')
from class db_user;
select trim (' ' from '   12e3r908   ') 
from class db_user;
select 'this is a test' + 'foo foo foo' 
from class db_user;
select 'this is a test' + ' '
from class db_user;
select ' ' + 'foo foo foo' 
from class db_user;
select ' ' + ' ' 
from class db_user;
select '' + ''
from class db_user;
select b'' + b''
from class db_user;
select b'101011011'+ x'abc'
from class db_user;
/* server side calls */
create class foo (a string);
create class bar (b string);
create class baz (c int);
insert into foo values ('1111234324311111');
insert into foo values ('123abc134');
insert into foo values ('   this is a test   ');
insert into foo values ('THIS IS A TEST');
insert into foo values ('thIS iS a TEst');
insert into bar values ('1');
insert into bar values ('abc');
insert into baz values (6);
select a, position('abc' in a) from foo;
select a, b, position(b in a) from foo, bar where b = 'abc';
select a, c, substring(a from c) from foo, baz;
select a, c, substring(a from c for c/2) from foo, baz;
select a, octet_length(a) from foo;
select a, bit_length(a) from foo;
select a, char_length(a) from foo;
select a, lower(a) from foo;
select a, upper(a) from foo;
select a, trim (a) from foo;
select a, trim (leading from a) from foo;
select a, trim (trailing from a) from foo;
select a, trim (both from a) from foo;
select a, trim (leading '1' from a) from foo;
select a, trim (trailing '1' from a) from foo;
select a, trim (both '1' from a) from foo;
select a, trim (' ' from a) from foo;
select a, b, trim(leading b from a) from foo, bar where b = '1';
select a, b, trim(trailing b from a) from foo, bar where b = '1';
select a, b, trim(both b from a) from foo, bar where b = '1';
select a, b, a + b from foo, bar;
select a, b, substring(a from position(b in a) for char_length(b) + 2) 
from foo, bar;
rollback;
