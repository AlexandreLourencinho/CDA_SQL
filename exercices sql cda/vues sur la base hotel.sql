/* VUES sur la base hôtel
1-1 :Afficher la liste des hôtels avec leur station*/
CREATE VIEW v_hotel_et_station AS 
SELECT * FROM station, hotel;
-- 1-2 : Afficher la liste des chambres et leur hôtel
CREATE VIEW v_chambre_et_hotel AS
SELECT cha_numero, cha_id, cha_capacite, cha_type, hot_nom, hot_categorie, hot_adresse, hot_ville, hot_id FROM chambre 
JOIN hotel ON cha_hot_id=hot_id;
-- 1-3 : Afficher la liste des réservations avec le nom des clients
CREATE VIEW v_client_et_reservation AS 
SELECT cli_id AS "identifiant client", cli_nom AS "nom client", cli_prenom AS "prenom client", res_id AS "identifiant de la réservation",
res_cha_id AS "identifiant de la chambre réservée", res_date AS "date de la réservation", res_date_debut AS "date de début de la réservation",
res_date_fin AS "date de fin de la réservation", res_prix AS "prix de la réservation", res_arrhes AS "acompte versé" FROM client 
JOIN reservation ON res_cli_id=cli_id;
-- 1-4: Afficher la liste des chambres avec le nom de l’hôtel et le nom de la station
CREATE VIEW v_cha_hot_sta AS                                                                                                  
SELECT cha_id, cha_numero, hot_nom, sta_nom FROM chambre 
JOIN hotel ON cha_hot_id = hot_id 
JOIN station ON hot_sta_id = sta_id;
-- 1-5: Afficher les réservations avec le nom du client et le nom de l’hôtel
CREATE VIEW v_res_cli_hot AS                                                                                               
SELECT res_id AS "identifiant de la réservation",res_cha_id AS "identifiant de la chambre réservée",res_date AS "date de la réservation",res_date_debut AS "date de début",
res_date_fin AS "date de fin de la réservation",res_prix AS "prix de la réservation",res_arrhes AS "acompte versé" FROM client 
JOIN reservation ON cli_id = res_cli_id JOIN chambre ON res_cha_id = cha_id JOIN hotel ON cha_hot_id = hot_id;
