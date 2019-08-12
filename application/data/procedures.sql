USE championnat;

DROP PROCEDURE IF EXISTS grintaMinmax;
DROP PROCEDURE IF EXISTS grintaSaison;
DROP PROCEDURE IF EXISTS grintaParticipation;
DROP PROCEDURE IF EXISTS grintaChampion;
DROP PROCEDURE IF EXISTS grintaChampions;
DROP PROCEDURE IF EXISTS grintaNombreclubs;
DROP PROCEDURE IF EXISTS grintaInfo;

-- Retourne la première et la dernière saison de championnat contenus dans la base.
DELIMITER //
CREATE PROCEDURE grintaMinmax()
BEGIN
select min(saison) as premiere, max(saison) as derniere from resultats;
END //
DELIMITER ;

-- Retourne le tableau d’une saison donnée.
-- Prise en compte de l'existence des bonus offensifs et sanctions
DELIMITER //
CREATE PROCEDURE grintaSaison(IN annee int(4))
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
CREATE PROCEDURE grintaParticipation(in equipe int)
BEGIN
DECLARE nombre int;
SELECT count(saison) INTO nombre FROM resultats WHERE equipe_id = equipe;
select nombre;
END //
DELIMITER ;

-- Retourne la liste de tous les clubs champions
DELIMITER //
CREATE PROCEDURE grintaChampions()
-- Impossible d'utiliser la procédure SAISON en raison des boni offensifs et sanctions.
BEGIN
select saison, club, equipe_id, victoire, match_nul as nul, defaite, bp, bc, difference_de_buts as diff, bonus_offensif as bonus, sanction, max(points) from resultats group by  saison;
END //
DELIMITER ;

-- Retourne le club champion pour l'année demandée
DELIMITER //
CREATE PROCEDURE grintaChampion(IN annee INT)
BEGIN
SELECT saison, club, equipe_id, victoire, match_nul as nul, defaite, bp, bc, difference_de_buts as diff, bonus_offensif as bonus, sanction, max(points) from resultats where saison = annee;
END //
DELIMITER ;

-- Retourne le nombre de clubs pour une saison donnée
DELIMITER //
CREATE PROCEDURE grintaNombreClubs(IN annee INT)
BEGIN
DECLARE nombre INT;
SELECT COUNT(club) INTO nombre FROM resultats WHERE saison=annee;
SELECT nombre;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE grintaInfo(in annee INT)
BEGIN
CALL champions(annee);
CALL saison(annee);
END //
DELIMITER ;
