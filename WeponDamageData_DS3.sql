
--Fixing Data Types(Used Ctrl F to update data types in every weapon table)

UPDATE DarkSoulsThreeWepons..Aquamarine_Dagger$
SET [Attack ValuesBonus_1]  = TRY_CAST([Attack ValuesBonus_1] as Float)

UPDATE DarkSoulsThreeWepons..Aquamarine_Dagger$
SET [Attack ValuesBonus_2]  = TRY_CAST([Attack ValuesBonus_2] as Float)

UPDATE DarkSoulsThreeWepons..Aquamarine_Dagger$
SET [Attack ValuesBonus_3]  = TRY_CAST([Attack ValuesBonus_3] as Float)

UPDATE DarkSoulsThreeWepons..Aquamarine_Dagger$
SET [Attack ValuesBonus_4]  = TRY_CAST([Attack ValuesBonus_4] as Float) 

UPDATE DarkSoulsThreeWepons..Aquamarine_Dagger$
SET [Auxiliary Effects]  = TRY_CAST([Auxiliary Effects] as Float)

UPDATE DarkSoulsThreeWepons..Aquamarine_Dagger$
SET [Auxiliary Effects_8] = TRY_CAST([Auxiliary Effects_8] as Float)

UPDATE DarkSoulsThreeWepons..Aquamarine_Dagger$
SET [Auxiliary Effects_9] = TRY_CAST([Auxiliary Effects_9] as Float)


----Creating table to include all daggers at all levels

DROP TABLE Daggers_Reg
USE DarkSoulsThreeWepons
CREATE TABLE Daggers_Reg (
	Daggers nvarchar(255),
	Physical_dmg float,
	Magic_dmg float,
	Fire_dmg float,
	Lighting_dmg float,
	Dark_dmg float,
	Strength_scaling varchar(1),
	Dexterity_scaling varchar(1),
	Intelligence_scaling varchar(1),
	Faith_scaling varchar(1),
	Poison_dmg float,
	Frost_dmg float,
	Bleed_dmg float)

--Inserting dagger data into new table (leaving out columns involving damage negated while blocking with wepon)

INSERT INTO Daggers_Reg 
	(Daggers,Physical_dmg, Magic_dmg, Fire_dmg,Lighting_dmg, Dark_dmg, Strength_scaling, Dexterity_scaling, Intelligence_scaling, Faith_scaling, Poison_dmg, Frost_dmg, Bleed_dmg)
SELECT
	Column1,[Attack ValuesBonus],[Attack ValuesBonus_1],[Attack ValuesBonus_2],[Attack ValuesBonus_3],[Attack ValuesBonus_4],[Parameter Bonus],[Parameter Bonus_5],[Parameter Bonus_6],[Parameter Bonus_7],[Auxiliary Effects],[Auxiliary Effects_8],[Auxiliary Effects_9]
FROM DarkSoulsThreeWepons..Aquamarine_Dagger$
SELECT *
FROM DarkSoulsThreeWepons..Daggers_Reg

--Looking at data in different ways:

--Which Dagger has the highest Physical dmg with no upgrade

SELECT * 
FROM DarkSoulsThreeWepons..Daggers_Reg
where Daggers NOT LIKE '%+%'
Order by Physical_dmg desc

--Which daggers scale the most with Dexterity at +5

SELECT * 
FROM DarkSoulsThreeWepons..Daggers_Reg
where Daggers LIKE '%+5'
Order by Dexterity_scaling

--Importing Data regarding scaling to calculate total damage (repating process)

UPDATE DarkSoulsThreeWepons..Bandits_Knife$
SET Strength = TRY_CAST(Strength as Float) 

UPDATE DarkSoulsThreeWepons..Bandits_Knife$
SET Dexterity  = TRY_CAST(Dexterity as Float)

UPDATE DarkSoulsThreeWepons..Bandits_Knife$
SET Intellegence = TRY_CAST(Intellegence as Float)

UPDATE DarkSoulsThreeWepons..Bandits_Knife$
SET Faith = TRY_CAST(Faith as Float)


USE DarkSoulsThreeWepons
DROP TABLE DaggerScalingCalculation
CREATE TABLE  DaggerScalingCalculation
	(Daggers varchar(50), 
Physical_dmg float, 
Magic_dmg float, 
Fire_dmg float, 
Lighting_dmg float, 
Dark_dmg float, 
Strength_scaling varchar(50), 
Dexterity_scaling varchar(50), 
Intelligence_scaling varchar(50), 
Faith_scaling varchar(50),
Strength float,
Dexterity float,
Intellegence float,
Faith float,
Poison_dmg int,
Frost_dmg int,
Bleed_dmg int)


