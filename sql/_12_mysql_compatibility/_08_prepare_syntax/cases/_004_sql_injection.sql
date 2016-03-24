--+ holdcas on;
prepare stm from 'select ? from db_root'
execute stm using 2
deallocate prepare stm;

prepare stm from 'select ? from db_root'
execute stm using '2'
deallocate prepare stm;

prepare stm from 'select ? from db_root'
execute stm using 'a'
deallocate prepare stm;

prepare stm from 'select ? from db_root'
execute stm using null
deallocate prepare stm;

prepare stm from 'select ? from db_root;'
execute stm using ''''' from db_root; select ''sql injection worked'' '
deallocate prepare stm;

prepare stm from 'select 2 from db_root where charset=?'
execute stm using 3
deallocate prepare stm;

prepare stm from 'select 2 from db_root where charset=?'
execute stm using '3'
deallocate prepare stm;

prepare stm from 'select 2 from db_root where charset=?'
execute stm using '0; select ''sql injection worked'' from db_root;'
deallocate prepare stm;

commit;
--+ holdcas off;
