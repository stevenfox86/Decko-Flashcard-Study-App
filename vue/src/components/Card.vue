<template>
  
<!-- <div class="card-front" v-if="! isFlipped">
           
            <div class="front-card" v-if="! isFlipped" v-on:click="toggleCard()">{{card.question}}</div>
          </div>
          <h2 class="question-answer" v-if="isFlipped">Answer</h2>
          <div class="back-card" v-if="isFlipped" v-on:click="toggleCard()">{{card.answer}}</div> -->


  <div class="study-window">
    <div class="study-cards-bts">
  <div class="card-container">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">




<div v-for="card in deck.cards" v-bind:key="card.cardId">
  
   <transition name="flip">
      <div v-bind:key="isFlipped" id="card-display" v-if="card.cardId == currentCardId" v-on:click="toggleCard()">
        <h2 v-if="!isFlipped" class="question-answer" >Question</h2>
         <h2 v-if="isFlipped" class="question-answer" >Answer</h2>
          <p class="question-answer-content">
            {{isFlipped ? card.answer : card.question}}
          </p>
        

        



      </div>

      </transition>
<div class="study-functions" v-if="card.cardId == currentCardId">
          <i id="arrow" class="fa fa-arrow-left" type="button" v-on:click="displayPreviousCard(index)"></i>

          <div class="stars">
            
            <i id="star-1" v-if="card.statusId != 4" v-on:click="updateCardStatus(4)" class="fa fa-star"  style="font-size:45px; color: #788752"></i>
            <i id="highlightStar-1" v-if="card.statusId == 4" class="fa fa-star"  style="font-size:45px; color: #788752"></i>

            <i id="star-2" v-if="card.statusId != 3" v-on:click="updateCardStatus(3)" class="fa fa-star" style= "font-size:45px; color: #ffc36a"></i>
            <i id="highlightStar-2" v-if="card.statusId == 3" class="fa fa-star" style= "font-size:45px; color: #ffc36a"></i>

            <i id="star-3" v-if="card.statusId != 2" v-on:click="updateCardStatus(2)" class="fa fa-star" style= "font-size:45px; color: #953437"></i> 
            <i id="highlightStar-3" v-if="card.statusId == 2" class="fa fa-star" style= "font-size:45px; color: #953437"></i> 

         </div>

         <i id="arrow" class="fa fa-arrow-right" type="button" v-on:click="displayNextCard(index)"></i>
</div>
</div>


      
  
  <div class="end-session-container">
    <button class="add-card-btn" type="button" v-on:click=" endStudySession(); openPopUp();" id="btn">End Study Session</button>
  </div>
 </div>
 <div class="modal" v-if="show">
    <div class="modal__backdrop"/>

    <div class="modal__dialog">
      <div class="modal__body">
        <slot name="body" />
        
        <div class="results-box">
        <h2 id="results">Great Job! Here Are Your Results</h2>
        <h3>Deck Name: {{deck.deckName}}</h3>

        <div class="results-stars">
        <i id="star-1" class="fa fa-star" style="font-size:35px; color: #788752"> Correct: {{greenCount}}</i>
        <br/>
        <i id="star-2" class="fa fa-star" style= "font-size:35px; color: #953437"> Incorrect: {{redCount}}</i>
        <br/>
        <i id="star-3" class="fa fa-star" style= "font-size:35px; color: #ffc36a"> Needs studying: {{yellowCount}}</i>
        <br/>
        <i id="star-4" class="fa fa-star" style= "font-size:35px; color: #b3b6c9"> Unanswered: {{undefinedCount}}</i>
        <br/>

        </div>
        <button id="okay-btn" class="add-card-btn" type="button" v-on:click="goBackToDecks(deck.deckId)"> Cheers! </button>

      </div>
      </div>
    </div>
  </div>

  
  </div>
  <div class="study-images-container">
    <img class="study-image" src="../img/open-book.png" alt="open-book">
    <img class="study-image" src="../img/girl-juggling.png" alt="girl-juggling">
    <img class="study-image" src="../img/checklist-blue.png" alt="checklist-blue">
   </div> 
  </div>
</template>

<script>
 import userService from '../services/UserService';

