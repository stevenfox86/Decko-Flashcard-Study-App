<template>
  <div id="app">
    <div id="nav">
     
        <!-- <img id="icon" src="../src\img\logo.png" alt="lightning bolt"> -->
        <router-link id="decko_nav" v-bind:to="{ name: 'landing' }" v-on:click.native="resetWordToSearch">Decko &nbsp;</router-link>
        
 
      <div class="white-space"></div>
     
      <form class="search-nav" v-if="$route.path!=='/searchResults'" v-on:submit.prevent="showResults">

        <select class="search_nav" v-model="option" name = "dropdown">
            <option value = "Public Decks">Public Decks</option>
            <option v-if="$store.state.token != ''" value = "My Decks" selected>My Decks</option>
            <option v-if="$store.state.token != ''" value = "Favorite Decks">Favorite Decks</option>            
         </select>&nbsp;
       
        <input style="background-image: url(https://img.icons8.com/ios-glyphs/30/000000/search.png); 
        background-size: 18px; background-repeat: no-repeat; padding: 2px 2px 2px 18px;"
        id="search-box" v-model="wordToSearch" type="text"  placeholder="Search" />
      
      </form>&nbsp;

      <router-link id="login_nav" v-bind:to="{ name: 'login' }" v-if="$store.state.token == ''" v-on:click.native="resetWordToSearch">
        Login | 
      </router-link>
      <router-link id="register_nav" v-bind:to="{ name: 'register' }" v-if="$store.state.token == ''" v-on:click.native="resetWordToSearch"> 
       Register 
      </router-link>
      <router-link id="home_nav" v-bind:to="{ name: 'home' }" v-if="$store.state.token != ''" v-on:click.native="resetWordToSearch"> 
       My Profile | 
      </router-link>
      <router-link id="logout_nav" v-bind:to="{ name: 'logout' }" v-if="$store.state.token != ''" v-on:click.native="resetWordToSearch"> Logout</router-link>
    <div class="white-space-2"></div>

    </div>
       <router-view />
  </div>

   </template>

<script>

export default {
  
  data() {
    return {
      wordToSearch: "",
      option: null
    }
  },
  created() {
    this.option = this.$store.state.deckOption;
  },
  methods: {
    showResults() {
        this.$store.commit("SET_DECK_OPTION", this.option);
        this.$store.commit("SET_SEARCH_WORD", this.wordToSearch);
        this.$router.push("/searchResults");  
    },
    resetWordToSearch() {
      this.wordToSearch = ""; 
    }
  }
}
</script>


<style>
@import url('https://fonts.googleapis.com/css2?family=Roboto:wght@500&display=swap');

  #login_nav, #register_nav, #decko_nav, #logout_nav, #home_nav{
      text-decoration: none;
      color: black;
      font-family: 'Roboto', sans-serif;
      padding: 5px;
    
    }

  #decko_nav{
    font-size: 25px;
  }

  #decko_nav:hover,
  #login_nav:hover, #register_nav:hover, #decko_nav:hover, #logout_nav:hover, #home_nav:hover{
    -webkit-transform: scale(1.1);
      transform: scale(1.1);
      color: #151275;
  }

   #icon{
   
    margin-left: 20px;
    height: 40px;
    width: 40px;
  }

  #nav{
    background-color: #DDEFFD;
    position: fixed;
    width: 100%;
    height: 50px;
    left: 0px;
    top: 0px;
    padding-top: 5px;
    padding-bottom: 5px;
    display: flex;
    align-items: center;
    padding-right: 30px;
    

  } 

  .search_nav {
    background-color: #ebefff;
    border-radius: 5px;
  }

  
  .white-space {
    display: flex;
    flex-grow: 2;
  }

  .white-space-2 {
    padding: 20px;
  }


  

  #register_nav {
    padding-left: 3px;
  }  

  #search-box {
    border-radius: 5px;

  }
  

</style>
