--SELECT d.deck_id, d.deck_name, d.author_user_id, d.tag_1, d.tag_2, d.tag_3, d.tag_4, d.is_public FROM decks d "
    			--+ "INNER JOIN user_deck ud ON d.deck_id = ud.deck_id "
    			--+ "WHERE ud.user_id = ?
    			
    			
INSERT INTO users (username,password_hash,role) VALUES ('tester','$2a$08$UkVvwpU','ROLE_USER');
INSERT INTO users (username,password_hash,role) VALUES ('tester27','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt','ROLE_USER');

INSERT INTO decks (deck_name, author_user_id, tag_1, is_public) 
VALUES ('TestDeck', 44, 'Test', 'true') RETURNING deck_id;
INSERT INTO decks (deck_name, author_user_id, tag_1, is_public)
VALUES ('TestDeck27', 44, 'Test27', 'true') RETURNING deck_id;
		
INSERT INTO cards (question, answer) VALUES('2 + 2', '4');
		
INSERT INTO card_deck (card_id, deck_id) VALUES (131, 52); 
INSERT INTO card_deck (card_id, deck_id) VALUES (132, 53);
INSERT INTO card_deck (card_id, deck_id) VALUES (133, 57);
INSERT INTO card_deck (card_id, deck_id) VALUES (134, 58);
INSERT INTO card_deck (card_id, deck_id) VALUES (135, 58);    

INSERT INTO user_deck (user_id, deck_id) VALUES (380, 458);
		
INSERT INTO user_deck (user_id, deck_id) VALUES (381, 458);

UPDATE decks SET is_public = true WHERE deck_id = 1;

INSERT INTO cards 

SELECT * FROM cards c
INNER JOIN card_deck cd ON c.card_id = cd.card_id
INNER JOIN decks d ON cd.deck_id = d.deck_id
WHERE d.is_public = true OR d.author_user_id = 44;  