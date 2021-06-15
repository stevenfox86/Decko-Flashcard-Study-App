<template>
<div id="register_body">

   <div id="login_registerPage">
  <h2>Login</h2>
  <router-link v-bind:to="{ name: 'login' }">
    <button id="haveAccount_btn" type="button">Have an Account?</button>
  </router-link>
</div >

  <div id="register_registerPage" class="text-center">
    <form class="form-register" @submit.prevent="register">
      <h2 id="register-title" class="h3 mb-3 font-weight-normal">Register</h2>

      <div class="alert alert-danger" role="alert" v-if="registrationErrors">
        {{ registrationErrorMsg }}
      </div>

      <div id="registerUser">
      <label for="username" class="sr-only">Username</label><br/>
      <input
        type="text"
        id="username"
        class="form-control"
        placeholder="Username"
        v-model="user.username"
        required
        autofocus
      /> <br>
      <label for="password" class="sr-only">Password</label><br/>
      <input
        type="password"
        id="password"
        class="form-control"
        placeholder="Password"
        v-model="user.password"
        required
      /> <br>
      <label for="confirm password" class="sr-only">Confirm Password</label><br/>
        <input
        type="password"
        id="confirmPassword"
        class="form-control"
        placeholder="Confirm Password"
        v-model="user.confirmPassword"
        required
      /><br>
      </div>
      <div id="new-register-btn">
        <button id="register_btn" class="btn btn-lg btn-primary btn-block" type="submit">
        Register
      </button>
      </div>
      
    </form>
</div>
 
  </div>

</template>

<script>
import authService from '../services/AuthService';

export default {
  name: 'register',
  data() {
    return {
      user: {
        username: '',
        password: '',
        confirmPassword: '',
        role: 'user',
      },
      registrationErrors: false,
      registrationErrorMsg: 'There were problems registering this user.',
    };
  },
  methods: {
    register() {
      if (this.user.password != this.user.confirmPassword) {
        this.registrationErrors = true;
        this.registrationErrorMsg = 'Password & Confirm Password do not match.';
      } else {
        authService
          .register(this.user)
          .then((response) => {
            if (response.status == 201) {
              this.$router.push({
                path: '/login',
                query: { registration: 'success' },
              });
            }
          })
          .catch((error) => {
            const response = error.response;
            this.registrationErrors = true;
            if (response.status === 400) {
              this.registrationErrorMsg = 'Bad Request: Validation Errors';
            }
          });
      }
    },
    clearErrors() {
      this.registrationErrors = false;
      this.registrationErrorMsg = 'There were problems registering this user.';
    },
  },
};
</script>


<style>
@import url('https://fonts.googleapis.com/css2?family=Roboto:wght@500&display=swap');

h2 {
  font-family: 'Roboto', sans-serif;
  color: #5267B1;
  font-size: 36px;
  padding-bottom: 100px;
}

#register-title {
  text-align: center;
  padding-bottom: 10px;
}
#haveAccount_btn, #register_btn {
   background-color: #DEE8FE;
    box-shadow: 3px 2px #acacac;
    font-size: 18px;
    border: none;
    padding: 15px 32px;
    font-family: 'Roboto', sans-serif;
    
}

#resister_btn {
  margin: 10px;
}

#new-register-btn {
  display: flex;
  justify-items: center;
  justify-content: center;
}

#register_body{
  display: flex;
  flex-direction: row;
  padding: 150px;
  align-content: center;
  justify-content: space-around;
}

#login_registerPage{
  border: 3px;
  border-style: solid;
  border-color: #5267B1;
  border-radius: 15px;
  background-color: #f1cac481;
  width: 571px;
  height: 476px;

  display: flex;
  flex-direction: column;
  align-items: center;
  margin-right: 20px;
}


#register_registerPage {
  border: 3px;
  border-style: solid;
  border-color: #5267B1;
  border-radius: 15px;
  background-color: #f1cac481;
  width: 571px;
  height: 476px;
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-left: 20px;
}



.sr-only, #registerUser{
  font-size: 20px;
  font-family: 'Roboto', sans-serif;
  margin-bottom: 20px;
}

#registerUser {
  justify-self: center;
  padding: 20px;
}

</style>
