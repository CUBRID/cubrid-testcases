--+ holdcas on;
set names utf8;
-- validation of UTF-8 streams
create table test_utf8(s1 CHAR(200) collate utf8_tr_cs);

-- Inalid 1 byte sequence
insert into t1 values ('Ÿ');

-- Inalid 2 byte sequence
insert into t1 values ('Âp');

-- Inalid 3 byte sequence
insert into t1 values ('àx');

insert into t1 values ('à 2');

insert into t1 values ('á@x');

insert into t1 values ('í€x');

insert into t1 values ('íxx');

-- Inalid 4 byte sequence
insert into t1 values ('ğP ');

insert into t1 values ('ğ€x');

insert into t1 values ('ğxx');

insert into t1 values ('ğxxx');

insert into t1 values ('ñ€€x');

insert into t1 values ('ñ€xx');

insert into t1 values ('ñxxx');

insert into t1 values ('ô€€x');

insert into t1 values ('ô€xx');

insert into t1 values ('ôxxx');
-- Inalid 5 byte sequence
insert into t1 values ('ñ1xxx');

-- Inalid 6 byte sequence
insert into t1 values ('úxxxxx');

drop table test_utf8;
set names iso88591;
commit;
--+ holdcas off;


