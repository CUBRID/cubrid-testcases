--+ holdcas on;
show collation abc;
show collation show;
show collation 1;
show collation wher charset='iso88591';
show collation order by 1;
show collation where charset='iso88591' order by 1 desc;
show collation where charset='iso88591' order by charset desc;
show collation 'aa';
set @a='show';
show collation @a;
prepare st from 'show collation 1';
deallocate prepare st;
drop variable @a;
set names iso88591;

--+ holdcas off;
