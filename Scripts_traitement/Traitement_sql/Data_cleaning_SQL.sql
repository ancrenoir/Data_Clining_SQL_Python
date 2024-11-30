/*
   Cleaning data in SQL
*/

/* éléver la restriction de non utilisation de la clause 'where' */

set sql_safe_updates = 0;



-------------------------------------------------------------------------------------------------------------------------------------------
/* chargement de la données */
------------------------------------------------------------------------------------------------------------------------------------------
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Nashville Housing Data for Data Cleaning1.csv'
into table vente_maison.vente
fields terminated by ','
enclosed by '"'
lines terminated by '/n'
ignore 1 rows;


select*
from vente_maison.vente
order by id;

-----------------------------------------------------------------------------------------------------------------------
/* Standardisation de la colonne date_vente */
-------------------------------------------------------------------------------------------------------------------------
alter table vente_maison.vente
modify date_vente date;

----------------------------------------------------------------------------------------------------------------------------
/* Remplacer respectivement N et Y par NO, YES*/
-----------------------------------------------------------------------------------------------------------------------
update vente_maison.vente
set SoldAsVacant = case 
				   when SoldAsVacant = 'N' then 'NO'
                   when SoldAsVacant = 'Y' then 'YES'
                   else SoldAsVacant
                   end;
                   
--------------------------------------------------------------------------------------------------
/* Remplacer les valeurs '0' officées, designant 'null' par NULL */
--------------------------------------------------------------------------------------------------
UPDATE vente_maison.vente
SET 
adress_proprietaire = CASE
                            WHEN adress_proprietaire = '0' THEN NULL
                            ELSE adress_proprietaire
                          END,
nom_aquerants = CASE
                      WHEN nom_aquerants = '0' THEN NULL
                      ELSE nom_aquerants
                    END,
Adress_Aquerants = case 
					  when Adress_Aquerants = '0' then null
					  else Adress_aquerants
					end,
tax_districts = case
				    when tax_districts = '0' then null
				    else tax_districts
				 end,
valeur_terres = case
					when valeur_terres = '0' then null
                    else valeur_terres
				  end,
	valeur_construction = case
						    when valeur_construction = '0' then null
						    else valeur_construction
                           end,
	Anne_construction = case
						  when Anne_construction = '0' then null
                          else Anne_construction
                        end;

select distinct(SoldAsVacant)
from vente_maison.vente;

--------------------------------------------------------------------------------------------------------------------
/* Remplissage des adresse des propietaire par ce qui doit correspondre */
-------------------------------------------------------------------------------------------------------------------------

select b.Adress_proprietaire, a.adress_proprietaire, coalesce(a.adress_proprietaire, b.adress_proprietaire)
from vente_maison.vente a
join vente_maison.vente b
on a.id_parcerel= b.id_Parcerel
 and a.id <> b.id
where a.Adress_proprietaire is not null;

update vente_maison.vente a
join vente_maison.vente b
on a.id_parcerel= b.id_Parcerel
 and a.id <> b.id
set a.adress_proprietaire = coalesce(a.adress_proprietaire, b.adress_proprietaire)
where a.Adress_proprietaire is null;

-----------------------------------------------------------------------------------------------------------------------------------
/* Segmenter l'adresse des proprietaires dans des colonnes individuels*/
----------------------------------------------------------------------------------------------------------------------------------

select adress_proprietaire
from vente_maison.vente;

select substring(adress_proprietaire, 1, instr(adress_proprietaire, ",") -1),
substring(adress_proprietaire, instr(adress_proprietaire, ',')+1)
from vente_maison.vente;

alter table vente_maison.vente
add column AdressProprietaire_Adress varchar(150),
add column AdressProprietaire_Ville Varchar(150);

update vente_maison.vente
set AdressProprietaire_Adress = substring(adress_proprietaire, 1, instr(adress_proprietaire, ",") -1),
AdressProprietaire_ville = substring(adress_proprietaire, instr(adress_proprietaire, ',')+1);

--------------------------------------------------------------------------------------------------------------------------------
/* Segmentation adresse des Aquerants (owner) dans des colonnes individuels*/
---------------------------------------------------------------------------------------------------------------------------------

select substring_index(Adress_Aquerants, ',', 1),
 substring_index(substring_index(Adress_Aquerants, ',', 2), ',', -1),
 substring_index(Adress_Aquerants, ',', -1)
from vente_maison.vente;

alter table vente_maison.vente
add column AdressAquerant_Adress varchar(150),
add column AdressAquerant_Ville varchar(150),
add column AdressAquerant_pays varchar(150);

update vente_maison.vente
set 
AdressAquerant_Adress = substring_index(Adress_Aquerants, ',', 1),
AdressAquerant_Ville = substring_index(substring_index(Adress_Aquerants, ',', 2), ',', -1),
AdressAquerant_pays = substring_index(Adress_Aquerants, ',', -1);

----------------------------------------------------------------------------------------------------------------------------------------------
/* Suppression de doublon sur les tuples*/
---------------------------------------------------------------------------------------------------------------------------------------------

create temporary table temp1
select *
from(
select *, row_number() over(partition by id_parcerel,
										  date_vente,
                                          reference_legal,
                                          prix_vente,
                                          Adress_proprietaire 
                                          order by id) db
from vente_maison.vente) cte
where db > 1;


select*
from vente_maison.vente a
join temp1 b
 on a.id = b.id
order by a.id;


delete a
from vente_maison.vente a
join temp1 b
  on a.id = b.id;
  
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Suppression de colonnes unitile  */
------------------------------------------------------------------------------------------------------------------------------------------------------------------

alter table vente_maison.vente
drop column Adress_proprietaire,
drop column Tax_districts;

                                          
										




