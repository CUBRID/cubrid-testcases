--+ holdcas on;
set names ISO88591 collate iso88591_en_ci;
set @v1='iso8859-1';
set @v1='iso8859-1' collate iso88591_bin;
set @v1='iso8859-1' collate utf8_bin;
set @v1='iso8859-1' collate euckr_bin;
set @v1='iso8859-1';
select @v1;
show collation where charset in (charset(@v1)); 
show collation where charset in (@v1); 
show collation where charset=@v1; 
drop variable @v1;
set names iso88591 collate iso88591_bin;

--+ holdcas off;
