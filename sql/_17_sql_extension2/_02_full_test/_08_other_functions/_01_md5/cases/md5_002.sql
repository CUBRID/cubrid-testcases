--+ holdcas on;
--exceptional cases



--empty string
select md5('');

--empty
select md5();

--2 params
select md5('a', 'b');

--space
select md5(' ');

--negative number
select md5(-100);

--float
select md5(123123.90121028312083112398);

--null
select md5(null);


set system parameters 'no_backslash_escapes=no';
--long string
select md5('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbbbbbbbbbbbblj\;sldf9il;e49034jpkdjf\;alsd fassssssssssssssssssssssssdfkjvvv3489777777777777777777777239488302938402934888888888888880980928340928340289340823498209gks\;lkfrgjljjjjjj\;eok\;alsdfkfkkfka\;dfkl----swdf.wdeoffasdfkowefk[\'paisdf[psof-wef[dfia[df[apsdifpasdfia[dpofasiodf[asodfasdfasdpf[asdf}}}}}}\)__asdofka\;sdlfkal\;dkfa\'sdl\;fk\'asdl\;fk');

--long bit
select md5(b'11111111111111111111111111111111111111111111111110000000000000000000000000000011111111111111111111111111111111111111111111111111111111111111100000000000000000000000000000000000000011111111111111111111111111111111111111111111000000000000000000000000000000000000000000000000000001');

set system parameters 'no_backslash_escapes=yes';
commit;
--+ holdcas off;
