/*modif_reservation : interdire la modification des réservations (on autorise l'ajout et la suppression).*/
DELIMITER $$
CREATE TRIGGER modif_reserv BEFORE UPDATE ON reservation FOR EACH ROW
BEGIN 
SIGNAL SQLSTATE '40000' SET MESSAGE_TEXT = 'TOUCHE PAS À ÇA VIL PALTOQUET!!!';
END $$
DELIMITER ;
/*insert_reservation : interdire l'ajout de réservation pour les hôtels possédant déjà 10 réservations.*/
DELIMITER $$
CREATE TRIGGER insert_reserv BEFORE INSERT ON reservation
FOR EACH ROW
BEGIN
IF (SELECT COUNT(*) FROM reservation 
JOIN chambre ON res_cha_id = cha_id 
JOIN hotel ON cha_hot_id = hot_id GROUP BY hot_id) >= 10 
THEN
SIGNAL SQLSTATE '40000' SET MESSAGE_TEXT = 'tu as deja trop de reservations enculé';
END IF;
END $$
DELIMITER ;
/*insert_reservation2 : interdire les réservations si le client possède déjà 3 réservations.*/
DELIMITER $$
CREATE TRIGGER insert_reserv2 BEFORE INSERT ON reservation FOR EACH ROW
BEGIN
DECLARE ident INT;
SET ident = NEW.res_cli_id;
IF (SELECT COUNT(res_cli_id) FROM reservation WHERE res_cli_id=ident) >= 3 THEN
SIGNAL SQLSTATE '40000' SET MESSAGE_TEXT = 'tu as deja trop de reservatiONs ,tchip';
END IF;
END $$
/*insert_chambre : lors d'une insertion, on calcule le total des capacités des chambres pour l'hôtel, 
si ce total est supérieur à 50, on interdit l'insertion de la chambre.*/
DELIMITER $$
CREATE TRIGGER insert_chambre BEFORE INSERT ON chambre FOR EACH ROW 
BEGIN
DECLARE chambre_numero INT;
DECLARE hotel_id INT;
SET hotel_id = new.cha_hot_id;
SET chambre_numero= NEW.cha_numero;
IF (SELECT SUM(cha_capacite) FROM chambre,hotel WHERE chambre_numero = cha_numero AND cha_hot_id=hot_id GROUP BY hot_id) >= 50
THEN
SIGNAL SQLSTATE '40000' SET MESSAGE_TEXT = "y'a trop de chambres dans c't'hôtel";
END IF;
END $$
DELIMITER ;
