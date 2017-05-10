--+ holdcas on;

select charset, lang from db_root limit 2;
select charset, lang from db_root limit 0,2;
select charset, lang from db_root limit 0+2;
select charset, lang from db_root limit 0+0,2-0;

select charset, lang from db_root limit 2;
select charset, lang from db_root limit 0,2;
select charset, lang from db_root limit 1*2;
select charset, lang from db_root limit 0*0,2/1;

--+ holdcas off;




