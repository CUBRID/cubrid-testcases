autocommit off;
update none1
   set foo = 'foo';
rollback work;
rollback;
