--1. insert unmatched types into blob column

create table insert5_tb (a int auto_increment, b blob);

--insert char type into blob column
--error
insert into insert5_tb (b) values ('aaa');

--insert nchar/nchar varying type into blob column
--error
insert into insert5_tb (b) values (x'aaa');

--insert bit/bit varying type into blob column
--error
insert into insert5_tb (b) values (b'0011');

--insert numeric/int/smallint/monetary type into blob column
--error
insert into insert5_tb (b) values (123);

--insert float/double type into blob column
--error
insert into insert5_tb (b) values (123.456);

--insert date type into blob column
--error
insert into insert5_tb (b) values ('1/1/2008');

--insert time type into blob column
--error
insert into insert5_tb (b) values ('1:1:1 pm');

--insert timestamp type into blob column
--error
insert into insert5_tb (b) values ('01/31/1994 8:15:00 pm');

--insert set type into blob column
--error
insert into insert5_tb (b) values ({10, 20});

--insert multiset type into blob column
--error
insert into insert5_tb (b) values ({'abc','def'});

--insert sequence type into blob column
--error
insert into insert5_tb (b) values ({50,60,70});

--insert clob type into blob column
--error
insert into insert5_tb (b) values (to_clob('character'));

delete from insert5_tb;
drop table insert5_tb;



--2. insert unmatched types into clob column

create table insert5_tb (a int auto_increment, b clob);

--insert char type into clob column
--error
insert into insert5_tb (b) values ('aaa');

--insert nchar/nchar varying type into clob column
--error
insert into insert5_tb (b) values (x'aaa');

--insert bit/bit varying type into clob column
--error
insert into insert5_tb (b) values (b'0011');

--insert numeric/int/smallint/monetary type into clob column
--error
insert into insert5_tb (b) values (123);

--insert float/double type into clob column
--error
insert into insert5_tb (b) values (123.456);

--insert date type into clob column
--error
insert into insert5_tb (b) values ('1/1/2008');

--insert time type into clob column
--error
insert into insert5_tb (b) values ('1:1:1 pm');

--insert timestamp type into clob column
--error
insert into insert5_tb (b) values ('01/31/1994 8:15:00 pm');

--insert set type into clob column
--error
insert into insert5_tb (b) values ({10, 20});

--insert multiset type into clob column
--error
insert into insert5_tb (b) values ({'abc','def'});

--insert sequence type into clob column
--error
insert into insert5_tb (b) values ({50,60,70});

--insert blob type into clob column
--error
insert into insert5_tb (b) values (to_blob(x'1001'));

delete from insert5_tb;
drop table insert5_tb;



--3. insert null/empty string/space/nothing into blob/clob column

create table insert5_tb (a int, b blob, c clob);
insert into insert5_tb values(1, null, null);
--error
--insert into insert5_tb values(2, "", "");
--error
--insert into insert5_tb values(3, " ", " ");
--error
insert into insert5_tb values(2, '', '');
--error
insert into insert5_tb values(2, ' ', ' ');
insert into insert5_tb (a) values (4);

select a,blob_to_bit(b),clob_to_char(c) from insert5_tb order by 1, 2, 3;

delete from insert5_tb;
drop table insert5_tb;

