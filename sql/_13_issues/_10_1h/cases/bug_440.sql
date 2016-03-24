CREATE CLASS foo (id INT, name STRING);

CREATE TRIGGER foo_trigger BEFORE UPDATE ON foo IF new.id < 0 EXECUTE REJECT;

--(A)
select * from db_trig where trigger_name = 'foo_trigger'; 

drop class foo;

--(B)
select * from db_trig where trigger_name = 'foo_trigger'; 

drop trigger foo_trigger;