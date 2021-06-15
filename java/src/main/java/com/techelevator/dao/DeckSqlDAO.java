package com.techelevator.dao;

import java.util.ArrayList;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;

import com.techelevator.model.Card;
import com.techelevator.model.Deck;

@Component
public class DeckSqlDAO implements DeckDAO {
	
	private JdbcTemplate jdbcTemplate;

    public DeckSqlDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
    
    // User Story: Search FlashCards, user can search cards by question and answer
    @Override
    public List<Card> getMyCardsBySearch(String searchWord, int userId) {
    	
    	searchWord = "%" + searchWord.toLowerCase() + "%";
    	
    	List<Card> cards = new ArrayList<>();
    	
    	String sql = "SELECT c.card_id, c.question, c.answer FROM cards c "
    			+ "INNER JOIN card_deck cd ON c.card_id = cd.card_id "
    			+ "INNER JOIN decks d ON cd.deck_id = d.deck_id "
    			+ "WHERE (lower(c.question) LIKE ? OR lower(c.answer) LIKE ?) AND d.author_user_id = ?";
    	
    	SqlRowSet results = jdbcTemplate.queryForRowSet(sql, searchWord, searchWord, userId); 
    	
    	while(results.next()) {
    		Card card = new Card();
    		card = mapRowToCard(results);
    		cards.add(card);
    	}
    	return cards;
    	
    }
    
    @Override
    public List<Card> getPublicCardsBySearch(String searchWord) {
    	
    	searchWord = "%" + searchWord.toLowerCase() + "%";
    	
    	List<Card> cards = new ArrayList<>();
    	
    	String sql = "SELECT c.card_id, c.question, c.answer FROM cards c "
    			+ "INNER JOIN card_deck cd ON c.card_id = cd.card_id "
    			+ "INNER JOIN decks d ON cd.deck_id = d.deck_id "
    			+ "WHERE (lower(c.question) LIKE ? OR lower(c.answer) LIKE ?) AND d.is_public = true ";
    	
    	SqlRowSet results = jdbcTemplate.queryForRowSet(sql, searchWord, searchWord); 
    	
    	while(results.next()) {
    		Card card = new Card();
    		card = mapRowToCard(results);
    		cards.add(card);
    	}
    	return cards;
    	
    }
    
    @Override
    public List<Card> getFavoriteCardsBySearch(String searchWord, int userId) {
    	
    	searchWord = "%" + searchWord.toLowerCase() + "%";
    	
    	List<Card> cards = new ArrayList<>();
    	
    	String sql = "SELECT c.card_id, c.question, c.answer FROM cards c "
    			+ "INNER JOIN card_deck cd ON c.card_id = cd.card_id "
    			+ "INNER JOIN decks d ON cd.deck_id = d.deck_id "
    			+ "INNER JOIN user_deck ud ON d.deck_id = ud.deck_id "
    			+ "WHERE (lower(c.question) LIKE ? OR lower(c.answer) LIKE ?) AND ud.user_id = ? AND d.author_user_id != ? ";
    	
    	SqlRowSet results = jdbcTemplate.queryForRowSet(sql, searchWord, searchWord, userId, userId); 
    	
    	while(results.next()) {
    		Card card = new Card();
    		card = mapRowToCard(results);
    		cards.add(card);
    	}
    	return cards;
    	
    }
    
    // User can also search for a deck based on that decks name or tags
    @Override
    public List<Deck> getMyDecksBySearch(String searchWord, int userId) { 
    	
    	searchWord = "%" + searchWord.toLowerCase() + "%";
    	
    	List<Deck> decks = new ArrayList<>();
    	
    	String sql = "SELECT deck_id, deck_name, author_user_id, tag_1, tag_2, tag_3, tag_4, is_public FROM decks "
    			+ "WHERE (lower(deck_name) LIKE ? OR lower(tag_1) LIKE ? OR lower(tag_2) LIKE ? OR lower(tag_3) LIKE ? OR lower(tag_4) LIKE ?) "
    			+ "AND author_user_id = ? ORDER BY deck_id DESC";
    	
    	SqlRowSet results = jdbcTemplate.queryForRowSet(sql, searchWord, searchWord, searchWord, searchWord, searchWord, userId);
    	
    	while(results.next()) {
    		Deck deck = new Deck();
    		deck = mapRowToDeck(results);
    		decks.add(deck);
    	}
    	return decks;
    }
    
