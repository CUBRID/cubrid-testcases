--+ holdcas on;

set names euckr;
drop table if exists test_to_char_from_number;
create table test_to_char_from_number (
type_char char(500)
) charset euckr;
insert into test_to_char_from_number values ('0000 9999 9,999 9,9,9,9, s999999 s00000 c99999 c00000 sc99999 sc00000 9.9eeee 9.99eeee 0.99eeee 00.9eeee sc0.eeee 999 000 000.0 99.9 ');
select to_char(9999.99,type_char) from test_to_char_from_number;
drop table test_to_char_from_number;

set names iso88591;
commit;
--+ holdcas off;
