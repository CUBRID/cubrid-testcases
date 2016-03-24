create serial s1 cycle start with 1 maxvalue 100;
create serial s2 cache 100 increment by 10 start with -10 nominvalue;
create serial s3 nominvalue nocache nomaxvalue;
create serial s nominvalue nocache nomaxvalue minvalue 100;
create serial s cycle start with 1000 nomaxvalue nocycle nocache;

drop serial s1;
drop serial s2;
drop serial s3;
