prepare stm from 'prepare s from ''select ? from db_root;''; execute s using ''a''; drop prepare s;';
execute stm;
drop prepare stm;

prepare stm from 'prepare s from ''select ? from db_root;''; execute s using ''?''; drop prepare s;';
execute stm using 'a';
drop prepare stm;

prepare stm from 'prepare s from ''?''; execute s; drop prepare s;';
execute stm using 'select * from db_root;';
drop prepare stm;
