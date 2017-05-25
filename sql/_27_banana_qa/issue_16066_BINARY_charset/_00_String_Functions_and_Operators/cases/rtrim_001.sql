--+ holdcas on;
set names binary;

--binary 
---- bug CUBRIDSUS-17796
SELECT  concat('_',RTRIM ('     空格     '),'_');
SELECT RTRIM(NULL, '空空格格');
SELECT RTRIM('空空格格', NULL);
SELECT RTRIM('空空格格', '格');
SELECT concat('_',RTRIM('     011101     ', '01     '),'_');
SELECT concat('_',RTRIM('     011101     ', ' '),'_');

--utf8 & binary
SELECT  concat('_',RTRIM (_utf8'     空格     '),'_');
SELECT RTRIM(_utf8'空空格格', NULL);
SELECT RTRIM(NULL, _utf8'空空格格');
SELECT RTRIM(_utf8'空空格格', '格');
SELECT RTRIM('空空格格', _utf8'格');
SELECT RTRIM(_utf8'     011101     ', '01     ');
SELECT RTRIM('     011101     ', _utf8'01     ');
SELECT concat('_',RTRIM(_utf8'     011101     ', ' '),'_');
SELECT concat('_',RTRIM('     011101     ', _utf8' '),'_');

--euckr & binary
---- bug CUBRIDSUS-17796
SELECT  concat('_',RTRIM (cast( _utf8'  스페이스 바  ' as string charset euckr)),'_'); 
SELECT RTRIM(cast( _utf8'스페이스 바' as string charset euckr), NULL);
SELECT RTRIM( NULL, cast( _utf8'스페이스 바' as string charset euckr));
SELECT RTRIM(cast( _utf8'  스페이스 바' as string charset euckr), '바');
SELECT HEX(RTRIM('  스페이스 바', cast( _utf8'바' as string charset euckr)));
SELECT RTRIM(cast( _utf8'     011101     ' as string charset euckr),  '01     ');
SELECT RTRIM('     011101     ',  cast( _utf8'01     ' as string charset euckr));
SELECT concat('_',RTRIM('     011101     ',  cast( _utf8' ' as string charset euckr)),'_');
SELECT concat('_',RTRIM(cast( _utf8'     011101     ' as string charset euckr),  ' '),'_');

--iso88591 & binary
SELECT  concat('_',RTRIM (cast(_utf8'     ÀÀÀ     ' as string charset iso88591)),'_');
SELECT RTRIM(cast(_utf8'ÀÀÀÂÂ' as string charset iso88591), NULL);
SELECT RTRIM(NULL, cast(_utf8'ÀÀÀÂÂ' as string charset iso88591));
SELECT RTRIM(cast(_utf8'ÀÀÀÂÂ' as string charset iso88591), 'Â');
SELECT RTRIM('ÀÀÀÂÂ', cast(_utf8'Â' as string charset iso88591));
SELECT RTRIM(cast(_utf8'     011101     ' as string charset iso88591), '01     ');
SELECT RTRIM('     011101     ', cast(_utf8'01     ' as string charset iso88591));
SELECT concat('_',RTRIM('     011101     ', cast(_utf8' ' as string charset iso88591)),'_');
SELECT concat('_',RTRIM(cast(_utf8'     011101     ' as string charset iso88591), ' '),'_');

set names iso88591;
--+ holdcas off;
