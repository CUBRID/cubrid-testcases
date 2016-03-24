--[I18N] Host variable and session variable have the same coercibility level and different collation, but they can be compared.

set names iso88591;

set @v1='a';

prepare stmt from 'select coercibility(?), coercibility(@v1), collation(?), collation(@v1), ? = @v1';

set names utf8 collate utf8_en_ci;
execute stmt using 'A', 'A', 'A';

set names utf8 collate utf8_en_cs;
execute stmt using 'A', 'A', 'A';

set names utf8;
execute stmt using 'A', 'A', 'A';

set names iso88591 collate iso88591_en_ci;
execute stmt using 'A', 'A', 'A';

set names  iso88591 collate iso88591_en_cs;
execute stmt using 'A', 'A', 'A';

set names euckr;
execute stmt using 'A', 'A', 'A';

set names utf8;
set @v1='a';

set names utf8 collate utf8_en_ci;
execute stmt using 'A', 'A', 'A';

set names utf8 collate utf8_en_cs;
execute stmt using 'A', 'A', 'A';

set names utf8 collate utf8_en_ci;
set @v1='a';

set names utf8 collate utf8_en_cs;
execute stmt using 'A', 'A', 'A';


deallocate prepare stmt;
drop variable @v1;

set names iso88591;
