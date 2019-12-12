-- test that DROP TABLE drops all associated triggers - classes

-- 4. trigger on parent class not dropped when child class dropped
create class father (i int);
create class son as subclass of father (j int);

create trigger trg before update on father(i) execute print 'Update on father(i)';

insert into son values (1,1), (2,2);
update son set i = 23;

-- now drop the son. the father's trigger should stay there
drop son;

-- select * from db_root;
select count(*) as trig_count from db_trigger where name like 'trg';

drop father;

-- and now thew father's trigger should be gone
select count(*) as trig_count from db_trigger where name like 'trg';


-----------------------------------------------------------------------------

-- 5. trigger on child class attribute of parent class, dropping parent class

create class father (i int);
create class son as subclass of father (j int);

create trigger trg before update on son(i) execute print 'Update on son(i)';

insert into son values (1,1), (2,2);
update son set i = 23;

-- now drop the father. the trigger's column remains dangling, so CUBRID
-- disables the trigger
drop father;

-- check that the trigger still exists but it is disabled: statement should return 1
select count(*) as cnt from db_trigger where (name = 'trg') and (status = 0);

-- drop the descendant table - the trigger should still be there
drop son;

select count(*) as cnt from db_trigger where (name = 'trg') and (status = 0);

-- cleanup
drop trigger trg;

-- check that everything's gone
-- select * from db_root;
select count(*) as cnt from db_trigger where (name = 'trg') and (status = 0);
