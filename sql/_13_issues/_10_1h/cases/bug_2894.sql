-- TRUE
prepare s from 'select 1 from db_root where ?';
execute s using true;
deallocate prepare s;

-- FALSE
prepare s from 'select 1 from db_root where ?';
execute s using false;
deallocate prepare s;

-- AND
prepare s from 'select 1 from db_root where ? and ?';
execute s using true, true;
deallocate prepare s;

prepare s from 'select 1 from db_root where ? and ?';
execute s using true, false;
deallocate prepare s;

prepare s from 'select 1 from db_root where ? and ?';
execute s using false, true;
deallocate prepare s;

prepare s from 'select 1 from db_root where ? and ?';
execute s using false, false;
deallocate prepare s;

-- OR
prepare s from 'select 1 from db_root where ? or ?';
execute s using true, true;
deallocate prepare s;

prepare s from 'select 1 from db_root where ? or ?';
execute s using true, false;
deallocate prepare s;

prepare s from 'select 1 from db_root where ? or ?';
execute s using false, true;
deallocate prepare s;

prepare s from 'select 1 from db_root where ? or ?';
execute s using false, false;
deallocate prepare s;

-- XOR
prepare s from 'select 1 from db_root where ? xor ?';
execute s using true, true;
deallocate prepare s;

prepare s from 'select 1 from db_root where ? xor ?';
execute s using true, false;
deallocate prepare s;

prepare s from 'select 1 from db_root where ? xor ?';
execute s using false, true;
deallocate prepare s;

prepare s from 'select 1 from db_root where ? xor ?';
execute s using false, false;
deallocate prepare s;

-- NOT
prepare s from 'select 1 from db_root where not ?';
execute s using true;
deallocate prepare s;

prepare s from 'select 1 from db_root where not ?';
execute s using false;
deallocate prepare s;

prepare s from 'select 1 from db_root where not ? = ?';
execute s using 0, 0;
deallocate prepare s;

prepare s from 'select 1 from db_root where not ? = ?';
execute s using 0, 1;
deallocate prepare s;

prepare s from 'select 1 from db_root where ? = ? or ? = ?';
execute s using 0, 1, 0, 0;
deallocate prepare s;


