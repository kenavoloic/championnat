use championnat;

-- Sanctions infligées par la lfp
-- ('2000','AS Saint-Étienne (-7)','1','34','9','10','15','43','56','-13','30'),
-- ('2012','AC Ajaccio(-2)','1','38','9','15','14','39','51','-12','40')

update resultats set sanction=-2 where club='AC Ajaccio' and saison='2012';
update resultats set sanction = -7 where club='AS Saint-Étienne' and saison='2000';