USE DarkSoulsThreeWepons
INSERT INTO  DaggerScalingCalculation
	(Daggers , 
Physical_dmg, 
Magic_dmg, 
Fire_dmg, 
Lighting_dmg, 
Dark_dmg, 
Strength_scaling, 
Dexterity_scaling, 
Intelligence_scaling, 
Faith_scaling,
Strength,
Dexterity,
Intellegence,
Faith,
Poison_dmg,
Frost_dmg,
Bleed_dmg)
SELECT BaseNum.Daggers,
BaseNum.Physical_dmg, 
BaseNum.Magic_dmg, 
BaseNum.Fire_dmg, 
BaseNum.Lighting_dmg, 
BaseNum.Dark_dmg, 
BaseNum.Strength_scaling, 
BaseNum.Dexterity_scaling, 
BaseNum.Intelligence_scaling, 
BaseNum.Faith_scaling,
StatRange.Strength,
StatRange.Dexterity,
StatRange.Intellegence,
StatRange.Faith,
BaseNum.Poison_dmg,
BaseNum.Frost_dmg,
BaseNum.Bleed_dmg
FROM DarkSoulsThreeWepons..Bandits_Knife$ as StatRange
	FULL JOIN DarkSoulsThreeWepons..Daggers_Reg as BaseNum
	ON BaseNum.Daggers = StatRange.Column1
WHERE StatRange.Column1 = BaseNum.Daggers
SELECT *
FROM DarkSoulsThreeWepons..DaggerScalingCalculation


--I cant spell
UPDATE Daggers_Reg
SET Daggers = 
    CASE
        WHEN Daggers = 'Baindits_Knife+1' THEN 'Bandits_Knife+1'
		WHEN Daggers = 'Baindits_Knife+2' THEN 'Bandits_Knife+2'  
		WHEN Daggers = 'Baindits_Knife+3' THEN 'Bandits_Knife+3'
		WHEN Daggers = 'Baindits_Knife+4' THEN 'Bandits_Knife+4'
		WHEN Daggers = 'Baindits_Knife+5' THEN 'Bandits_Knife+5'
		WHEN Daggers = 'Baindits_Knife+6' THEN 'Bandits_Knife+6'
		WHEN Daggers = 'Baindits_Knife+7' THEN 'Bandits_Knife+7'
		WHEN Daggers = 'Baindits_Knife+8' THEN 'Bandits_Knife+8'
		WHEN Daggers = 'Baindits_Knife+9' THEN 'Bandits_Knife+9'
		WHEN Daggers = 'Baindits_Knife+10' THEN 'Bandits_Knife+10'
        ELSE Daggers
    END
WHERE Daggers LIKE 'Baindits_Knife%';


--Creating three tables to work from able to calculate the scaling damage =


SELECT a.Daggers,a.Physical_dmg, a.Magic_dmg,a.Fire_dmg,a.Lighting_dmg,a.Dark_dmg,a.Strength_scaling,a.Dexterity_scaling,a.Intelligence_scaling,a.Faith_scaling,a.Strength,a.Dexterity,a.Intellegence,a.Faith,b.Physical,b.Magic,b.Fire,b.Lightning,b.Dark
FROM DarkSoulsThreeWeapons..DaggerScalingCalculation$ as a
	JOIN DarkSoulsThreeWeapons..Scaling_Data$ b
	ON b.Weapon_Name = a.Daggers





USE DarkSoulsThreeWeapons


SELECT a.Daggers,b.Physical,b.Magic,b.Fire,b.Lightning,b.Dark
FROM DarkSoulsThreeWeapons..DaggerScalingCalculation$ as a
	JOIN DarkSoulsThreeWeapons..Scaling_Data$ b
	ON b.Weapon_Name = a.Daggers

CREATE TABLE DaggerSaturationCurves (Daggers nvarchar(255),
	Physical int,
	Magic int,
	Fire int,
	Lightning int,
	Dark int)
INSERT INTO DaggerSaturationCurves
	(Daggers,
	Physical,
	Magic,
	Fire,
	Lightning,
	Dark)
SELECT a.Daggers,
	b.Physical,
	b.Magic,
	b.Fire,
	b.Lightning,
	b.Dark
FROM DarkSoulsThreeWeapons..DaggerScalingCalculation$ as a
	JOIN DarkSoulsThreeWeapons..Scaling_Data$ b
	ON b.Weapon_Name = a.Daggers
SELECT *
FROM DaggerScalingCalculation$


--Scaling letter number value
SELECT *
FROM DaggerScalingCalculation$

--Saturation curve index to the weapon
SELECT *
FROM DaggerSaturationCurves

--Saturation curve value
SELECT *
FROM Saturation_Curves$

--import to excel











	