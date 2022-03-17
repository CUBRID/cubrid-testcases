prepare stm from 'select 1*?*? from db_root';
execute stm using 2,3;
deallocate prepare stm;

prepare stm from 'select 1*?*? from db_root';
execute stm using 2,'3';
deallocate prepare stm;

prepare stm from 'select 1*?*? from db_root';
execute stm using '2',3;
deallocate prepare stm;

prepare stm from 'select 1*?*? from db_root';
execute stm using '2','3';
deallocate prepare stm;

prepare stm from 'select 1*?*? from db_root';
execute stm using null,'3';
deallocate prepare stm;

prepare stm from 'select 1*?*? from db_root';
execute stm using null,null;
deallocate prepare stm;

prepare stm from 'select 1*?*? from db_root';
execute stm using 'null',3;
deallocate prepare stm;
