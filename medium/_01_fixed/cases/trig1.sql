autocommit off;
create class c1
        (name string, 
         age  integer,
         hobbies set_of(string)
        );
create trigger t1
  before insert on c1
  if new.name is null
  execute reject;
insert into c1 (name) values('fred');
rollback work;
rollback;
