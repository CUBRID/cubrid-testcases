-- This testcase use modified SQL Server samples. See below for the license:
-- Copyright (c) Microsoft Corporation
-- Permission is hereby granted, free of charge, to any person obtaining a copy
--  of this software and associated documentation files (the "Software"), to deal
--  in the Software without restriction, including without limitation the rights
--  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--  copies of the Software, and to permit persons to whom the Software is
--  furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in
--  all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
--  THE SOFTWARE.
drop if exists #Vehicles;
CREATE TABLE #Vehicles
(
    VehicleID     VARCHAR(5)
    ,VehicleType  VARCHAR(5)
    ,Location     VARCHAR(3)
    ,PRIMARY KEY (VehicleID)
);

INSERT INTO #Vehicles
VALUES ('12211', 'TRUCK', 'BKK'),('12212', 'CAR', 'BKK'),('12213', 'TRUCK', 'CNX')
    ,('12214', 'CAR', 'CNX'),('12215', 'TRUCK', 'HDY'),('12216', 'CAR', 'HDY');
drop if exists t1,t2;
create table t1(i int auto_increment);
create table t2(VehicleID VARCHAR(5), VehicleType  VARCHAR(5), Location VARCHAR(3),rn int);
create trigger insert_t1 
after insert on t2
execute insert into t1 values(null);
insert into t2 (
WITH BKKVehicles AS
(

    SELECT VehicleID, VehicleType, Location
        ,ROW_NUMBER() OVER (ORDER BY VehicleID) as rn
    FROM #Vehicles
    WHERE Location = 'BKK'
    union all
    select BKKVehicles.* from BKKVehicles,t1 where t1.i<10
)
SELECT VehicleID, VehicleType, Location,rn
FROM BKKVehicles);
select * from t2 order by 1,2,3,4;
select * from t1 order by 1;
drop if exists #Vehicles;
drop table if exists t1, t2;
