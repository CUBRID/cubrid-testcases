-- Simple test create to recreate error
autocommit off;
create class PR_XXX
 (large integer,
  sh1   short,
  sh2   short UNIQUE);
insert into  PR_XXX values (100000, 0, 0);
update PR_XXX set sh2 = large; 
rollback;
