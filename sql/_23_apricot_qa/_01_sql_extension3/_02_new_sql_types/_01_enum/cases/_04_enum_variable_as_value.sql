--use varialbles and parameters as enum values


--TEST: error, use variable as enum value
SET @yellow := 'yellow';

CREATE TABLE tb (
    color ENUM('red', @yellow, 'blue')
);


--TEST: error, use parameter as enum value
SELECT 'yellow' into :yellow;

CREATE TABLE tb (
    color ENUM('red', :yellow, 'blue')
);

drop variable @yellow;
