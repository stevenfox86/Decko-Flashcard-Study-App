--SELECT d.deck_id, d.deck_name, d.author_user_id, d.tag_1, d.tag_2, d.tag_3, d.tag_4, d.is_public FROM decks d "
    			--+ "INNER JOIN user_deck ud ON d.deck_id = ud.deck_id "
    			--+ "WHERE ud.user_id = ?
    			
SELECT * FROM decks WHERE author_user_id = 1; 


--INSERT INTO users (username,password_hash,role) VALUES ('Caitlin','$2a$08$UkVvwpU','ROLE_USER');
--INSERT INTO users (username,password_hash,role) VALUES ('Steven','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt','ROLE_USER');


INSERT INTO decks(deck_name, author_user_id, tag_1, is_public) VALUES ('Food', 44, 'math', false) RETURNING deck_id;
--INSERT INTO decks(deck_name, author_user_id, tag_1, is_public) VALUES ('Animals', 19, 'algebra', false);
--INSERT INTO decks(deck_name, author_user_id, tag_1, is_public) VALUES ('Hats', 20, 'coding', false);
--INSERT INTO decks(deck_name, author_user_id, tag_1, is_public) VALUES ('Shoes', 20, 'java', false);

INSERT INTO user_deck(user_id, deck_id) VALUES (547, 1);
INSERT INTO user_deck(user_id, deck_id) VALUES (548, 615);
INSERT INTO user_deck(user_id, deck_id) VALUES (19, 25);
INSERT INTO user_deck(user_id, deck_id) VALUES (20, 24);
INSERT INTO user_deck(user_id, deck_id) VALUES (20, 23);
INSERT INTO user_deck(user_id, deck_id) VALUES (20, 25);

