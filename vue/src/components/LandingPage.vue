<template>
    <div class="landingPage">
        <div id="images">
        <img id="girlOnChair" src="../img/girl_on_chair.png" alt="girl on chair"/>
        <img id="girlOnDesktop" src="../img/girl_on_desktop.png" alt="girl on desktop"/>
        <img id="guyOnComputer" src="../img/guy_on_computer.png" alt="guy on computer">
        </div>
    <div id="welcome" v-if="$store.state.token == ''">
      <h1>Welcome To Decko</h1>
      <p id="slogan">It's not serious. We make learning fun!<br>
      Join our community.</p>
      <router-link id="register_nav" v-bind:to="{ name: 'register' }">
      <button id="register-btn" type="button">Register</button>
      </router-link>
    </div>

    <div id="welcomeBack" v-if="$store.state.token != ''">
         <h1>Hi, {{user.username}}!</h1>
         <p id="greetings">Welcome, let's get to studying! 
         </p>
         
      <router-link id="profile_nav" v-bind:to="{ name: 'home' }">
      <button id="profile-btn" type="button">My Profile</button>
      </router-link>

    </div>

    </div>

</template>

<script>
export default {
    name: "landing-page",
    computed: {
        user(){
            return this.$store.state.user;
        }
    }
};
</script>

<style>
@import url('https://fonts.googleapis.com/css2?family=Roboto:wght@500&display=swap');
@import url('https://fonts.googleapis.com/css2?family=Nova+Slim&family=Roboto:wght@500&display=swap');

#images{
    display: flex;
    flex-wrap: nowrap;
    padding-top: 100px;
    justify-content: center;
    width: auto
}

#guyOnComputer{
    padding-left: 50px;
    padding-bottom: 25px;

}

#welcome, #welcomeBack{
    margin: auto;
    text-align: center;
}

h1{
    color: #5267B1;
    font-weight: medium;
    font-size: 72px;
    font-family: 'Roboto', sans-serif;
    letter-spacing: .05em;
    
}

#register-btn, #profile-btn{
    background-color: #DEE8FE;
    box-shadow: 3px 2px #acacac;
    font-size: 18px;
    border: none;
    padding: 15px 32px;
    font-family: 'Roboto', sans-serif;
    
}

#register-btn:hover, #profile-btn:hover,
.view-deck-btn:hover, .create-deck-btn:hover{
    -webkit-transform: scale(.9);
        transform: scale(.9);
      background-color: #5267B1;
  color: #e8e8e9;
  border: solid 4px #1e3485;
  border-radius: 3px;
}

#slogan, #greetings{
    font-size: 22px;
    font-family: 'Nova Slim', cursive;
}

@media (max-width: 1024px){
    h1{
        font-size: 4rem;
    }
    #slogan, #greetings{
        font-size: 2rem;
    }
    #guyOnComputer, #girlOnChair{
        display: none;
    }
    #girlOnDesktop{
        width: 500px;
    }
    
}



</style>