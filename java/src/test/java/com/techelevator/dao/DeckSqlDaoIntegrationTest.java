package com.techelevator.dao;

import static org.junit.Assert.assertEquals;

import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;

import com.techelevator.model.Card;
import com.techelevator.model.Deck;
import com.techelevator.model.User;

public class DeckSqlDaoIntegrationTest extends DAOIntegrationTest {

	private DeckSqlDAO deckSqlDAO;
	private UserSqlDAO userSqlDAO;
	private JdbcTemplate jdbcTemplate;
	private int userId;
	private int user27Id;
	private int cardId;
	private int deckId;
	private int deck27Id;

	@Before
	public void setup() {

		DataSource dataSource = this.getDataSource();
		jdbcTemplate = new JdbcTemplate(dataSource);
		deckSqlDAO = new DeckSqlDAO(jdbcTemplate);
		userSqlDAO = new UserSqlDAO(jdbcTemplate);
		
		userSqlDAO.create("TEST_USER", "test_password", "user");
		User user = userSqlDAO.findByUsername("TEST_USER");
		userId = user.getId().intValue();
		
		userSqlDAO.create("TEST_USER27", "test_password", "user");
		User user27 = userSqlDAO.findByUsername("TEST_USER27");
		user27Id = user27.getId().intValue();


		String sqlInsertDeck = "INSERT INTO decks (deck_name, author_user_id, tag_1, is_public) "
				+ "VALUES ('TestDeck', ?, 'Test', 'true') RETURNING deck_id";
		
		String sqlInsertDeck27 = "INSERT INTO decks (deck_name, author_user_id, tag_1, is_public) "
				+ "VALUES ('TestDeck270', ?, 'Test27', 'true') RETURNING deck_id";
		
		String sqlInsertCard = "INSERT INTO cards (question, answer) VALUES('200 + 200', '400') RETURNING card_id";
		
		String sqlInsertIntoCardDeck = "INSERT INTO card_deck (card_id, deck_id) VALUES (?, ?)"; 

		String sqlInsertIntoUserDeck = "INSERT INTO user_deck (user_id, deck_id) VALUES (?, ?)";
		

		cardId = jdbcTemplate.queryForObject(sqlInsertCard, Integer.class);
		deckId = jdbcTemplate.queryForObject(sqlInsertDeck, Integer.class, userId);
		deck27Id = jdbcTemplate.queryForObject(sqlInsertDeck27, Integer.class, userId);
		jdbcTemplate.update(sqlInsertIntoCardDeck, cardId, deckId);
		jdbcTemplate.update(sqlInsertIntoUserDeck, userId, deckId);
		jdbcTemplate.update(sqlInsertIntoUserDeck, userId, deck27Id);
		jdbcTemplate.update(sqlInsertIntoUserDeck, user27Id, deck27Id);
	

	}
	
	@Test
	public void get_card_by_search() {
		
		List<Card> userCards = deckSqlDAO.getMyCardsBySearch("200 + 200", userId);
		
		assertEquals(1, userCards.size());
	}
	
	@Test
	public void get_deck_by_search() {
		
		List<Deck> userDecks = deckSqlDAO.getMyDecksBySearch("TestDeck270", userId);
		
		assertEquals(1, userDecks.size());
	}
	
	@Test
	public void create_deck() {
			
		Deck newDeck = new Deck();
		newDeck.setDeckName("TestDeck2");
		newDeck.setAuthorUserId(user27Id);
		newDeck.setTag1("Test");
		newDeck.setPublic(true);
		
		deckSqlDAO.createDeck(newDeck);

		List<Deck> userDecks = deckSqlDAO.getDecksByAuthor(user27Id);
		
		assertEquals(1, userDecks.size());
	}
	
	@Test
	public void create_card() {
		
		List<Card> TestDeckCardsBeforeAdd = deckSqlDAO.getCardsByDeckId(deckId);
		
		Card newCard = new Card();
		newCard.setQuestion("question");
		newCard.setAnswer("answer");
		
		deckSqlDAO.createCard(newCard, deckId, userId);
		
		List<Card> TestDeckCardsAfterAdd = deckSqlDAO.getCardsByDeckId(deckId);
		
		assertEquals(TestDeckCardsBeforeAdd.size() + 1, TestDeckCardsAfterAdd.size());
		
	}
	
