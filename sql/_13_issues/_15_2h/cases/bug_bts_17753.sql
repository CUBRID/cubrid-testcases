select if(1, _utf8'a', _binary'b'), charset(if(1, _utf8'a', _binary'b'));
set names binary;
select charset('a');
set names iso88591;
