autocommit off;
create vclass vvvc;
create class c as subclass of vvvc;
rollback;
