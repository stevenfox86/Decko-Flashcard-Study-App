<template>
  <div class="studyDeck">

    
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

      <div class="form-group">
        <h2 class="print-deck-name">{{deck.deckName}}</h2>
    
      </div>
    <div class="picture-card-box">  
 <div id="card-box">
   <div class="study-cancel-btns">
      <button type="button" class="add-card-btn" v-on:click="cancelUpdateDeck()">Go Back</button>
      <button v-if="deck.cards.length > 0" type="button" class="add-card-btn" v-on:click="studyCard(deck.deckId)">Start studying</button>
   </div>
   
   
    <div v-for="card in deck.cards" v-bind:key="card.cardId">
    
        <div id="question-answer-star" class="card-display">
        <div id="card-question" class="card-question"  >{{ card.question }}</div>
         <div id="card-answer" class="card-answer" >{{ card.answer }}</div>
         
         <div id="card-star" class="star">
            <i id="stars" v-if="card.statusId == 1" class="fa fa-star" style= "color: #b3b6c9"></i> 
            <i id="stars" v-if="card.statusId == 2" class="fa fa-star" style= "color: #953437"></i> 
            <i id="stars" v-if="card.statusId == 3" class="fa fa-star" style= "color: #ffc36a"></i> 
            <i id="stars" v-if="card.statusId == 4" class="fa fa-star" style= "color: #788752"></i> 
            <i id="stars" v-if="card.statusId != 1 && card.statusId !=2 && card.statusId != 3 && card.statusId !=4" class="fa fa-star"></i> 
         </div>
      </div>   
    </div>

    </div>
    <div class="study-deck-pictures">
    <img class="cool-pics" src="../img/people-outside.jpg" alt="people-outside">
    
    </div>
    </div>
  </div>

</template>

<script>
 import userService from '../services/UserService';

export default {
  data() {
    return {
      random: 0,
      editCardId: 0,
      deck: {
        cards: []
      },
      newCard: {
        question: null,
        answer: null
      }
    };
  },
  methods: {
      cancelUpdateDeck(){
        this.$router.push('/home');
      },
      studyCard(deckId){
        this.$router.push(`/studyDeck/${deckId}/cards`);
      },
    getStatus() { 
      
      this.deck.cards.forEach( card => 
        userService
        .getCardStatusId(this.$store.state.user.id, card.cardId)
        .then(response => {
           card.statusId = response.data;
        })
        .catch(error => {
        if (error.response.status == 404) {
          this.$router.push("/not-found");
        }
      })
      );

      }

},
created(){
      userService
      .getDeckByDeckId(this.$route.params.deckId)
      .then(response => {
        this.deck = response.data;
        this.getStatus();
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

.studyDeck{
  padding-top: 100px;
  padding-left: 15px;
}

#stars {
  font-size: 40px;
}

#stars:hover {
  cursor: default;
}

#card-box {
  width: 850px;
}

.study-cancel-btns {
  display: flex;
  justify-content: space-between;
  padding-bottom: 30px;
}

#question-answer-star {
  width: 850px;
}

#card-star {
  width: 200px;
  text-align: center;
}

.picture-card-box {
  display: flex;
  
}

.study-deck-pictures {
  display: flex;
  flex-direction: column;

  width: 50%;
  align-items: center;
  position: fixed;
  margin-left: 925px;
}

.cool-pics {
  margin-top: 200px;
  height: 450px;
  width: 520px;
  margin-bottom: 100px;
  opacity: 75%;
}

.print-deck-name {
  padding-bottom: 10px;
}


</style>