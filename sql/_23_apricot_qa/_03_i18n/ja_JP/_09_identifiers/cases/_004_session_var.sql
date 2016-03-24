--+ holdcas on;
set names utf8;
set @会話の変数 = 2;

select @会話の変数 + 2;

drop variable @会話の変数;
set names iso88591;
commit;
--+ holdcas off;