--+ holdcas on;

set names utf8;
drop table if exists test_to_char;
drop table if exists test_to_char_f;
create table test_to_char(
        n1 numeric(10,5),
        n2 numeric(10,5),
        n3 numeric(10,5)
);
create table test_to_char_f(
        c1 varchar(10)
);
insert into test_to_char (n1,n2,n3) values (123,296,999);
insert into test_to_char_f (c1) values ('9');
select cast(n1 as varchar)+'  '+c1+' 
                '+to_char(n1,c1) from test_to_char_f,test_to_char; 
select cast(n1 as varchar)+'        '+c1+to_char(n1,c1) from test_to_char_f,test_to_char; 
select hex(cast(chr(0) as string charset iso88591));
select hex(cast(chr(1) as string charset iso88591));
select hex(cast(chr(2) as string charset iso88591));
select hex(cast(chr(3) as string charset iso88591));
select hex(cast(chr(4) as string charset iso88591));
select hex(cast(chr(5) as string charset iso88591));
select hex(cast(chr(6) as string charset iso88591));
select hex(cast(chr(7) as string charset iso88591));
select hex(cast(chr(8) as string charset iso88591));
select hex(cast(chr(9) as string charset iso88591));
select hex(cast(chr(10) as string charset iso88591));
select hex(cast(chr(11) as string charset iso88591));
select hex(cast(chr(12) as string charset iso88591));
select hex(cast(chr(13) as string charset iso88591));
select hex(cast(chr(14) as string charset iso88591));
select hex(cast(chr(15) as string charset iso88591));
select hex(cast(chr(16) as string charset iso88591));
select hex(cast(chr(17) as string charset iso88591));
select hex(cast(chr(18) as string charset iso88591));
select hex(cast(chr(19) as string charset iso88591));
select hex(cast(chr(20) as string charset iso88591));
select hex(cast(chr(21) as string charset iso88591));
select hex(cast(chr(22) as string charset iso88591));
select hex(cast(chr(23) as string charset iso88591));
select hex(cast(chr(24) as string charset iso88591));
select hex(cast(chr(25) as string charset iso88591));
select hex(cast(chr(26) as string charset iso88591));
select hex(cast(chr(27) as string charset iso88591));
select hex(cast(chr(28) as string charset iso88591));
select hex(cast(chr(29) as string charset iso88591));
select hex(cast(chr(30) as string charset iso88591));
select hex(cast(chr(31) as string charset iso88591));
drop test_to_char;
drop test_to_char_f;

set names iso88591;
commit;
--+ holdcas off;
