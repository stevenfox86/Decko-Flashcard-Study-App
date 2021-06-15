<template>
  <div class="allDecks">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    
   <div>
    <router-link id="my_nav" v-bind:to="{ name: 'home'}" >  
         <button class="view-deck-btn" type="button">My Decks</button>
    </router-link>
    <router-link id="favorite_nav" v-bind:to="{ name: 'favorite-decks'}" >  
         <button class="view-deck-btn" type="button">Favorited Decks</button>
    </router-link>
     <router-link id="all_nav" v-bind:to="{ name: 'all-decks' }">
        <button id="all-decks-btn" class="view-deck-btn" type="button">All Decks</button>
      </router-link>
       <router-link id="create_deck_nav" v-bind:to="{ name: 'create-deck' }">
        <button class="create-deck-btn" type="button">Create New Deck</button>
      </router-link>
  </div>

  <h3 id="deck-title"><i class="fa fa-user" style="color: #E0636D"></i> My Decks  </h3>
  <div class="decks-container" id="both-decks-view">
    <div
    class="deck-display" 
        v-for="deck in loadAuthoredDecks"
        v-bind:key="deck.deckId"
      >
       <h3 class="deck-name"> {{deck.deckName}}</h3>
       <div class="study-deck-btn">
        <button class="study-btn" type="button"  v-on:click="deckToStudy(deck.deckId)">Study Deck</button>
        </div>

        <div class="edit-delete-buttons">

          <i id="edit-id" type="button" v-on:click="viewDeck(deck.deckId)" class="fa fa-edit" style="font-size:30px"></i>
        
          <i id="delete-id" class="fa fa-trash-o" style="font-size:30px" type="button"  v-on:click="deleteDeck(deck.deckId)"></i> 
          
        </div>
  </div>

  
 </div>
 <h3 id="deck-title"> <i class="fa fa-heart" style="color: #E0636D"></i> Favorites </h3>
 <div class="decks-container" id="both-decks-view">
    <div
    class="deck-display" 
        v-for="deck in loadFavoriteDecks"
        v-bind:key="deck.deckId"
      >
       <h3 class="deck-name"> {{deck.deckName}}</h3>
       <div class="study-deck-btn">
        <button class="study-btn" type="button"  v-on:click="deckToStudy(deck.deckId)">Study Deck</button>
        </div>
        <div class="edit-delete-buttons">
          <i id="edit-id" class="fa fa-heart" style="font-size:30px; color: #E0636D" type="button" v-on:click="unfavortieDeck(deck)"></i>
          <i id="delete-id" class="fa fa-copy" style="font-size:30px" type="button" v-on:click="copyDeck(deck)"></i>
        </div>
  </div>

  
 </div>
 <!-- <img class="backgroundImage" src="../img/lots_of_people.png" alt="people on books" style="background-image"> -->
 </div>
</template>

<script>
import userService from '../services/UserService';
export default {
computed: {
    loadAllDecks() {
      const allUserDecks = this.$store.state.allDecks;
      return allUserDecks;
    },
    loadFavoriteDecks() {
      const allFavoriteDecks = this.$store.state.favoriteDecks;
      return allFavoriteDecks;
    },
    loadAuthoredDecks() {
      const allAuthoredDecks = this.$store.state.authoredDecks;
      return allAuthoredDecks;
    },
  },
  created() {
    this.getAllDecksByUser();
    this.getFavoriteDecksByUser();
    this.getAuthoredDecksByUser();
  },
  methods: {
    copyDeck(deck) {
      deck.deckId = this.$store.state.user.id;
      this.$store.commit("SET_DECK_TO_COPY", deck);
      this.$router.push({name: "create-deck"});
    },
    unfavortieDeck(deck) {
        const removeFavoriteDeck = confirm("Are you sure you want to unfavorite this deck?");
        if (removeFavoriteDeck) {
          userService.deleteFavoriteDeck(this.$store.state.user.id, deck.deckId).then (APIResponse => {
            if (APIResponse.status === 200 || APIResponse.status === 204) {
              this.$router.go(0);
            }
          })
        .catch ( APIError => {
        if(APIError.response) {
          this.errorMsg = "Error unfavoriting this deck: " + APIError.response.statusText;        
        } else if (APIError.request) {
          this.errorMsg = "Server could not be reached.";
        } else {
          this.errorMsg = "Error unfavoriting deck.";
        }
      })
      }
    },
    deleteDeck(deckId) {
      const removeDeck = confirm("Are you sure you want to delete this deck?");
      if (removeDeck) {
        userService.deleteDeck(deckId).then (APIResponse => {
            if (APIResponse.status === 200 || APIResponse.status === 204) {
              this.$router.go(0);
            }
          })
        .catch ( APIError => {
        if(APIError.response) {
          this.errorMsg = "Error deleing this deck: " + APIError.response.statusText;        
        } else if (APIError.request) {
          this.errorMsg = "Server could not be reached.";
        } else {
          this.errorMsg = "Error deleting deck.";
        }
      });
      }
    },
    viewDeck(deckId) {
      this.$router.push(`/modifyDeck/${deckId}`);
    },
    getAllDecksByUser() {
      userService.getDecksByUser(this.$store.state.user.id).then((response) => {
        this.$store.commit("SET_ALL_DECKS", response.data);
      })
       .catch(error => {
        if (error.response.status == 404) {
          this.$router.push("/not-found");
        }
      });
    },
    getFavoriteDecksByUser() {
      userService
        .getFavoriteDecks(this.$store.state.user.id)
        .then((response) => {
          this.$store.commit("SET_FAVORITE_DECKS", response.data);
        })
        .catch(error => {
        if (error.response.status == 404) {
          this.$router.push("/not-found");
        }
      });
    },
    getAuthoredDecksByUser() {
      userService
        .getAuthoredDecks(this.$store.state.user.id)
        .then((response) => {
          this.$store.commit("SET_AUTHORED_DECKS", response.data);
        })
        .catch(error => {
        if (error.response.status == 404) {
          this.$router.push("/not-found");
        }
      });
    },
    deckToStudy(deckId) {
      this.$router.push(`/studyDeck/${deckId}`);
    }
    }
}
</script>

<style>
.allDecks {
    padding: 100px;
}

#both-decks-view {
  margin-top: 0px;
}

#deck-title {
 
 color: #151275;

}

#all-decks-btn {
  background-color: #5267B1;
  color: #e8e8e9;
  border: solid 4px #1e3485;
  border-radius: 3px;
 
}


</style>