export default {
    data(){
        return{
            isFlipped: false,
            deck: {},
            currentCardId: 0,
            index: 0,
            card: {},
            greenCount: 0,
            yellowCount: 0,
            redCount: 0,
            undefinedCount: 0,
            show: false
        }
    },
    created(){
      userService
      .getDeckByDeckId(this.$route.params.deckId)
      .then(response => {
        this.deck = response.data;
        this.currentCardId = this.deck.cards[0].cardId;
      })
       .catch(error => {
        if (error.response.status == 404) {
          this.$router.push("/not-found");
        }
      });
      
    },
    methods: {

        toggleCard(){
            if(this.isFlipped == false){
                this.isFlipped = true;
            }else{
                this.isFlipped = false;
            }
        },

        displayNextCard(index){
          if (index != this.deck.cards.length -1) {
            this.index = index + 1;
            this.currentCardId = this.deck.cards[this.index].cardId;
            this.isFlipped = false;
          }
        },
        displayPreviousCard(index){
          if (index != 0) {
            this.index = index - 1;
            this.currentCardId = this.deck.cards[this.index].cardId;
            this.isFlipped = false;
          }   
        },
        updateCardStatus(number){
            if(number == 4){
                this.deck.cards[this.index].statusId = 4;
            }else if (number == 3){
                this.deck.cards[this.index].statusId = 3;
            }else if (number == 2){
                this.deck.cards[this.index].statusId = 2;
            }
                userService
                .updateCardStatusId(this.$store.state.user.id, this.currentCardId, number);            
        },

        endStudySession() {
           
             this.deck.cards.forEach( card => {
                   if(card.statusId == 4) {
                   this.greenCount++;
               } else if(card.statusId == 3) {
                   this.yellowCount++;
               } else if (card.statusId == 2) {
                   this.redCount++;
               } else if (card.statusId == 0) {
                   this.undefinedCount++;
               }
        })
         },

       openPopUp() {
      this.show = true;
      document.querySelector("body").classList.add("overflow-hidden");
    },

    goBackToDecks(deckId) {
        this.$router.push(`/studyDeck/${deckId}`);
    }
    }
}
</script>

<style>


  .flip-enter-active {
    transition: all .8s ease;
  }

  .flip-leave-active {
    display: none;
  }
  
  .flip-enter, .flip-leave {
    transform: rotateY(180deg);
    opacity: 50%;
  
  }

.card-container{
    margin: 100px;
    margin-bottom: 10px;
}
#star-1, #star-2, #star-3{
    border: solid;
    border-radius: 45px;
    border-color: #ebefff00;
}
#highlightStar-1{
    border: solid;
    border-radius: 45px;
    border-color:#788752;
}
#highlightStar-2{
    border: solid;
    border-radius: 45px;
    border-color:#ffc36a;
}

#highlightStar-3{
    border: solid;
    border-radius: 45px;
    border-color:#953437;
}

.modal {
  position: fixed;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  z-index: 9;
  overflow-x: hidden;
  overflow-y: auto;
}

  .modal__backdrop {
    position: fixed;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    background-color: rgba(0, 0, 0, 0.603);
    z-index: 1;
  }

  .modal__dialog {
    position: relative;
    width: 600px;
    background-color: #ffffff;
    border-radius: 10px;
    border: solid 4px;
    border-color: #5267b1;

    margin: 50px auto;
    display: flex;
    flex-direction: column;
    z-index: 2;
  }

  .study-cards-bts {
    display: flex;
    justify-content: center;
    float: center;
  }

  #arrow {
    font-size: 35px;
    color: #151275;
    margin-right: 80px;
    margin-left: 80px;
  }
  #card-display {
    text-align: center;
    flex-direction: column;
    height: 350px;
    border: solid;
    border-color: #5267b1;
    border-radius: 15px;
    background-color: #eef1fd;
    width: 800px;
  }
    .study-functions {
    display: flex;
    flex-direction: row;
    justify-items: space-evenly;
    align-items: baseline;
    padding-bottom: 30px;
    justify-content: center;
    margin-top: 5px;
  }
  
  .front-card, .back-card {
    font-size: 25px;
    text-align: center;
    padding-right: 30px;
    padding-left: 30px;
  }

  .question-answer {
    padding-bottom: 0px;
    margin-bottom: 0px;
    font-size: 30px;
  }

  .end-session-container {
    display: flex;
    align-content: center;
    justify-content: center;
    
  }

  #results {
    padding-bottom: 0%;
  }

  .results-box {
    display: flex;
    flex-direction: column;
    align-items: center;
  }
  
  #okay-btn {
    /* padding-top: 20px;
    padding-bottom: 20px; */
    margin-top: 20px;
    margin-bottom: 45px;
  }

  .study-images-container {
    display: flex;
    justify-content: center;
  }

  .study-image {
    height: 350px;
    opacity: .75;
  }

  .question-answer-content {
    font-size: 21px;
    margin-top: 90px;
  }
  
</style>