prepare stm from 'select 2 from db_root'
execute stm
deallocate prepare stm;

prepare stm from 'select 2 * abs(1 * -3) from db_root'
execute stm
drop prepare stm;

prepare stm from 'select 2 * abs(1 * ?) from db_root'
execute stm using -3
drop prepare stm;

prepare stm from 'select ? * abs(1 * -3), 2 * abs(1 * ?) from db_root'
execute stm using 2, -3
drop prepare stm;

prepare stm from 'select ? * abs(1 * ?) from db_root'
execute stm using 2
drop prepare stm;

prepare stm from 'select abs(1 * ?, 1 * ?) from db_root'
execute stm using -3, -3
drop prepare stm;

prepare stm from 'select'
execute stm
drop prepare stm;

prepare stm from 'select ? as test1,? as test2 from db_root where ?=''a'''
execute stm using 1,'a',2
drop prepare stm;

prepare stm from 'select ? as test1,? as test2 from db_root where ?=''a'''
execute stm using 1,'a','a'
drop prepare stm;

prepare stm from 'select ? as test1,? as test2 from db_root where ?=?'
execute stm using 1,'a',2,3
drop prepare stm;

prepare stm from 'select ? as test1,? as test2 from db_root where ?=?'
execute stm using 1,'a','a',3
drop prepare stm;

prepare stm from 'select ? as test1,? as test2 from db_root where ?=?'
execute stm using 1,'a',3,3
drop prepare stm;
