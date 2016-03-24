--TODO: db should use en_US.utf8

set names iso88591;

evaluate 'a' into :b;
prepare x from 'select if(?=?, ?, :b)';
deallocate prepare x;

