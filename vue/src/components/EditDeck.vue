<template>
<div class="edit-deck">
  <div class="editDeckForm">

    
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

    <form v-on:submit.prevent="updateDeck">
      <div class="form-group">
        <label for="title">Deck Name:</label>
        <input
          id="title"
          type="text"
          class="form-control"
          v-model="deck.deckName"
          autocomplete="off" 
          required
          maxlength="30"
        />
      </div>

      <div class="form-group">
        <label for="title">Tag:</label>
        <input
          type="text"
          class="form-control"
          v-model="deck.tag1"
          autocomplete="off" 
          required
        />
         <i id="plus-minus" type="button" v-on:click="addTag(1)" style="font-size:20px" class="fa fa-plus"></i>
      </div>

      <div class="form-group" v-if="addTag2 || showTag(2)">
        <label for="title">Tag:</label>
        <input
          type="text"
          class="form-control"
          v-model="deck.tag2"
          autocomplete="off"
        />
         <i id="plus-minus" ype="button" v-on:click="addTag(2)" style="font-size:20px" class="fa fa-plus"></i>

         <i id="plus-minus" type="button" v-on:click="removeTag(2)" style="font-size:20px" class="fa fa-minus"></i>

      </div>

      <div class="form-group" v-if="addTag3 || showTag(3)">
        <label for="title">Tag:</label>
        <input
          type="text"
          class="form-control"
          v-model="deck.tag3"
          autocomplete="off"
        />
        <i id="plus-minus" type="button" v-on:click="addTag(3)" style="font-size:20px" class="fa fa-plus"></i>

        <i id="plus-minus" type="button" v-on:click="removeTag(3)" style="font-size:20px" class="fa fa-minus"></i>

      </div>

      <div class="form-group" v-if="addTag4 || showTag(4)">
        <label for="title">Tag:</label>
        <input
          type="text"
          class="form-control"
          v-model="deck.tag4"
          autocomplete="off"
        />
        <i id="plus-minus" type="button" v-on:click="removeTag(4)" style="font-size:20px" class="fa fa-minus"></i>

      </div>

      <label id="make-public" for="public">Make Deck Public?</label>
      <input id="check-box" type="checkbox" v-model="deck.public"/>
    
    <div id="add-card" class="delete-save-deck">
        <br/><button class="add-card-btn" type="button" v-on:click="deleteDeck(deck.deckId)">Delete Deck</button>
      <input class="add-card-btn" type="submit" value="Save Deck"/>
    </div>
     
    </form>

  
  </div>
  <div class="cardBox">
    <button id="addCard" class="add-card-btn" type="button" v-on:click="addCard()">Add Card</button>

      <form class="card-display" v-if="showNewCardForm" v-on:submit.prevent="saveNewCard">
        <textarea rows="10" cols="20" class="new-card-question" v-model="newCard.question" required placeholder="Question"></textarea>
        <textarea rows="10" cols="40" class="new-card-answer"  v-model="newCard.answer" required placeholder="Answer"></textarea> 
        <i class="fa fa-check-circle" style="font-size:40px" type="submit" v-on:click="saveNewCard(newCard)"></i>
        <i class="fa fa-times" v-on:click="resetForm()" style="font-size:40px"></i>

      </form>

    <div  v-for="card in deck.cards" v-bind:key="card.cardId">
      
       <form class="card-display" v-on:submit.prevent="updateCard" v-if="showCardForm && card.cardId == editCardId">
          <textarea class="edit-card-question" rows="10" cols="20" v-model="card.question"></textarea> 
          <textarea class="edit-card-answer" rows="10" cols="40" v-model="card.answer"></textarea> 
          <i class="fa fa-check-circle" style="font-size:40px" type="submit" v-on:click="saveCard(card)"></i>
          <i class="fa fa-trash-o" style="font-size:40px" type="button" v-on:click="deleteCurrentCard(card.cardId)"></i>
        </form>  


        <div class="card-display" v-else>
        <div class="card-question"  >{{ card.question }}</div>
        <div class="vl"></div>
         <div class="card-answer" >{{ card.answer }}</div>
         <div class="vl"></div>
         <div class="edit-card">
           <i v-bind:id="card.cardId" v-bind:key="card.cardId" type="button" 
           v-on:click="editCard($event)" class="fa fa-edit" style="font-size:45px"></i>
         </div>
        </div>
      </div>   
    </div>
  </div>

</template>

<script>
 import userService from '../services/UserService';