    @Override
    public List<Deck> getPublicDecksBySearch(String searchWord) { 
    	
    	searchWord = "%" + searchWord.toLowerCase() + "%";
    	
    	List<Deck> decks = new ArrayList<>();
    	
    	String sql = "SELECT deck_id, deck_name, author_user_id, tag_1, tag_2, tag_3, tag_4, is_public FROM decks "
    			+ "WHERE (lower(deck_name) LIKE ? OR lower(tag_1) LIKE ? OR lower(tag_2) LIKE ? OR lower(tag_3) LIKE ? OR lower(tag_4) LIKE ?) "
    			+ "AND is_public = true ORDER BY deck_id DESC";
    	
    	SqlRowSet results = jdbcTemplate.queryForRowSet(sql, searchWord, searchWord, searchWord, searchWord, searchWord);
    	
    	while(results.next()) {
    		Deck deck = new Deck();
    		deck = mapRowToDeck(results);
    		decks.add(deck);
    	}
    	return decks;
    }
    
    @Override
    public List<Deck> getFavoriteDecksBySearch(String searchWord, int userId) { 
    	
    	searchWord = "%" + searchWord.toLowerCase() + "%";
    	
    	List<Deck> decks = new ArrayList<>();
    	
    	String sql = "SELECT d.deck_id, d.deck_name, d.author_user_id, d.tag_1, d.tag_2, d.tag_3, d.tag_4, d.is_public FROM decks d "
    			+ "INNER JOIN user_deck ud ON d.deck_id = ud.deck_id "
    			+ "WHERE (lower(d.deck_name) LIKE ? OR lower(d.tag_1) LIKE ? OR lower(d.tag_2) LIKE ? OR lower(d.tag_3) LIKE ? OR lower(d.tag_4) LIKE ?) "
    			+ "AND d.is_public = true AND ud.user_id = ? AND d.author_user_id != ? ORDER BY ud.user_deck_id DESC";
    	
    	SqlRowSet results = jdbcTemplate.queryForRowSet(sql, searchWord, searchWord, searchWord, searchWord, searchWord, userId, userId);
    	
    	while(results.next()) {
    		Deck deck = new Deck();
    		deck = mapRowToDeck(results);
    		decks.add(deck);
    	}
    	return decks;
    }

    // User Story: Create FlashCard Deck, users can create decks
    @Override
	public int createDeck(Deck deck) {
    	
    	String sql = "INSERT INTO decks (deck_name, author_user_id, tag_1, tag_2, tag_3, tag_4, is_public) VALUES (?, ?, ?, ?, ?, ?, ?) "
    			+ "RETURNING deck_id";
    	
    	Integer deckId = jdbcTemplate.queryForObject(sql, Integer.class, deck.getDeckName(), deck.getAuthorUserId(), deck.getTag1(), 
    			deck.getTag2(), deck.getTag3(), deck.getTag4(), deck.isPublic());
    	
    	String sql2 = "INSERT INTO user_deck (user_id, deck_id) VALUES (?, ?)";
    	jdbcTemplate.update(sql2, deck.getAuthorUserId(), deckId); 
    	
    	if (deck.getCards().size() > 0) {
	    	List<Card> cards = deck.getCards(); // If this deck is "copied" from another user, then also duplicate and add cards
	    	
	    	for(Card card : cards) {
	    		
	    		String sql3 = "INSERT INTO cards (question, answer) VALUES (?, ?) RETURNING card_id";
	    		Integer cardId = jdbcTemplate.queryForObject(sql3, Integer.class, card.getQuestion(), card.getAnswer()); 
	    		
	    		String sql4 = "INSERT INTO card_deck (card_id, deck_id) VALUES (?, ?)";
	    		jdbcTemplate.update(sql4, cardId, deckId); 
	    		
	    		String sql5 = "INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (?, ?, 1)";
	    		jdbcTemplate.update(sql5, deck.getAuthorUserId(), cardId);
	    		
	    	}
    	}
    	
    	return deckId;
    }
    
    // User Story: Create Text FlashCard
    @Override 
    public int createCard(Card card, int deckId, int userId) {
    	
    	String sql = "INSERT INTO cards (question, answer) VALUES(?, ?) RETURNING card_id";
    	
    	Integer cardId = jdbcTemplate.queryForObject(sql, Integer.class, card.getQuestion(), card.getAnswer()); 
    	
    	String sql2 = "INSERT INTO card_deck (card_id, deck_id) VALUES (?, ?)"; // When a card is created, a relationship between 
    	jdbcTemplate.update(sql2, cardId, deckId); 									//card and deck is established
    	
    	String sql3 = "INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (?, ?, 1)";
    	jdbcTemplate.update(sql3, userId, cardId); 
    	
    	return cardId;
    	
    }
    
