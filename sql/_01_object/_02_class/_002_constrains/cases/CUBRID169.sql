--remove ordering of constraints in create clause
autocommit off;

create table g1 (a int default 0 not null primary key);
create table g2 (a int default 0 primary key not null );
create table g3 (a int not null primary key default 0);
create table g11 (a int not null default 0 primary key );
create table g21 ( a int primary key not null default 0);
create table g31 ( a int primary key default 0 not null);

-- default 가 여러번 사용될 경우 (Error) >>
create table g4 (a int default 0 default 1 not null primary key);
create table g5 (a int default 0 not null default 1 primary key);
-- ERROR: Multiple default or shared values specified.

-- auto_increment 가 여러번 사용될 경우 (Error) >>
create table g6 (a int auto_increment auto_increment not null primary key);
-- ERROR: please check syntax at 'auto_increment', expecting Right_Paren in create class statement.

-- auto_increment와 default 가 동시에 사용될 경우 (Error) >>
create table g7 (a int auto_increment default 0 not null primary key);
create table g8 (a int auto_increment not null default 0 primary key);
-- ERROR: Default or shared values and auto increment constraint cannot be used together.

create table g9 (a int default 0 not null unique primary key);
create table g10 (a int default 0 not unique null primary key);

rollback;

autocommit on;

