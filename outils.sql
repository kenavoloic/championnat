use championnat;

-- mysql ne permet pas d'exécuter plusieurs commandes en même temps.
-- La solution est simple : exécuter les commandes à la chaîne avec cette procédure générale.

delimiter //

drop procedure if exists executionRequete;
create procedure executionRequete(p_requete varchar(255))
begin
    set @requete = p_requete;
    prepare stmt from @requete;
    execute stmt;
    deallocate prepare stmt;
end//

-- cette procédure va lire dans la table SAISONS toutes années de championnat connues 
-- et créer autant de VIEW qu'il y a d'années.

drop procedure if exists extraction_saisons; 

create procedure extraction_saisons()
begin

    declare v_travailTermine boolean;    
    declare v_annee int ;
    declare curseur cursor for select annee from saisons where annee > 0;
    declare continue handler for not found set v_travailTermine = true;

    open curseur;

    boucle: loop
    fetch curseur into v_annee; 
    if v_travailTermine then
        leave boucle;
        close curseur;
    end if;

    set @abandon = concat('drop view if exists d1_',v_annee);
    -- ne fonctionne pas, problème de longueur de la chaîne > 1024;
    -- set session group_concat_max_len = 1000000;
    -- set @sql = concat('create view d1_',v_annee,' as select club as "Nom", journee as "J", victoire as "G", match_nul as "N", defaite as "P", bp as "Bp", bc as "Bc", difference_de_buts as "Diff", points as "Points" from resultats where saison = ',v_annee);

    -- set @sql = concat('create view d1_',v_annee,' as select saison, club, journee, victoire, match_nul, defaite, bp, bc, difference_de_buts, bonus_offensif, sanction, points from resultats where saison = ',v_annee); 
    set @sql = concat('create view d1_',v_annee,' as select saison, rank() over(order by points desc, difference_de_buts desc) as pos, club, journee, victoire, match_nul, defaite, bp, bc, difference_de_buts, bonus_offensif, sanction, points from resultats where saison = ',v_annee); 

    call executionRequete(@abandon);
    call executionRequete(@sql);

    end loop boucle;

end//

drop procedure if exists extraction_champions;

create procedure extraction_champions()
begin

drop view if exists champions;

create view champions as select saison, club, max(points) as points, journee, victoire, match_nul, defaite, bp, bc, difference_de_buts, bonus_offensif, sanction from resultats group by saison;

-- create view champions as select concat(saison,'-',saison + 1) as "Saison", club as "Club", max(points) as "Points", journee as "J", victoire as "G", match_nul as "N", defaite as "P", bp as "BP", bc as "BC", difference_de_buts as "Diff.", bonus_offensif as "Bonus", sanction as "Sanction" from resultats group by saison ;

-- create view champions as select concat(saison,'-',saison + 1) as "Saison", rank() over(order by points desc, difference_de_buts) as "Pos.", club as "Club", max(points) as "Points", journee as "J", victoire as "G", match_nul as "N", defaite as "P", bp as "BP", bc as "BC", difference_de_buts as "Diff.", bonus_offensif as "Bonus", sanction as "Sanction" from resultats group by saison ;


end//
/*
drop procedure if exists voir_annee;

create procedure voir_annee(annee int)
begin
    declare nom_table varchar(80);
    set nom_table = concat('d1_', annee);
    -- set @nom_table = concat('d1_', annee);
    -- select into @nom_table concat('d1_',annee);
    -- select nom_table;
    select pos, club, journee, victoire, match_nul, defaite, bp, bc, difference_de_buts, bonus_offensif, sanction, points from nom_table;
end;
*/

drop procedure if exists validation_annee;

create procedure validation_annee(annee int)
begin
    -- select if((annee*1),concat('d1_',annee), 'd1_2017');
    if (annee regexp '^[0-9]+$')
        then 
        select 1;
    else 
        select 0;
    end if;

    /*
    set @retour;
    set @alors = annee/1;
    if (@alors>0)
        then 
        set @retour = concat('d1_',annee);
    else 
        set @retour = 'd1_2017';
    end if;
return @retour;
*/
end;
//

-- fonctionnnement aléatoire de la procédure suppression_vues;
-- à reprendre
drop procedure if exists suppression_vues;

create procedure suppression_vues()
begin
    set @vues = null;
    select group_concat(table_name) into @vues from information_schema.views where table_schema='championnat';
    -- select table_name into @vues from information_schema.views where table_schema='championnat';
    set @vues = concat('drop view ', @vues);
    call executionRequete(@vues);
end//


delimiter ;
