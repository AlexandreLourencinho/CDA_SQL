/**CAS PRATIQUE COMMANDE* *PRODUIT*
Travail à réaliser
Mettez en place ce trigger, puis ajoutez un produit dans une commande, vérifiez que le champ total est bien mis à jour.
Ce trigger ne fonctionne que lorsque l'on ajoute des produits dans la commande, les modifications ou suppressions 
ne permettent pas de recalculer le total. Modifiez le code ci-dessus pour faire en sorte que la modification ou la suppression de 
produit recalcul le total de la commande.Un champ remise était prévu dans la table commande. Prenez en compte ce champ 
dans le code de votre trigger.
* UPDATE TOTAL*/
DELIMITER $$
CREATE TRIGGER maj_total_update AFTER UPDATE ON lignedecommande FOR EACH ROW 
BEGIN
DECLARE id_c INT;
DECLARE tot DOUBLE;
DECLARE id_p INT;
SET id_c = NEW.id_commande;
SET id_p= NEW.id_produit;
IF ((SELECT NEW.quantite FROM lignedecommande WHERE id_c = id_commande AND id_produit=id_p) <> (SELECT OLD.quantite FROM lignedecommande WHERE id_c = id_commande AND id_produit = id_p)) THEN
SET tot = (SELECT SUM(prix*new.quantite) FROM lignedecommande WHERE id_commande = id_c AND id_produit=id_p);
UPDATE commande SET total = tot WHERE id = id_c;
ELSEIF ((SELECT NEW.prix FROM lignedecommande WHERE id_c = id_commande AND id_produit=id_p) <> (SELECT OLD.prix FROM lignedecommande WHERE id_c = id_commande AND id_produit=id_p)) THEN
SET tot = (SELECT SUM(NEW.prix*quantite) FROM lignedecommande WHERE id_commande = id_c);
UPDATE commande SET total = tot WHERE id = id_c;
ELSE 
SET tot = (SELECT SUM(prix*quantite) FROM lignedecommande WHERE id_commande = id_c AND id_produit=id_p); 
UPDATE commande SET total = tot WHERE id = id_c;
END IF;
END $$
DELIMITER ;
/* DELETE TOTAL*/
DELIMITER $$
CREATE TRIGGER maj_total_delete AFTER DELETE ON lignedecommande FOR EACH ROW
BEGIN
DECLARE id_c INT;
DECLARE tot DOUBLE;
SET id_c = OLD.id_commande;
SET tot = (SELECT SUM(prix*quantite) FROM lignedecommande WHERE id_commande = id_c);
UPDATE commande SET total = tot WHERE id = id_c;
END $$
DELIMITER ;

/*avec remise*/
/* INSERT REMISE*/
DELIMITER $$
CREATE TRIGGER maj_total_insert_remise AFTER INSERT ON lignedecommande
FOR EACH ROW
BEGIN
DECLARE id_c INT;
DECLARE tot DOUBLE;
SET id_c = NEW.id_commande;
SET tot = (SELECT SUM(prix*quantite)*(commande.remise/100) FROM lignedecommande WHERE id_commande = id_c);
UPDATE commande SET total = tot WHERE id = id_c;
END $$
DELIMITER ;
/* UPDATE REMISE*/
DELIMITER $$
CREATE TRIGGER maj_total_update_remise AFTER UPDATE ON lignedecommande FOR EACH ROW 
BEGIN
DECLARE id_c INT;
DECLARE tot DOUBLE;
DECLARE id_p INT;
SET id_c = NEW.id_commande;
SET id_p= NEW.id_produit;
IF ((SELECT NEW.quantite FROM lignedecommande WHERE id_c = id_commande AND id_produit=id_p) <> (SELECT OLD.quantite FROM lignedecommande WHERE id_c = id_commande AND id_produit = id_p)) THEN
SET tot = (SELECT (SUM(prix*new.quantite)*(1-(commande.remise/100))) FROM lignedecommande WHERE id_commande = id_c AND id_produit=id_p);
UPDATE commande SET total = tot WHERE id = id_c;        
ELSEIF ((SELECT NEW.prix FROM lignedecommande WHERE id_c = id_commande AND id_produit=id_p)<>(SELECT OLD.prix FROM lignedecommande WHERE id_c = id_commande AND id_produit = id_p)) THEN
SET tot = (SELECT (SUM(NEW.prix*quantite)*(1-(commande.remise/100))) FROM lignedecommande WHERE id_commande = id_c);
UPDATE commande SET total = tot WHERE id = id_c;        
ELSE 
SET tot = (SELECT (SUM(prix*quantite)*(1-(commande.remise/100))) FROM lignedecommande WHERE id_commande = id_c AND id_produit = id_p); 
UPDATE commande SET total = tot WHERE id = id_c;
END IF;
END $$
DELIMITER ;
/* DELETE REMISE*/
DELIMITER $$
CREATE TRIGGER maj_total_delete_remise AFTER DELETE ON lignedecommande
FOR EACH ROW
BEGIN
DECLARE id_c INT;
DECLARE tot DOUBLE;
SET id_c = old.id_commande;
SET tot = (SELECT (SUM(prix*quantite)*(1-(commande.remise/100))) FROM lignedecommande WHERE id_commande = id_c);
UPDATE commande SET total = tot WHERE id = id_c;
END $$
DELIMITER ;
