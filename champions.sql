use championnat;

drop view if exists champions;

create view champions as select 
concat(saison,'-',saison+1) as "Saison", 
club as "Club", 
max(points) as "Points", 
journee as "J", 
victoire as "G", 
match_nul as "N", 
defaite as "P", 
bp as "BP", 
bc as "BC", 
difference_de_buts as "Diff.", 
bonus_offensif as "Bonus", 
sanction as "Sanction" 
from resultats group by saison ;
