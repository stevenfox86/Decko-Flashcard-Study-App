package com.techelevator.dao;

import java.util.List;

import com.techelevator.model.Card;
import com.techelevator.model.Deck;

public interface DeckDAO {
	
	List<Card> getMyCardsBySearch(String searchWord, int userId);
	List<Card> getPublicCardsBySearch(String searchWord);
	List<Card> getFavoriteCardsBySearch(String searchWord, int userId);
	List<Deck> getMyDecksBySearch(String searchWord, int userId);
	List<Deck> getPublicDecksBySearch(String searchWord);
	List<Deck> getFavoriteDecksBySearch(String searchWord, int userId);
	int createDeck(Deck deck);
	int createCard(Card card, int deckId, int userId);
	void updateDeck(Deck deck);
	void deleteDeck(int deckId);
	void updateCard(Card card);
	void deleteCardFromCardDeck(int cardId, int deckId);
	void deleteCard(int cardId);
	List<Deck> getDecksByUserId(int userId);
	List<Deck> getDecksByAuthor(int userId);
	List<Deck> getFavoritedDecks(int userId);
	void insertFavoriteDeck(int userId, int deckId);
	void deleteFavoriteDeck(int userId, int deckId);
	Card getCardByCardId(int cardId);
	Deck getDeckByDeckId(int deckId);
	List<Card> getCardsByDeckId(int deckId);
	int getCardStatusId(int cardId, int userId);
	void updateStatusId(int cardId, int userId, int statusId);
	
	

}