export default {
  data() {
    return {
      addTag2: false,
      addTag3: false,
      addTag4: false,
      showCardForm: false,
      showNewCardForm: false,
      editCardId: 0,
      deck: {},
      card: {},
      newCard: {
        question: null,
        answer: null
      }
    };
  },
  methods: {
    deleteDeck(deckId) {
      const removeDeck = confirm("Are you sure you want to delete this deck?");
      if (removeDeck) {
        userService.deleteDeck(deckId).then (APIResponse => {
          if (APIResponse.status === 200 || APIResponse.status === 204) {
           this.$router.push('/home');
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
      resetForm(){
        this.showNewCardForm = false;
        this.newCard.question = null;
        this.newCard.answer = null;
      },
      addCard(){
        this.showNewCardForm = true;
      },
      saveNewCard(card){
        userService
        .createCard(this.$store.state.user.id, this.deck.deckId, card).then( APIResponse => {
            if (APIResponse.status === 201 || APIResponse.status === 200) {
              this.showNewCardForm = false;
              this.$router.go(0); 
          }     
         })
         .catch ( APIError => {
          if(APIError.response) {
            this.errorMsg = "Error creating card: " + APIError.response.statusText;        
          } else if (APIError.request) {
            this.errorMsg = "Server could not be reached.";
          } else {
            this.errorMsg = "Error creating card.";
          }
      });
      },
      saveCard(card){
        userService
        .updateCard(card.cardId, card).then (APIResponse => {
        if (APIResponse.status === 201 || APIResponse.status === 200) {
         this.showCardForm = false;
         this.editCardId = 0;
        }
      })
      .catch ( APIError => {
        if(APIError.response) {
          this.errorMsg = "Error updating card: " + APIError.response.statusText;        
        } else if (APIError.request) {
          this.errorMsg = "Server could not be reached.";
        } else {
          this.errorMsg = "Error updating card.";
        }
      });
        
      },
      editCard(event) {
        this.editCardId = parseInt(event.target.id);
        this.showCardForm = true;
      },
      deleteCurrentCard(cardId){
        userService
        .deleteCard(cardId).then (APIResponse => {
            if (APIResponse.status === 200 || APIResponse.status === 204) {
               this.$router.go(0); 
            }
          })
        .catch ( APIError => {
        if(APIError.response) {
          this.errorMsg = "Error deleing this card: " + APIError.response.statusText;        
        } else if (APIError.request) {
          this.errorMsg = "Server could not be reached.";
        } else {
          this.errorMsg = "Error deleting card.";
        }
      });

      },
      updateDeck() {
        userService.updateDeck(this.deck).then (APIResponse => {
            if (APIResponse.status === 201 || APIResponse.status === 200) {
            this.$router.push('/home') 
            }
      })
      .catch ( APIError => {
        if(APIError.response) {
          this.errorMsg = "Error updating deck: " + APIError.response.statusText;        
        } else if (APIError.request) {
          this.errorMsg = "Server could not be reached.";
        } else {
          this.errorMsg = "Error updating deck.";
        }
      });
      },
      showTag(num) {
        if (num === 2 && this.deck.tag2 != null) {
          this.addTag2 = true;
        } else if (num === 3 && this.deck.tag3 != null) {
          this.addTag3 = true;
        } else if (num === 4 && this.deck.tag4 != null) {
          this.addTag4 = true;
        }
      },
      addTag(num) {
          if (num === 1) {
              this.addTag2 = true;
          } else if (num === 2) {
              this.addTag3 = true;
          } else if (num === 3) {
              this.addTag4 = true;
          }
      },
      removeTag(num) {
        if (num === 2) {
            this.addTag2 = false;
            this.deck.tag2 = null;
        } else if (num === 3) {
            this.addTag3 = false;
            this.deck.tag3 = null;
        } else if (num === 4) {
            this.addTag4 = false;
            this.deck.tag4 = null;
        }
      },
    },
    created(){
      userService
      .getDeckByDeckId(this.$route.params.deckId)
      .then(response => {
        this.deck = response.data;
      })
      .catch(error => {
        if (error.response.status == 404) {
          this.$router.push("/not-found");
        }
      });
    }
} 
 
</script>

<style>
.edit-deck{
  display: flex;
}

.editDeckForm{
  border: 3px;
  border-style: solid;
  border-radius: 15px;
  border-color: #5267b1;
  background-color: #f1cac47a;
  width: 500px;
  height: 650px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  margin: 100px;
  margin-top: 165px;
  padding-left: 70px;
  padding-right: 70px;
  position: fixed;
}

#make-public {
  font-family: 'Roboto', sans-serif;
  color: #5267B1;
  font-size: 30px;
  padding-bottom: 100px;
}

.cardBox{
  display: flex;
  flex-direction: column;
  margin-top: 100px;
  padding-left: 845px;
}

.card-display {
  font-family: 'Roboto', sans-serif;
  margin: 10px;
  border: 4px;
  border-style: solid;
  border-color: #5267b1;
  border-radius: 15px;
  background-color: #ebefff4d;
  width: 800px;
  display: flex;
  justify-content: space-around;
  align-items: center;
 }

.card-question, .card-answer, .edit-card{
  /* height: 100%; */
  padding: 64px;
  font-size: 17px;
} 

.card-question{
  width: 100px;
  font-weight: bold;
}
.card-answer{
  width: 400px;
  border-left: 3px solid #5267b1;
  border-right: 3px solid #5267b1;
}
.edit-card{
  width: 10px;
}

#addCard{
  margin-left: 29vw;
  margin-bottom: 20px;
  width: 250px;
}

.new-card-question, .new-card-answer,
.edit-card-question, .edit-card-answer{
  margin: 10px;
  font-family: 'Roboto', sans-serif;
  font-size: 18px;
  border-radius: 10px;
  -webkit-border-radius: 2px; 
  background-color: #bfcbfd4d;
  border: none;
}

.delete-save-deck {
  margin-top: 10px;
}

</style>