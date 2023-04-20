DROP PROCEDURE IF EXISTS Triangle;
DROP PROCEDURE IF EXISTS Sides;
DROP PROCEDURE IF EXISTS Fiver;
DROP PROCEDURE IF EXISTS Fired;
DROP FUNCTION IF EXISTS MedianSalary;

DELIMITER //
CREATE PROCEDURE Triangle(IN a INT, b INT, OUT rad1 FLOAT, rad2 FLOAT) 
BEGIN 
	-- DECLARE с FLOAT DEFAULT 0; SET c = SQRT(a*a + b*b);
    -- SELECT c;
 SET rad1 = SQRT(a*a + b*b)/2; 
    -- SET rad1 = c/2; 
     SET rad2 = (a+b-SQRT(a*a + b*b))/2;
    -- SET rad2 = (a+b-c)/2; 
    SELECT rad1, rad2;
END; 
//
DELIMITER ;

CALL Triangle(3, 4, @r1, @r2);
SELECT @r1, @r2;

DELIMITER //
CREATE PROCEDURE Sides(IN a INT, b INT, c INT) 
BEGIN 
	IF ((a < b+c) AND (b < a+c) AND (c < b+a) AND a != b AND b != c AND c != b) THEN 
		BEGIN
        CASE WHEN (a > b AND a > c) THEN 
			BEGIN
				IF (b > c) THEN select c, b, a; 
				ELSE SELECT b, c, a; END IF;
            END;
		WHEN (b > a AND b > c) THEN 
			BEGIN
				IF (a > c) THEN select c, a, b; 
				ELSE SELECT a, c, b; END IF;
			END;
		WHEN (c > a AND c > b) THEN  
			BEGIN
				IF (a > b) THEN select b, a, c; 
				ELSE SELECT a, b, c; END IF;
			END;
        END CASE;
        END;
    ELSE SELECT "Треугольник не разносторонний остроугольный";
    END IF;
END; //
DELIMITER ;
DROP procedure Sides;
CALL sides(5, 4, 3);
CALL sides(5, 5, 5);

DELIMITER //
CREATE PROCEDURE Fiver(IN a INT, OUT s INT) 
BEGIN 
	SET s = LEFT(a, 1) + RIGHT(a, 1);
    SELECT s;
END; 
//
DELIMITER ;
CALL Fiver(4444, @s);

DELIMITER //
CREATE PROCEDURE Fired() 
BEGIN 
DECLARE done BOOLEAN default FALSE;
DECLARE fireid INT default 0;
DECLARE cur CURSOR FOR SELECT id FROM user WHERE last_login < (CURRENT_DATE - INTERVAL 1 MONTH);
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = True;
open cur;
upd: LOOP
FETCH cur INTO fireid;
	IF done THEN LEAVE upd; 
	END IF;
	UPDATE stuff SET dismissal_date = CURRENT_DATE
    WHERE id = fireid;
    UPDATE user SET is_active = FALSE
    WHERE id = fireid;
END LOOP;
END; //
DELIMITER ;
DROP PROCEDURE IF EXISTS Fired;
CALL Fired();

DELIMITER //
CREATE FUNCTION MedianSalary(dato DATE) RETURNS FLOAT deterministic
BEGIN
	DECLARE sal FLOAT DEFAULT 0;
    SET sal = (SELECT AVG(salary) FROM stuff WHERE dismissal_date < dato OR ISNULL(dismissal_date));
	RETURN sal;
END;
//
DELIMITER ;
SELECT MedianSalary('2022-04-10');


SELECT * FROM user WHERE last_login >= (CURRENT_DATE - INTERVAL 1 MONTH); -- кто всё же заходил в последнем месяце
SELECT * FROM user WHERE last_login < (CURRENT_DATE - INTERVAL 1 MONTH);
SELECT AVG(salary) FROM stuff;

SELECT * FROM stuff;
SELECT CURRENT_DATE(); -- SELECT NOW();
SELECT * FROM _position;
SELECT * FROM user;
SELECT * FROM stuff_position_history;
SELECT * FROM stuff_position_archive;