    // User Story: Modify Deck, Part 1: user can update deck properties except for cards
    @Override
   	public void updateDeck(Deck deck) {
    	
    	if(deck.isPublic() == false) {
    		
    		String sql = "DELETE FROM user_deck WHERE deck_id = ? AND user_id != ?";
    		jdbcTemplate.update(sql, deck.getDeckId(), deck.getAuthorUserId()); 
    	}
   		
       	String sql = "UPDATE decks SET deck_name = ?, author_user_id = ?, tag_1 = ?, tag_2 = ?, tag_3 = ?, tag_4 = ?, is_public =? WHERE deck_id = ?";
       	
       	jdbcTemplate.update(sql, deck.getDeckName(), deck.getAuthorUserId(), deck.getTag1(), deck.getTag2(), deck.getTag3(), deck.getTag4(), deck.isPublic(), deck.getDeckId());
   		
   	}
    
    // User Story: Modify Deck, Part 2: delete a whole deck of cards in 1 shot - delete deck
    @Override 
    public void deleteDeck(int deckId) { // card decks, user decks, decks
    	
    	String sql = "DELETE FROM card_deck WHERE deck_id = ?";
    	jdbcTemplate.update(sql, deckId);
    	
    	String sql2 = "DELETE FROM user_deck WHERE deck_id = ?";
    	jdbcTemplate.update(sql2, deckId);
    	
    	String sql3 = "DELETE FROM decks WHERE deck_id = ?";
    	jdbcTemplate.update(sql3, deckId);
    }
    
    // User Story: Modify FlashCard, Part 1: user can update card properties.
    @Override
	public void updateCard(Card card) {
		
    	String sql = "UPDATE cards SET question = ?, answer = ? WHERE card_id = ?";
	
		jdbcTemplate.update(sql, card.getQuestion(), card.getAnswer(), card.getCardId());
    }
    
    // User Story: Modify Flashcard, Part 2: delete the relationship between a card and deck. May create an orphan card. 
    @Override
	public void deleteCardFromCardDeck(int cardId, int deckId) {
		
    	String sql = "DELETE FROM card_deck WHERE card_id = ? AND deck_id = ?";
		
    	jdbcTemplate.update(sql, cardId, deckId);
	}
    
    // User Story: Modify FlashCard, Part 3: Delete cards permanently
    @Override
    public void deleteCard(int cardId) {
    	
    	String sql = "DELETE FROM card_deck WHERE card_id = ?"; // Delete the relationship first
    	jdbcTemplate.update(sql, cardId);
    	
    	String sql2 = "DELETE FROM user_card_status WHERE card_id = ?";
    	jdbcTemplate.update(sql2, cardId);
    	
    	String sql3 = "DELETE FROM cards WHERE card_id = ?";
    	jdbcTemplate.update(sql3, cardId);
    	
    }

    //This gets any deck the user is associated with, favorites and created decks. May be a depracated method??? 
    @Override
    public List<Deck> getDecksByUserId(int userId) {
    	
    	List<Deck> userDecks = new ArrayList<>(); 
    	
    	String sql = "SELECT d.deck_id, d.deck_name, d.author_user_id, d.tag_1, d.tag_2, d.tag_3, d.tag_4, d.is_public FROM decks d "
    			+ "INNER JOIN user_deck ud ON d.deck_id = ud.deck_id "
    			+ "WHERE ud.user_id = ? ORDER BY d.deck_id DESC";
    	
    	SqlRowSet results = jdbcTemplate.queryForRowSet(sql, userId);
    	
    	while(results.next()) {
    		
    		Deck deck = new Deck();
    		deck = mapRowToDeck(results);
    		userDecks.add(deck);
    		
    	}
    	
    	return userDecks;
    }
    
    // User Story: View FlashCard Decks, Part 1: View the flashcards that I have created
	@Override
	public List<Deck> getDecksByAuthor(int userId) {
		
		List<Deck> userDecks = new ArrayList<>();
		
		String sql = "SELECT deck_id, deck_name, author_user_id, tag_1, tag_2, tag_3, tag_4, is_public FROM decks WHERE author_user_id = ? ORDER BY deck_id DESC";
		
		SqlRowSet results = jdbcTemplate.queryForRowSet(sql, userId);
		
		while(results.next()) {
		
		Deck deck = new Deck();
		deck = mapRowToDeck(results);
		userDecks.add(deck);
		
		}
	
	return userDecks;
	}
	
	// User Story: View FlashCard Decks, Part 2: These are the ones the user favorited. 
	@Override
	public List<Deck> getFavoritedDecks(int userId) {

		List<Deck> userDecks = new ArrayList<>();
		
		String sql = "SELECT d.deck_id, d.deck_name, d.author_user_id, d.tag_1, d.tag_2, d.tag_3, d.tag_4, d.is_public "
				+ "FROM decks d INNER JOIN user_deck ud ON d.deck_id = ud.deck_id WHERE ud.user_id = ? AND d.author_user_id != ? ORDER BY ud.user_deck_id DESC";
		
		SqlRowSet results = jdbcTemplate.queryForRowSet(sql, userId, userId);
		
		while(results.next()) {
		
		Deck deck = new Deck();
		deck = mapRowToDeck(results);
		userDecks.add(deck);
		
		}
	
	return userDecks;
	}
	
