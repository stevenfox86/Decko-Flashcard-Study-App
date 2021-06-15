import axios from 'axios';


export default {
    getDecksByUser(userId){
        return axios.get(`/${userId}/decks`);
    },

    getFavoriteDecks(userId) {
        return axios.get(`/${userId}/favoriteDecks`);
    },

    getAuthoredDecks(userId) {
        return axios.get(`/${userId}/myDecks`);
    },

    createDeck(deck) {
        return axios.post('/decks', deck);
    },

    updateDeck(deck){
        return axios.put('/decks', deck);
    },

    deleteDeck(deckId){
        return axios.delete(`/decks/${deckId}`);
    },
    
    getDeckByDeckId(deckId){
        return axios.get(`/decks/${deckId}`);
    },

    updateCard(cardId, card){
        return axios.put(`/cards/${cardId}`, card);
    },

    deleteCard(cardId){
        return axios.delete(`/cards/${cardId}`);
    },

    createCard(userId, deckId, card){
        return axios.post(`/${userId}/deck/${deckId}/cards`, card);
    },

    getCardByCardId(cardId) {
        return axios.get(`/cards/${cardId}`);
    },
    getCardStatusId(userId, cardId) {
        return axios.get(`/${userId}/${cardId}/statusId`); 
    },

    updateCardStatusId(userId, cardId, statusId){
        return axios.put(`/${userId}/${cardId}/statusId/${statusId}`)
    },

    getMyCardsBySearch(userId, searchWord) {
        return axios.get(`/${userId}/searchMyCards`, {
            params: {
            searchWord: `${searchWord}`}
        }); 
    },
    getPublicCardsBySearch(searchWord) {
        return axios.get(`/searchPublicCards`, {
            params: {
            searchWord: `${searchWord}`}
        }); 
    },
    getFavoriteCardsBySearch(userId, searchWord) {
        return axios.get(`/${userId}/searchFavoriteCards`, {
            params: {
            searchWord: `${searchWord}`}
        }); 
    },
    getMyDecksBySearch(userId, searchWord) {
        return axios.get(`/${userId}/searchMyDecks`, {
            params: {
            searchWord: `${searchWord}`}
        }); 
    },
    getPublicDecksBySearch(searchWord) {
        return axios.get(`/searchPublicDecks`, {
            params: {
            searchWord: `${searchWord}`}
        }); 
    },
    getFavoriteDecksBySearch(userId, searchWord) {
        return axios.get(`/${userId}/searchFavoriteDecks`, {
            params: {
            searchWord: `${searchWord}`}
        }); 
    },
    favoriteDeck(userId, deckId) {
        return axios.post(`/${userId}/${deckId}/favoriteDecks`)
    },
    deleteFavoriteDeck(userId, deckId) {
        return axios.delete(`/${userId}/${deckId}/favoriteDecks`)
    },
 }

