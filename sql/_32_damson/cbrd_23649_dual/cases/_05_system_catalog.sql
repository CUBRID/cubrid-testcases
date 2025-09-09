select class_name
from (select class_name from _db_class where flags=1) t
where t.class_name = 'dual';
