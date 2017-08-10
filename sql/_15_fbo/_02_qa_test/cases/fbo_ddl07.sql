-- need change answer file.
--  R30	Prepared statements
create table ptbl (nr int primary key not null auto_increment, b blob, c clob, str varchar(10) );
insert into ptbl values (null, bit_to_blob(X'10011'),char_to_clob('aaa'),'ABC');
insert into ptbl values (null, bit_to_blob(X'10111'),char_to_clob('bbb'),'BCD');
insert into ptbl values (null, bit_to_blob(X'11011'),char_to_clob('ccc'),'CDE');

prepare stm1 from 'insert into ptbl values (?, bit_to_blob(?),char_to_clob(?),?)'
execute stm1 using null,X'11011','ddd','GGI'
execute stm1 using null,X'11010','eee','HHF'
deallocate prepare stm1;

prepare stm2 from 'select nr,blob_to_bit(b),clob_to_char(c),str from ptbl where nr=? and blob_to_bit(b)=? and clob_to_char(c)=? and str=? order by str'
execute stm2 using 1,X'10011','aaa','ABC'
execute stm2 using 2,X'10111','bbb','BCD'
deallocate prepare stm2;

prepare stm3 from 'update ptbl set b=bit_to_blob(?),c=char_to_clob(?),str=? where nr=?'
execute stm3 using X'11011','ddg','GGG',4
execute stm3 using X'11010','eeg','HHH',5
deallocate prepare stm3;

prepare stm from 'select nr,blob_to_bit(b),clob_to_char(c),str from ptbl order by str'
execute stm
deallocate prepare stm;

prepare stm from 'select nr,blob_length(b),clob_length(c),str from ptbl order by str'
execute stm
deallocate prepare stm;

prepare stm4 from 'delete from ptbl where blob_to_bit(b)=? and clob_to_char(c)=?'
execute stm4 using X'10011','aaa'
execute stm4 using X'10111','aaa'
execute stm4 using X'10111','bbb'
deallocate prepare stm4;

prepare stm from 'select nr,blob_to_bit(b),clob_to_char(c),str from ptbl order by str'
execute stm
deallocate prepare stm;

delete from ptbl;
drop ptbl;