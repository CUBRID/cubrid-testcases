prepare s from 'select case ? when ? then ? else ? end';
execute s using 1, 1, 1, 1;
execute s using 1, 1, 1, 1;
deallocate prepare s;