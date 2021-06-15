<template>
  <div class="results">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <form class="search-results" v-on:submit.prevent="showResults()">
      <select class="dropdown" v-model="newOption" name="dropdown">
        <option v-on:click="this.$router.go(0);" type ="button" value="Public Decks">Public Decks</option>
        <option v-if="$store.state.token != ''" value="My Decks" selected>
          My Decks
        </option>
        <option v-if="$store.state.token != ''" value="Favorite Decks">
          Favorite Decks
        </option>
      </select>

      <input style="background-image: url(https://img.icons8.com/ios-glyphs/30/000000/search.png); 
        background-size: 33px; background-repeat: no-repeat; padding: 2px 2px 2px 34px;"
        v-model="newWord"
        id="search-enter"
        type="text"
        placeholder="Search"
      />

    </form>
    
    <div id="search-decks-display" class="decks-container">
      <div
        class="deck-display"
        v-for="deck in decks"
        v-bind:key="deck.deckId"
      >
        <h3 class="deck-name">
          {{ deck.deckName }}
        </h3>

        <div class="study-deck-btn">
           
         <button class="study-btn" v-on:click="deckToStudy(deck.deckId)" type="button">Study Deck</button> 
        </div> 

        <div v-if="user.id === deck.authorUserId" class="edit-delete-buttons">
          <i id="edit-id" type="button" v-on:click="viewDeck(deck.deckId)" class="fa fa-edit" style="font-size:30px"></i>
          <i id="delete-id" class="fa fa-trash-o" style="font-size:30px" type="button" v-on:click="deleteDeck(deck.deckId)"></i>
        </div> 

        <div v-else class="edit-delete-buttons">

          <i v-if="deck.favorited === true" id="edit-id" class="fa fa-heart" style="font-size:30px; color: #E0636D" type="button" v-on:click="favoriteDecksToggle(deck)"></i>
          <i v-if="deck.favorited === false"  id="edit-id" class="fa fa-heart" style="font-size:30px" type="button" v-on:click="favoriteDecksToggle(deck)"></i>

          <i id="delete-id" class="fa fa-copy" style="font-size:30px" type="button" v-on:click="copyDeck(deck)"></i>
        </div>
      </div>
    </div>



    
     <h3 class="no-results-msg" v-if="decks.length == 0">{{ sorryMessage }} </h3>
      <img class="no-results-pic" v-if="decks.length == 0" src="../img/sad-girl.jpg" alt="sad girl no search">

     <img v-if="decks.length > 0" id="people-2" class="backgroundImage" src="../img/lots_of_people_2.png" alt="people on books" style="background-image">
  </div>
</template>

<script>
import userService from "../services/UserService";

export default {
  data() {
    return {
      decks: [],
      newWord: null,
      newOption: null,
      sorryMessage: "Sorry, no results. Please try another search!"
    };
  },
  created() {
     userService
        .getFavoriteDecks(this.$store.state.user.id)
        .then(response => {
          this.$store.commit("SET_FAVORITE_DECKS", response.data);
        })
        .catch(error => {
        if (error.response.status == 404) {
          this.$router.push("/not-found");
        }
      });
    this.newOption = this.$store.state.deckOption; 
    this.newWord = this.$store.state.searchWord;
    this.conditionalResults(); 
  },
  methods: {
    copyDeck(deck) {
      deck.deckId = this.$store.state.user.id;
      this.$store.commit("SET_DECK_TO_COPY", deck);
      this.$router.push({name: "create-deck"});
    },
    favoriteDecksToggle(deck) {
      if (deck.favorited == false) {
        userService.favoriteDeck(this.$store.state.user.id, deck.deckId).then( APIResponse => {
        
          if (APIResponse.status === 201 || APIResponse.status === 200) {
            this.$router.push({name: "favorite-decks"});
          }
        })
        .catch ( APIError => {
        if(APIError.response) {
          this.errorMsg = "Error favoriting deck: " + APIError.response.statusText;        
        } else if (APIError.request) {
          this.errorMsg = "Server could not be reached.";
        } else {
          this.errorMsg = "Error favoriting deck.";
        }
      });
      }
      else {
        const removeFavoriteDeck = confirm("Are you sure you want to unfavorite this deck?");
        if (removeFavoriteDeck) {
          userService.deleteFavoriteDeck(this.$store.state.user.id, deck.deckId).then (APIResponse => {
            if (APIResponse.status === 200 || APIResponse.status === 204) {
              this.$router.push({name: "favorite-decks"});
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
      }
    },
    deleteDeck(deckId) {
      const removeDeck = confirm("Are you sure you want to delete this deck?");
      if (removeDeck) {
        userService.deleteDeck(deckId).then (APIResponse => {
            if (APIResponse.status === 200 || APIResponse.status === 204) {
              this.$router.push({name: "home"});
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
    deckToStudy(deckId) {
      this.$router.push(`/studyDeck/${deckId}`);
    },
    showResults() {
      this.$store.commit("SET_DECK_OPTION", this.newOption);
      this.conditionalResults();
    },
    conditionalResults() {
      this.$store.commit("SET_SEARCH_WORD", this.newWord);
      if (this.$store.state.deckOption == "My Decks") {
        userService.getMyDecksBySearch(
          this.$store.state.user.id,
          this.$store.state.searchWord,
        )
        .then((response) => {
          this.decks = response.data;
        })
        .catch(error => {
        if (error.response.status == 404) {
          this.$router.push("/not-found");
        }
      });
      }
      else if (this.$store.state.deckOption == "Public Decks") {
        userService.getPublicDecksBySearch(
          this.$store.state.searchWord
          )
         .then((response) => {
          this.decks = response.data;
          this.decks.forEach(deck1 => {
            this.loadFavoriteDecks.forEach(deck2 => {
              if(deck1.deckId === deck2.deckId) {
                deck1.favorited = true;
              }
            })
          })

         })
        .catch(error => {
        if (error.response.status == 404) {
          this.$router.push("/not-found");
        }
      });
      } else if (this.$store.state.deckOption == "Favorite Decks") {
        userService.getFavoriteDecksBySearch(
          this.$store.state.user.id,
          this.$store.state.searchWord
          )
         .then((response) => {
          this.decks = response.data;
            this.decks.forEach(deck => {
            deck.favorited = true;
          })
         })
        .catch(error => {
        if (error.response.status == 404) {
          this.$router.push("/not-found");
        }
      });
      }
    }
  },
    computed: {
        user(){
            return this.$store.state.user;
        },
        loadFavoriteDecks() {
        const allFavoriteDecks = this.$store.state.favoriteDecks;
        return allFavoriteDecks; 
    }
    }     
};
</script>

<style>
.results {
  padding-top: 100px;
}
 #search-decks-display {
   margin-left: 80px;
   margin-right: 80px;
 }
.dropdown {
  margin-left: 100px;
  margin-right: 10px;
  height: 35px;
  font-size: 22px;
  border-radius: 5px;
  background-color: #ebefff;
}

#search-enter {
  width: 35%;
  height: 30px;
  border-radius: 10px;
  font-size: 26px;
  -webkit-border-radius: 2px; 

}

#people-2 {
  height: 250px;
}

.no-results-pic {
  padding-left: 300px;
  height: 300px;
}

.no-results-msg {
  padding-left: 200px;

}

</style>