	@Override 
	public void insertFavoriteDeck(int userId, int deckId) {
		
		String sql = "INSERT INTO user_deck (user_id, deck_id) VALUES(?, ?)";
		jdbcTemplate.update(sql, userId, deckId);
		
		Deck deck = getDeckByDeckId(deckId);
		
		for (Card card : deck.getCards()) {
			String sql3 = "INSERT INTO user_card_status (user_id, card_id, status_id) VALUES (?, ?, 1)";
	    	jdbcTemplate.update(sql3, userId, card.getCardId()); 
		}
		
	}
	
	@Override 
	public void deleteFavoriteDeck(int userId, int deckId) {
		
		Deck deck = getDeckByDeckId(deckId);
		
		for (Card card : deck.getCards()) {
			String sql3 = "DELETE FROM user_card_status WHERE user_id = ? AND card_id = ?";
	    	jdbcTemplate.update(sql3, userId, card.getCardId()); 
		}
		
		
		String sql = "DELETE FROM user_deck WHERE user_id = ? AND deck_id = ?";
		jdbcTemplate.update(sql, userId, deckId);
		
	}
	
	// Get Card by the card Id
    @Override
	public Card getCardByCardId(int cardId) {
		
    	Card card = new Card();
    	
    	String sql = "SELECT card_id, question, answer FROM cards WHERE card_id = ?";
    	
    	SqlRowSet result = jdbcTemplate.queryForRowSet(sql, cardId);
    	
    	while(result.next()) {
    		card = mapRowToCard(result);
    	}
    	
		return card;
	}
    
    // Get Deck by deck Id
    @Override
	public Deck getDeckByDeckId(int deckId) {
		
    	Deck deck = new Deck();
    	
    	String sql = "SELECT deck_id, deck_name, author_user_id, tag_1, tag_2, tag_3, tag_4, is_public FROM decks WHERE deck_id = ?";
    	
    	SqlRowSet result = jdbcTemplate.queryForRowSet(sql, deckId);
    	
    	while(result.next()) {
    		deck = mapRowToDeck(result);
    	}
    	
		return deck;
	}
    
   // Helper method for mapRowToDeck so that the decks appear with all of their cards.  
    @Override
    public List<Card> getCardsByDeckId(int deckId) {
    	
    	List<Card> cards = new ArrayList<>();
    	
    	String sql = "SELECT c.card_id, c.question, c.answer FROM cards c INNER JOIN card_deck cd ON c.card_id = cd.card_id "
    			+ "WHERE deck_id = ? ORDER BY c.card_id DESC";
    	
    	SqlRowSet results = jdbcTemplate.queryForRowSet(sql, deckId);
    	
    	while(results.next()) {
    		
    		Card card = new Card();
    		card = mapRowToCard(results);
    		cards.add(card);
    	}
    	
    	return cards;
    	
    }
 
    @Override
    public int getCardStatusId(int cardId, int userId) {

    	String sql = "SELECT status_id FROM user_card_status WHERE card_id = ? AND user_id = ?";
   
    	Integer	statusId = jdbcTemplate.queryForObject(sql, Integer.class, cardId, userId);
   
    	return statusId;
    }
    
    @Override
    public void updateStatusId(int cardId, int userId, int statusId) {
    	
    	String sql ="UPDATE user_card_status SET status_id = ? WHERE card_id = ? AND user_id = ?";
    	
    	jdbcTemplate.update(sql, statusId, cardId, userId);
    }
    
    private Deck mapRowToDeck(SqlRowSet rs) {
        Deck deck = new Deck();
        deck.setDeckId(rs.getInt("deck_id"));
        deck.setDeckName(rs.getString("deck_name"));
        deck.setAuthorUserId(rs.getInt("author_user_id"));
        deck.setTag1(rs.getString("tag_1"));
        deck.setTag2(rs.getString("tag_2"));
        deck.setTag3(rs.getString("tag_3"));
        deck.setTag4(rs.getString("tag_4"));
        deck.setPublic(rs.getBoolean("is_public"));
        deck.setCards(getCardsByDeckId(deck.getDeckId()));
        return deck;
    }
    
    private Card mapRowToCard(SqlRowSet rs) {
    	Card card = new Card();
    	card.setCardId(rs.getInt("card_id"));
    	card.setQuestion(rs.getString("question"));
    	card.setAnswer(rs.getString("answer"));
    	return card;
    }

}
