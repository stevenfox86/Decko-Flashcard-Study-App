<template>
<div id="login_body">
  <div id="login_loginPage" class="text-center">
    <form class="form-signin" @submit.prevent="login">
      <h2 id="login-title" class="h3 mb-3 font-weight-normal">Login</h2>
      <div
        class="alert alert-danger"
        role="alert"
        v-if="invalidCredentials"
      >Invalid username and password!</div>
      <div
        class="alert alert-success"
        role="alert"
        v-if="this.$route.query.registration"
      >Thank you for registering, please sign in.</div>
      <div id="loginUser">
      <label for="username" class="sr-only">Username</label><br/>
      <input
        type="text"
        id="username"
        class="form-control"
        placeholder="Username"
        v-model="user.username"
        required
        autofocus
      />
      <br>
      <label for="password" class="sr-only">Password</label><br/>
      <input
        type="password"
        id="password"
        class="form-control"
        placeholder="Password"
        v-model="user.password"
        required
      />
      <br>
      
      </div>
      <div id="sign-in-btn"><button id="signIn_btn" type="submit">Sign in</button></div>
          
            </form>
    </div>
        <div id="register_loginPage">
      <h2>Register</h2>
  
      <router-link :to="{ name: 'register' }">
        <button id="needAccount_btn" type="button">Need an Account?</button>
        </router-link>
        </div>

  
  </div>
</template>

<script>
import authService from "../services/AuthService";

export default {
  name: "login",
  components: {},
  data() {
    return {
      user: {
        username: "",
        password: "",
      },
      invalidCredentials: false
    };
  },
  methods: {
    login() {
      authService
        .login(this.user)
        .then(response => {
          if (response.status == 200) {
            this.$store.commit("SET_AUTH_TOKEN", response.data.token);
            this.$store.commit("SET_USER", response.data.user);
            this.$router.push("/");
          }
        })
        .catch(error => {
          const response = error.response;

          if (response.status === 401) {
            this.invalidCredentials = true;
          }
        });
    }
  }
};
</script>

<style>

@import url('https://fonts.googleapis.com/css2?family=Roboto:wght@500&display=swap');

#login_body {

  display: flex;
  padding: 150px;
  justify-content: center;
  justify-content:space-around;
  align-content: center;
}

#login-title {
  text-align: center;
 padding-bottom: 30px;
}

#needAccount_btn, #signIn_btn {
   background-color: #DEE8FE;
    box-shadow: 3px 2px #acacac;
    font-size: 18px;
    border: none;
    padding: 15px 32px;
    font-family: 'Roboto', sans-serif;
    justify-content: center;  
}

#needAccount_btn:hover, #signIn_btn:hover, #haveAccount_btn:hover, #register_btn:hover {
-webkit-transform: scale(.9);
        transform: scale(.9);
      background-color: #5267B1;
  color: #e8e8e9;
  border: solid 4px #1e3485;
  border-radius: 3px;
}

#sign-in-btn {
  display: flex;
  justify-items: center;
  justify-content: center;
}

#signIn_btn {
  margin: 10px;
}

#username, #password {
  margin-bottom: 10px;
}

#login_loginPage {
   border: 3px;
  border-style: solid;
  border-color: #5267B1;
  border-radius: 15px;
  background-color: #f1cac481;
  width: 571px;
  height: 476px;
  left: 792px;
  top: 279px;
  display: flex;
  align-items: center;
  flex-direction: column;
  margin-right: 20px;
 
}

#register_loginPage {
 
  border: 3px;
  border-style: solid;
  border-color: #5267B1;
  border-radius: 15px;
  background-color: #f1cac481;
  width: 571px;
  height: 476px;
  left: 792px;
  top: 279px;
  display: flex;
  align-items: center;
  flex-direction: column;
  margin-left: 20px;

}



#loginUser input {
  justify-content: space-between;
}



</style>
