package com.techelevator.model;

import java.util.ArrayList;
import java.util.List;

public class Deck {
	
	//private members
	private int deckId; 
	private String deckName;
	private int authorUserId;
	private String tag1;
	private String tag2;
	private String tag3;
	private String tag4;
	private boolean isPublic;
	private List<Card> cards = new ArrayList<>(); 
	private boolean isFavorited;
	
	
	// Getters and Setters 
	public int getDeckId() {
		return deckId;
	}
	public void setDeckId(int deckId) {
		this.deckId = deckId;
	}
	public String getDeckName() {
		return deckName;
	}
	public void setDeckName(String deckName) {
		this.deckName = deckName;
	}
	public int getAuthorUserId() {
		return authorUserId;
	}
	public void setAuthorUserId(int authorUserId) {
		this.authorUserId = authorUserId;
	}
	public String getTag1() {
		return tag1;
	}
	public void setTag1(String tag1) {
		this.tag1 = tag1;
	}
	public String getTag2() {
		return tag2;
	}
	public void setTag2(String tag2) {
		this.tag2 = tag2;
	}
	public String getTag3() {
		return tag3;
	}
	public void setTag3(String tag3) {
		this.tag3 = tag3;
	}
	public String getTag4() {
		return tag4;
	}
	public void setTag4(String tag4) {
		this.tag4 = tag4;
	}
	public boolean isPublic() {
		return isPublic;
	}
	public void setPublic(boolean isPublic) {
		this.isPublic = isPublic;
	}
	
	public List<Card> getCards() {
		return cards;
	}
	public void setCards(List<Card> cards) {
		this.cards = cards;
	}
	
	
	@Override
	public String toString() {
		return "Deck [deckId=" + deckId + ", deckName=" + deckName + ", tag1=" + tag1 + ", tag2=" + tag2 + ", tag3="
				+ tag3 + ", tag4=" + tag4 + "]";
	}
	public boolean isFavorited() {
		return isFavorited;
	}
	public void setFavorited(boolean isFavorited) {
		this.isFavorited = isFavorited;
	}

}
