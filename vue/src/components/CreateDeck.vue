<template>

  <div class="create-deck">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

    <img id="people_books" src="../img/people_on_books.png" alt="people on books">

      <div class="createDeck">

    <form v-on:submit.prevent="createDeck">
      <div class="form-group">
        <label for="title">Deck Name:</label>
        <input
          id="title"
          type="text"
          class="form-control"
          v-model="newDeck.deckName"
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
          v-model="newDeck.tag1"
          autocomplete="off" 
          required
        />
          <i id="plus-minus" type="button" v-on:click="addTag(1)" style="font-size:20px" class="fa fa-plus"></i>

      </div>

      <div class="form-group" v-if="addTag2">
        <label for="title">Tag:</label>
        <input
          type="text"
          class="form-control"
          v-model="newDeck.tag2"
          autocomplete="off"
        />
         <i id="plus-minus" ype="button" v-on:click="addTag(2)" style="font-size:20px" class="fa fa-plus"></i>

         <i id="plus-minus" type="button" v-on:click="removeTag(2)" style="font-size:20px" class="fa fa-minus"></i>

      </div>

      <div class="form-group" v-if="addTag3">
        <label for="title">Tag:</label>
        <input
          type="text"
          class="form-control"
          v-model="newDeck.tag3"
          autocomplete="off"
        />

        <i id="plus-minus" type="button" v-on:click="addTag(3)" style="font-size:20px" class="fa fa-plus"></i>

        <i id="plus-minus" type="button" v-on:click="removeTag(3)" style="font-size:20px" class="fa fa-minus"></i>

      </div>

      <div class="form-group" v-if="addTag4">
        <label for="title">Tag:</label>
        <input
          type="text"
          class="form-control"
          v-model="newDeck.tag4"
          autocomplete="off"
        />

        <i id="plus-minus" type="button" v-on:click="removeTag(4)" style="font-size:20px" class="fa fa-minus"></i>

      </div>

      <label id="make-public" for="public">Make Deck Public?</label>
      <input id="check-box" type="checkbox" v-model="newDeck.public"/>
    
      <div id="add-card">
      <button class="add-card-btn" type="button" v-on:click="saveDeckAddCard()">Add Cards</button>
      

      <br/><input class="add-card-btn" type="submit" value="Save Deck"/><br/>
    </div>
    </form>

</div>
<img id="guy_book" src="../img/guy_on_book.png" alt="guy on book">
  </div>
</template>

<script>
import userService from '../services/UserService';
export default {
  data() {
    return {
      count: 0,
      showNewCardForm: false,
      addTag2: false,
      addTag3: false,
      addTag4: false,
      newCard: {
        question: null,
        answer: null
      },
      newDeck: {
        deckId: 0,
        authorUserId: this.$store.state.user.id
      }
    };
  },
  created() {
    this.newDeck = this.$store.state.deckToCopy;
    this.newDeck.authorUserId = this.$store.state.user.id;
  },
  methods: {
      createDeck() {
          userService
          .createDeck(this.newDeck)
          .then( APIResponse => {
            if (APIResponse.status === 201 || APIResponse.status === 200) {
              this.$router.push('/home');
              this.$router.go(0); 
          }     
         })
         .catch ( APIError => {
          if(APIError.response) {
            this.errorMsg = "Error creating deck: " + APIError.response.statusText;        
          } else if (APIError.request) {
            this.errorMsg = "Server could not be reached.";
          } else {
            this.errorMsg = "Error creating deck.";
          }
      });
            
      },
      saveDeckAddCard(){
          userService
          .createDeck(this.newDeck)
          .then(response =>{
            this.newDeck.deckId = response.data
            this.$router.push(`/modifyDeck/${this.newDeck.deckId}`)
          })
           .catch ( APIError => {
            if(APIError.response) {
              this.errorMsg = "Error creating deck: " + APIError.response.statusText;        
            } else if (APIError.request) {
              this.errorMsg = "Server could not be reached.";
            } else {
              this.errorMsg = "Error creating deck.";
            }
      });
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
            this.newDeck.tag2 = null;
        } else if (num === 3) {
            this.addTag3 = false;
            this.newDeck.tag3 = null;
        } else if (num === 4) {
            this.addTag4 = false;
            this.newDeck.tag4 = null;
        }
      }
  }
    
}
</script>

<style>
.create-deck{
  display: flex;
  justify-content: center;
  align-items: center;
}

#people_books, #guy_book{
  height: 300px;
  opacity: 75%;
}

.createDeck {
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
  margin-left: auto;
  margin-right: auto;
  padding-left: 70px;
  padding-right: 70px;
}

.form-group label, #make-public {
  font-family: 'Roboto', sans-serif;
  color: #5267B1;
  font-size: 30px;
  /* padding-bottom: 100px; */
}

.form-group input { 
  display: flex;
  align-items: center;
  flex-direction: column;
  border: none;
  border-bottom: solid 2px;
  width: 99%;
  background-color: #fdebdf50;
  font-size: 20px;
  overflow: visible;
  margin-top: 5px;
}

#check-box {
width: 30px;
height: 30px;
}

.add-card-btn{
  background-color: #DEE8FE;
  color: #5267B1;
  width: 40%;
  border-radius: 20px;
  border: none;
  box-shadow: 0px 4px 4px rgb(98, 97, 97);
  font-family: "Roboto", sans-serif;
  font-size: 20px;
  height: 35px;
  cursor: pointer;
}

.add-card-btn:hover{
   -webkit-transform: scale(1.1);
          transform: scale(1.1);
    background-color: #ffffff;
}

#add-card{
  padding-top: 10px;
  display: flex;
  justify-content: space-evenly;
}

#plus-minus{
  margin: 10px;
  color: #151275;
}


</style>