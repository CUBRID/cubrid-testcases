create table abcd (a char(10), b nchar(20), c nchar varying);
insert into abcd values('aaa', n'bbb', n'ccc');

select clob_from_file(a) from abcd;
select clob_from_file(b) from abcd;
select clob_from_file(c) from abcd;

delete from abcd;
drop table abcd;


