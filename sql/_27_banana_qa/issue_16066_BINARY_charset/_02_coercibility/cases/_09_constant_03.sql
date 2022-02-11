--+ holdcas on;
set names binary;

-- constant
select 1,collation('8'),coercibility('8'),collation('¥' collate binary),coercibility('¥' collate binary) from db_class where '8' > '¥' collate utf8_ja_exp limit 1;
select 1,collation(('8' > '¥') collate binary),coercibility(('8' > '¥') collate binary) from db_class where ('8' > '¥') collate binary limit 1;
select coercibility(select _binary'a' union select _binary'b');
select coercibility(NULL);
select coercibility('ß' collate utf8_gen),coercibility('가' collate utf8_gen),coercibility('ü');

-- function
select collation(chr(97) collate binary),coercibility(chr(97) collate binary);
select collation(chr(97 using binary)),coercibility(chr(97 using binary));
select collation(lcase('A' collate binary)),coercibility(lcase('A' collate binary));
select collation(mid('ABbD' collate binary,2,2)),coercibility(mid('ABbD' collate binary,2,2));
select coercibility(date('2010-02-27 15:10:23'));

set names iso88591;
commit;
--+ holdcas off;


--+ holdcas off;
