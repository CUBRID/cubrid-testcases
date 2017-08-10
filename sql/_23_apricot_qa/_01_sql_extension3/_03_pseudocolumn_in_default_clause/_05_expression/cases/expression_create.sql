--TEST: use expressions as default value when creating table


--TEST: valid expression
create table e01(a timestamp default CURRENT_TIMESTAMP + 3600);
--show columns in e01;
drpo table if exists e01;


--TEST: error, invalid expression
create table e01(a timestamp default CURRENT_TIMESTAMP - 12345678999);
drpo table if exists e01;
create table e01(a timestamp default CURRENT_TIMESTAMP - 999999999999999999999999999999);
drpo table if exists e01;
create table e01(a timestamp default CURRENT_TIMESTAMP + 'abc');
drpo table if exists e01;
