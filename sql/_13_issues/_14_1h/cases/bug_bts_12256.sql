--[I18N] 'Session variable cannot have a different collation than system collation' error occurs when assigning a numeric session variable to another session variable. 


set names utf8;

set @tmp=1;
select @tmp+1;

set @a=@tmp+1;
select @a;

set @b=@tmp-100;
select @b;

set @a=@tmp+'abc';
select @a;

set @b=@tmp+'aaa' collate euckr_bin;
select @b;


drop variable @tmp, @a, @b;
set names iso88591;
