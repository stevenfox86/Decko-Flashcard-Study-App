import Vue from 'vue'
import Vuex from 'vuex'
import axios from 'axios'

Vue.use(Vuex)

/*
 * The authorization header is set for axios when you login but what happens when you come back or
 * the page is refreshed. When that happens you need to check for the token in local storage and if it
 * exists you should set the header so that it will be attached to each request
 */
const currentToken = localStorage.getItem('token')
const currentUser = JSON.parse(localStorage.getItem('user'));

if(currentToken != null) {
  axios.defaults.headers.common['Authorization'] = `Bearer ${currentToken}`;
}

export default new Vuex.Store({
  state: {
    token: currentToken || '',
    user: currentUser || {},
    allDecks: [],
    favoriteDecks: [],
    authoredDecks: [],
    deckToEdit: {},
    searchWord: "",
    deckOption: "Public Decks",
    deckToCopy: {}
  },
  mutations: {
    SET_DECK_TO_COPY(state, deckToCopy) {
      state.deckToCopy = deckToCopy;
    },
    SET_DECK_OPTION(state, deckOption) {
      state.deckOption = deckOption;
    },
    SET_SEARCH_WORD(state, searchWord) {
      state.searchWord = searchWord;
    },
    SET_DECK_TO_EDIT(state, deck){
      state.deckToEdit = deck;
    },
    SET_ALL_DECKS(state, decks) {
      state.allDecks = decks;
    },
    SET_FAVORITE_DECKS(state, favoriteDecks) {
      state.favoriteDecks = favoriteDecks;
    },
    SET_AUTHORED_DECKS(state, authoredDecks) {
      state.authoredDecks = authoredDecks;
    },
    
    SET_AUTH_TOKEN(state, token) {
      state.token = token;
      localStorage.setItem('token', token);
      axios.defaults.headers.common['Authorization'] = `Bearer ${token}`
    },
    SET_USER(state, user) {
      state.user = user;
      localStorage.setItem('user',JSON.stringify(user));
    },
    LOGOUT(state) {
      localStorage.removeItem('token');
      localStorage.removeItem('user');
      state.token = '';
      state.user = {};
      axios.defaults.headers.common = {};
    }
  }
})
