prepare stmt from 'select charset(?)';
execute stmt using _utf8'BB';
deallocate prepare stmt;
select charset(_utf8'AA'||_utf8'BB');
prepare stmt from 'select charset(_utf8''AA''||?)';
execute stmt using _utf8'BB';
deallocate prepare stmt;