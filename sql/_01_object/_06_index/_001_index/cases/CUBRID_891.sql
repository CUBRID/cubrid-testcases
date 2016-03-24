--bug fix for BTS 891 issue

Create table foo (f int);
Create index i_foo_f on foo (f);
Alter index i_foo_f on foo rebuild; 
Drop table foo;
