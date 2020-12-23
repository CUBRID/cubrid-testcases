select class_name
from (select class_name from _db_class where is_system_class=1) t
where t.class_name = 'dual';
