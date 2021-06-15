<template>
  <div class="home">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

    <div>
       <router-link id="my_nav" v-bind:to="{ name: 'home'}" >  
         <button id="my-decks-btn" class="view-deck-btn" type="button">My Decks</button>
      </router-link>
      <router-link id="favorite_nav" v-bind:to="{ name: 'favorite-decks' }">
        <button class="view-deck-btn" type="button">Favorited Decks</button>
      </router-link>
      <router-link id="all_nav" v-bind:to="{ name: 'all-decks' }">
        <button class="view-deck-btn" type="button">All Decks</button>
      </router-link>
      <router-link id="create_deck_nav" v-bind:to="{ name: 'create-deck' }">
        <button class="create-deck-btn" type="button" v-on:click="resetCreateDeckForm()">Create New Deck</button>
      </router-link>
    </div>
    <div class="decks-container">
      <div
        class="deck-display"
        v-for="deck in loadAuthoredDecks"
        v-bind:key="deck.deckId"
      >
        <h3 class="deck-name">
          {{ deck.deckName }}
        </h3>

        <div class="study-deck-btn">
        <button class="study-btn" v-on:click="deckToStudy(deck.deckId)" type="button">Study Deck</button>
        </div>

        <div class="edit-delete-buttons">

          <i id="edit-id" type="button" v-on:click="viewDeck(deck.deckId)" class="fa fa-edit" style="font-size:30px"></i>
        
          <i id="delete-id" class="fa fa-trash-o" style="font-size:30px" type="button"  v-on:click="deleteDeck(deck.deckId)"></i>
          
        </div>
      </div>

    </div>
   <img class="backgroundImage" src="../img/lots_of_people.png" alt="people on books" style="background-image">

  </div>
</template>

<script>
import userService from "../services/UserService";

export default {
  name: "user-profile",
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
    this.$store.commit("SET_SEARCH_WORD", null);
  },
  methods: {
    resetCreateDeckForm(){
      let deck = {};
      this.$store.commit("SET_DECK_TO_COPY", deck);
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
    deckToStudy(deckId) {
      this.$router.push(`/studyDeck/${deckId}`);
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
  },
};
</script>

<style>
@import url("https://fonts.googleapis.com/css2?family=Roboto:wght@500&display=swap");
@import url("https://fonts.googleapis.com/css2?family=Nova+Slim&family=Roboto:wght@500&display=swap");

.view-deck-btn,
.create-deck-btn {
  background-color: #dee8fe;
  box-shadow: 3px 2px #acacac;
  font-size: 24px;
  border: none;
  padding: 15px 32px;
  font-family: "Roboto", sans-serif;
  margin-right: 15px;
}
.create-deck-btn {
  float: right;
}

#my-decks-btn {
  background-color: #5267B1;
  color: #e8e8e9;
  border: solid 4px #1e3485;
  border-radius: 3px;
}

.decks-container {
  overflow-x: scroll;
  overflow-y: hidden;
  white-space: nowrap;
  margin-top: 100px;
}

/* width */
.decks-container::-webkit-scrollbar {
  width: 10px;
}

/* Track */
.decks-container::-webkit-scrollbar-track {
  background: white;
}

/* Handle */
.decks-container::-webkit-scrollbar-thumb {
  background: #e8e8e9;
  border-radius: 10px;
}

/* Handle on hover */
.decks-container::-webkit-scrollbar-thumb:hover {
  background: #bebebe;
  border-radius: 10px;
}

.deck-display {
  margin: 10px;
  border: 3px;
  border-style: solid;
  border-color: #5267b1;
  border-radius: 15px;
  background-color: #f1cac47a;
  width: 347px;
  height: 415px;
  display: inline-block;
  overflow: auto;
  margin-right: 80px;
}

.deck-name {
  padding-top: 70px;
  text-align: center;
  white-space: normal !important;
}

h3 {
  font-family: "Roboto", sans-serif;
  font-size: 36px;
  font-weight: 100;
}


.edit-delete-buttons {
  display: flex;
  justify-content: space-between;
  justify-content: center;
}

.study-btn {
  margin-left: 15px;
  margin-right: 15px;
  padding: 10px;
  border-radius: 20px;
  border: none;
  box-shadow: 0px 4px 4px rgb(98, 97, 97);
  margin-top: 30px;
  padding-left: 73px;
  padding-right: 73px;
  font-family: "Roboto", sans-serif;
  font-size: 18px;
  background-color: white;
}

.study-deck-btn {
  display: flex;
  margin: 10px;
  justify-content: center;
  
}

.study-btn:hover{
  -webkit-transform: scale(1.1);
      transform: scale(1.1);
  background-color: #DEE8FE;
}


.home {
  padding: 100px 100px 0px 100px;
}

#edit-id, #delete-id {
  margin: 30px;

}

.backgroundImage{
  position: absolute;
  bottom: 0px;
  left: 25%;
  z-index:-1;
  opacity: 75%;
}

i:hover{
  cursor: pointer;
}



</style>