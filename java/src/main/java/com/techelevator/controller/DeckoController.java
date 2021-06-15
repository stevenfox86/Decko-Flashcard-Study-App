package com.techelevator.controller;

import java.util.List;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.techelevator.dao.DeckDAO;
import com.techelevator.model.Card;
import com.techelevator.model.Deck;


@RestController
@CrossOrigin
public class DeckoController {
	
	private DeckDAO deckDao;
	
	public DeckoController(DeckDAO deckDao) {
        this.deckDao = deckDao;
    }
	
	@RequestMapping(path = "/{userId}/searchMyCards", method = RequestMethod.GET)
	public List<Card> getCardsBySearch(@RequestParam(defaultValue="") String searchWord, @PathVariable int userId) {
		
		return deckDao.getMyCardsBySearch(searchWord, userId);
	}
	
	@RequestMapping(path = "/searchPublicCards", method = RequestMethod.GET)
	public List<Card> getPublicCardsBySearch(@RequestParam(defaultValue="") String searchWord) {
		
		return deckDao.getPublicCardsBySearch(searchWord);
	}
	
	@RequestMapping(path = "/{userId}/searchFavoriteCards", method = RequestMethod.GET)
	public List<Card> getFavoriteCardsBySearch(@RequestParam(defaultValue="") String searchWord, @PathVariable int userId) {
		
		return deckDao.getFavoriteCardsBySearch(searchWord, userId);
	}
	
	@RequestMapping(path = "/{userId}/searchMyDecks", method = RequestMethod.GET)
	public List<Deck> getMyDecksBySearch(@RequestParam(defaultValue = "") String searchWord, @PathVariable int userId) {
		
		return deckDao.getMyDecksBySearch(searchWord, userId);
	}
	
	@RequestMapping(path = "/searchPublicDecks", method = RequestMethod.GET)
	public List<Deck> getDecksBySearch(@RequestParam(defaultValue = "") String searchWord) {
		
		return deckDao.getPublicDecksBySearch(searchWord);
	}
	
	@RequestMapping(path = "/{userId}/searchFavoriteDecks", method = RequestMethod.GET)
	public List<Deck> getFavoriteDecksBySearch(@RequestParam(defaultValue = "") String searchWord, @PathVariable int userId) {
		
		return deckDao.getFavoriteDecksBySearch(searchWord, userId);
	}
	
	@RequestMapping(path = "/decks", method = RequestMethod.POST)
	public int createDeck(@RequestBody Deck deck) {
		return deckDao.createDeck(deck); 
	}
	
	@RequestMapping(path = "/{userId}/deck/{deckId}/cards", method = RequestMethod.POST)
	public int createCard(@PathVariable int userId, @PathVariable int deckId, @RequestBody Card card) {
		return deckDao.createCard(card, deckId, userId); 
	}
	
	@RequestMapping(path = "/decks", method = RequestMethod.PUT)
	public void updateDeck(@RequestBody Deck deck) {
		
		deckDao.updateDeck(deck);
	}
	
	@RequestMapping(path = "/decks/{deckId}", method = RequestMethod.DELETE) 
	public void deleteDeck(@PathVariable int deckId) {
		
		deckDao.deleteDeck(deckId);
	}
	
	@RequestMapping(path = "/cards/{cardId}", method = RequestMethod.PUT)
	public void updateCard(@RequestBody Card card) {
		
		deckDao.updateCard(card);
	}
	
	@RequestMapping(path = "/delete/decks/{deckId}/cards/{cardId}", method = RequestMethod.DELETE)
	public void deleteCardFromCardDeck(@PathVariable int deckId, @PathVariable int cardId) {
		
		deckDao.deleteCardFromCardDeck(cardId, deckId);
	}
	
	@RequestMapping(path ="/cards/{cardId}", method = RequestMethod.DELETE)
	public void deleteCard(@PathVariable int cardId) {
		deckDao.deleteCard(cardId);
	}
	
	@RequestMapping(path = "/{userId}/decks", method = RequestMethod.GET)
	public List<Deck> getDecksByUserId(@PathVariable int userId) {
		
		return deckDao.getDecksByUserId(userId);
		
	}
	
	@RequestMapping(path = "/{userId}/myDecks", method = RequestMethod.GET)
	public List<Deck> getDecksByAuthor(@PathVariable int userId) {
		
		return deckDao.getDecksByAuthor(userId);
		
	}
	
	@RequestMapping(path = "/{userId}/favoriteDecks", method = RequestMethod.GET)
	public List<Deck> getFavoritedDecks(@PathVariable int userId) {
		
		return deckDao.getFavoritedDecks(userId);
		
	}

	@RequestMapping(path = "/{userId}/{deckId}/favoriteDecks", method = RequestMethod.POST)
	public void insertFavoriteDeck(@PathVariable int userId, @PathVariable int deckId) {
		
		deckDao.insertFavoriteDeck(userId, deckId);
	}
	
	@RequestMapping(path = "/{userId}/{deckId}/favoriteDecks", method = RequestMethod.DELETE)
	public void deleteFavoriteDeck(@PathVariable int userId, @PathVariable int deckId) {
		
		deckDao.deleteFavoriteDeck(userId, deckId);
	}

	
	@RequestMapping(path = "/cards/{cardId}", method = RequestMethod.GET)
	public Card getCardByCardId(@PathVariable int cardId) {
		
		return deckDao.getCardByCardId(cardId);
	}

	@RequestMapping(path = "/decks/{deckId}", method = RequestMethod.GET)
	public Deck getDeckByDeckId(@PathVariable int deckId) {
		
		return deckDao.getDeckByDeckId(deckId);
	}
	
	@RequestMapping(path = "/{userId}/{cardId}/statusId", method = RequestMethod.GET)
	public int getCardStatusId(@PathVariable int userId, @PathVariable int cardId) {
		
		return deckDao.getCardStatusId(cardId, userId);
	}
	
	@RequestMapping(path = "/{userId}/{cardId}/statusId/{statusId}", method = RequestMethod.PUT)
	public void updateStatusId(@PathVariable int userId, @PathVariable int cardId, @PathVariable int statusId) {
		deckDao.updateStatusId(cardId, userId, statusId);
	}

}
