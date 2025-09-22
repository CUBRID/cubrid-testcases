--+ holdcas on;
set names utf8;
set @ហឡកឮ = 2;

select @ហឡកឮ + 2;

drop variable @ហឡកឮ;
set names utf8;
commit;
--+ holdcas off;
