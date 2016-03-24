--[er]test abs function with char, nchar type as its operand
select abs('char') from db_root;
select abs(n'char') from db_root;
