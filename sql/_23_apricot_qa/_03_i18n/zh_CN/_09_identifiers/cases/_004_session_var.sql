--+ holdcas on;
set names utf8;
set @会话变量 = 2;

select @会话变量 + 2;

drop variable @会话变量;
set names utf8;
commit;
--+ holdcas off;
