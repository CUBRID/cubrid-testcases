autocommit off;
create class c1
      (name string, 
       age  integer,
       hobbies set_of(string)
      );
create trigger start_with_a_name
  before insert on c1
  if new.name is null
  execute reject;
insert into c1 default values;
rollback;
