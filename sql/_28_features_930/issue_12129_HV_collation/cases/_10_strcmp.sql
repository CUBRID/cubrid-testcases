set names iso88591;

prepare stmt from 'select if(strcmp(?, ?)=?, ''OK'', ''NOK'')';
set names utf8 collate utf8_en_ci;
execute stmt using 'a', 'A', 0;
set names utf8 collate utf8_en_cs;
execute stmt using 'a', 'A', 1;
deallocate prepare stmt;

set names iso88591;


