--TODO: db should use en_US.utf8

set names iso88591;
prepare s from 'select FIELD (?, ?, ?, ?) into :result';
execute s using '0', '0', '1', '2';
deallocate prepare s;



