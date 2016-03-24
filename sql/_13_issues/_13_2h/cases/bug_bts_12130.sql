--[I18N] The result of to_char() function is incorrect when selecting with host variables.
--db: iso88591   cient: iso88591_bin

--+ holdcas on;

set names utf8 collate utf8_ko_cs;
prepare st from 'select to_char(?)';
execute st using 'a';
deallocate prepare st;

set names utf8; 
prepare st from 'select to_char(?)';
execute st using 'a';
deallocate prepare st;

set names iso88591;
prepare st from 'select to_char(?)';
execute st using 'a';
deallocate prepare st;

set names euckr;
prepare st from 'select to_char(?)';
execute st using 'a';
deallocate prepare st;

set names utf8 collate utf8_gen; 
prepare st from 'select to_char(?)';
execute st using 'a';
deallocate prepare st;

set names utf8 collate utf8_ja_exp;
prepare st from 'select to_char(?)';
execute st using 'a';
deallocate prepare st;

set names iso88591;

--+ holdcas off;