	@Test
	public void update_deck() {
		
		Deck testDeck = new Deck();
		testDeck.setDeckName("TestDeck2");
		testDeck.setAuthorUserId(userId);
		testDeck.setTag1("Test");
		testDeck.setPublic(true);
		
		int testDeckId = deckSqlDAO.createDeck(testDeck);
		
		Deck newDeck = new Deck();
		newDeck.setDeckId(testDeckId);
		newDeck.setDeckName("TestDeckAlpha");
		newDeck.setAuthorUserId(userId);
		newDeck.setTag1("Test");
		newDeck.setPublic(true);
		
		deckSqlDAO.updateDeck(newDeck);
		
		Deck updatedDeck = deckSqlDAO.getDeckByDeckId(testDeckId);

		assertEquals("TestDeckAlpha", updatedDeck.getDeckName());
	}


	@Test 
	public void delete_deck() { 

		Deck newDeck = new Deck();
		newDeck.setDeckName("TestDeck2");
		newDeck.setAuthorUserId(userId);
		newDeck.setTag1("Test");
		newDeck.setPublic(true);
		
		int newDeckId = deckSqlDAO.createDeck(newDeck);

		List<Deck> userDecksBeforeDelete = deckSqlDAO.getDecksByUserId(userId);
		
		deckSqlDAO.deleteDeck(newDeckId);
		
		List<Deck> userDecksAfterDelete = deckSqlDAO.getDecksByUserId(userId);
		
		assertEquals(userDecksBeforeDelete.size() - 1, userDecksAfterDelete.size());
		
		
	}
	
	@Test
	public void update_card() {

		Card testCard = new Card();
		testCard.setQuestion("question");
		testCard.setAnswer("answer");
				
		int testCardId = deckSqlDAO.createCard(testCard, deckId, userId);
		
		Card newCard = new Card();
		newCard.setCardId(testCardId);
		newCard.setQuestion("orange");
		newCard.setAnswer("answer");
		
		deckSqlDAO.updateCard(newCard);
		
		Card updatedCard = deckSqlDAO.getCardByCardId(testCardId);
		
		assertEquals("orange", updatedCard.getQuestion());
		
	}
	
	@Test
	public void delete_card_from_card_deck() {

		Card testCard = new Card();
		testCard.setQuestion("question");
		testCard.setAnswer("answer");
				
		int testCardId = deckSqlDAO.createCard(testCard, deckId, userId);
		
		List<Card> cardsBeforeDelete = deckSqlDAO.getCardsByDeckId(deckId);
		
		deckSqlDAO.deleteCardFromCardDeck(testCardId, deckId);
		
		List<Card> cardsAfterDelete = deckSqlDAO.getCardsByDeckId(deckId);
		
		assertEquals(cardsBeforeDelete.size() - 1, cardsAfterDelete.size());
	}
	
	@Test
	public void delete_card() {

		Card testCard = new Card();
		testCard.setQuestion("question");
		testCard.setAnswer("answer");
				
		int testCardId = deckSqlDAO.createCard(testCard, deckId, userId);
		
		List<Card> cardsBeforeDelete = deckSqlDAO.getCardsByDeckId(deckId);
		
		deckSqlDAO.deleteCard(testCardId);
		
		List<Card> cardsAfterDelete = deckSqlDAO.getCardsByDeckId(deckId);
		
		assertEquals(cardsBeforeDelete.size() - 1, cardsAfterDelete.size());
	}

	@Test
	public void get_decks_by_user_id() {

		List<Deck> userDecks = deckSqlDAO.getDecksByUserId(user27Id);
	
		assertEquals(1, userDecks.size());

	}
	
	@Test
	public void get_decks_by_author() {

		List<Deck> userDecks = deckSqlDAO.getDecksByAuthor(user27Id);
	
		assertEquals(0, userDecks.size());

	}
	
//	DOES NOT WORK
	@Test
	public void get_favorited_decks() {

		List<Deck> userDecks = deckSqlDAO.getFavoritedDecks(user27Id);
	
		assertEquals(1, userDecks.size());
	}
	
	@Test
	public void get_card_by_card_id() {
		
		Card card = deckSqlDAO.getCardByCardId(cardId);
		
		assertEquals("400", card.getAnswer());
	}
	
	@Test
	public void get_deck_by_deck_id() {

		Deck userDeck = deckSqlDAO.getDeckByDeckId(deckId);
	
		assertEquals("TestDeck", userDeck.getDeckName());
		
	}
	
	@Test
	public void get_cards_by_deck_id() {
		
		List<Card> userCards = deckSqlDAO.getCardsByDeckId(deckId);
		
		assertEquals(1, userCards.size());
	}
	

	

}







