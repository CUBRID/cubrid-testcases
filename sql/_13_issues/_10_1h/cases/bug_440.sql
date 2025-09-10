CREATE CLASS foo (id INT, name STRING);

CREATE TRIGGER foo_trigger BEFORE UPDATE ON foo IF new.id < 0 EXECUTE REJECT;

--(A)
select trigger_name, owner_name, target_class_name, target_owner_name, target_attr_name, target_attr_type, action_type, action_time, comment from db_trigger where trigger_name = 'foo_trigger';

drop class foo;

--(B)
select trigger_name, owner_name, target_class_name, target_owner_name, target_attr_name, target_attr_type, action_type, action_time, comment from db_trigger where trigger_name = 'foo_trigger';

drop trigger foo_trigger;