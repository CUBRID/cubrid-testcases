-- [er]alert table add constraint foreign key on a field of create table and references a table which create

create table pt (i int, j int, k int, primary key(i)); 
create table ft (i int, j int, k int); 
alter table ft add constraint f_pt foreign key (i,j) references pt (i); 
drop pt;
drop ft;