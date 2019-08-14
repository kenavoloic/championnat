USE championnat;

DROP PROCEDURE IF EXISTS D1L1Minmax;
DROP PROCEDURE IF EXISTS D1L1Saison;
DROP PROCEDURE IF EXISTS D1L1NombreParticipations;
DROP PROCEDURE IF EXISTS D1L1NombreParticipation;
DROP PROCEDURE IF EXISTS D1L1Participation;
DROP PROCEDURE IF EXISTS D1L1Champion;
DROP PROCEDURE IF EXISTS D1L1Champions;
DROP PROCEDURE IF EXISTS D1L1Nombreclubs;
DROP PROCEDURE IF EXISTS D1L1Info;

DROP PROCEDURE IF EXISTS D1L1Relegation;
DROP PROCEDURE IF EXISTS D1L1Promotion;
DROP PROCEDURE IF EXISTS D1L1Maintien;
DROP PROCEDURE IF EXISTS D1L1Test;

-- Retourne la première et la dernière saison de championnat contenus dans la base.
DELIMITER //
CREATE PROCEDURE D1L1Minmax()
BEGIN
select min(saison) as premiere, max(saison) as derniere from resultats;
END //
DELIMITER ;

-- Retourne le tableau d’une saison donnée.
-- Prise en compte de l’existence des bonus offensifs et sanctions
DELIMITER //
CREATE PROCEDURE D1L1Saison(IN annee int(4))
BEGIN
    declare _sanction int default 0;
    declare _bonus int default 0;
    declare _total int default 0;
    select sum(sanction) into _sanction from resultats where saison=annee;
    select sum(bonus_offensif) into _bonus from resultats where saison=annee;
    select _sanction + _bonus into _total;
    
    if _total = 0 then
    select saison, club, equipe_id, victoire, match_nul as nul, defaite, bp, bc, difference_de_buts as diff, points from resultats where saison=annee order by points desc, club;
    else 
    select saison, club, equipe_id, victoire, match_nul as nul, defaite, bp, bc, difference_de_buts as diff, bonus_offensif as bonus, sanction, points from resultats where saison=annee order by points desc, club;
    
    end if;
END //
DELIMITER ;

-- Retourne le nombre de participatation d’un club au championnat de D1/L1
DELIMITER //
CREATE PROCEDURE D1L1NombreParticipations(in equipe int)
BEGIN
DECLARE nombre int;
SELECT count(saison) INTO nombre FROM resultats WHERE equipe_id = equipe;
select nombre;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE D1L1Participation(in equipe int)
BEGIN
-- DECLARE nombre int;
-- SELECT count(saison) INTO nombre FROM resultats WHERE equipe_id = equipe;
SELECT saison FROM resultats WHERE equipe_id = equipe;
END //
DELIMITER ;



-- Retourne la liste de tous les clubs champions
DELIMITER //
CREATE PROCEDURE D1L1Champions()
-- Impossible d’utiliser la procédure SAISON en raison des boni offensifs et sanctions.
BEGIN
select saison, club, equipe_id, victoire, match_nul as nul, defaite, bp, bc, difference_de_buts as diff, bonus_offensif as bonus, sanction, max(points) from resultats group by  saison;
END //
DELIMITER ;

-- Retourne le club champion pour l’année demandée
DELIMITER //
CREATE PROCEDURE D1L1Champion(IN annee INT)
BEGIN
SELECT saison, club, equipe_id, victoire, match_nul as nul, defaite, bp, bc, difference_de_buts as diff, bonus_offensif as bonus, sanction, max(points) from resultats where saison = annee;
END //
DELIMITER ;

-- Retourne le nombre de clubs pour une saison donnée
DELIMITER //
CREATE PROCEDURE D1L1NombreClubs(IN annee INT)
BEGIN
DECLARE nombre INT;
SELECT COUNT(club) INTO nombre FROM resultats WHERE saison=annee;
SELECT nombre;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE D1L1Info(in annee INT)
BEGIN
CALL champions(annee);
CALL saison(annee);
END //
DELIMITER ;

-- Retourne le nom des équipes reléguées en fin de saison.
-- Condition n + 1 doit exister. 
DELIMITER //
CREATE PROCEDURE d1l1Relegation(in annee INT)
BEGIN
select t1.club from (select club from resultats where saison = annee ) t1
where t1.club not in (select club from resultats where saison = annee + 1);
END//
DELIMITER ;

-- Retourne le nom des équipes promues en début de saison
-- Condition n -1 doit exister.
DELIMITER //
CREATE PROCEDURE d1l1Promotion(in annee INT)
BEGIN
select t1.club from (select club from resultats where saison = annee ) t1
where t1.club not in (select club from resultats where saison = annee - 1);
END//
DELIMITER ;

-- Retourne le nom des équipes qui se sont maintenues la saison précédente.
-- Condition n -1 doit exister.
DELIMITER //
CREATE PROCEDURE d1l1Maintien(in annee INT)
BEGIN
select t1.club from (select club from resultats where saison = annee ) t1
where t1.club in (select club from resultats where saison = annee - 1);
END//
DELIMITER ;



DELIMITER //
CREATE PROCEDURE d1l1test(in annee INT)
BEGIN
select t1.club from (select club from resultats where saison = annee ) t1
where t1.club in (select club from resultats where saison = annee - 1);
END//
DELIMITER ;

