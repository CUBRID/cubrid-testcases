--[I18N] STRCMP() doesn't work well with HV


prepare stmt from 'select if(strcmp(?, ?)=?, ''OK'', ''NOK'')';

set names utf8 collate utf8_en_ci;
execute stmt using 'a', 'A', 0;
execute stmt using 'aB', 'Ab', 0;
execute stmt using 'aBc', 'AbC', 0;

set names utf8 collate utf8_en_cs;
execute stmt using 'a', 'A', 1;
execute stmt using 'aB', 'Ab', 1;
execute stmt using 'ABc', 'AbC', -1;

set names iso88591 collate iso88591_en_ci;
execute stmt using 'a', 'A', 0;
execute stmt using 'aB', 'Ab', 0;
execute stmt using 'aBc', 'AbC', 0;


deallocate prepare stmt;


set names iso88591;
