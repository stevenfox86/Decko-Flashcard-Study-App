import Vue from 'vue'
import Router from 'vue-router'
import Home from '../views/Home.vue'
import Login from '../views/Login.vue'
import Logout from '../views/Logout.vue'
import Register from '../views/Register.vue'
import store from '../store/index'
import Landing from '../views/Landing.vue'
import ModifyDeck from '../views/ModifyDeck.vue'
import MyFavoriteDecks from '../views/MyFavoriteDecks.vue'
import AllMyDecks from '../views/AllMyDecks.vue'
import NewDeck from '../views/NewDeck.vue'
import StudySession from '../views/StudySession.vue'
import ShowSearchResults from '../views/ShowSearchResults.vue'
import StudyFlashCards from '../views/StudyFlashCards.vue'
import NotFound from '../views/NotFound.vue'

Vue.use(Router)

/**
 * The Vue Router is used to "direct" the browser to render a specific view component
 * inside of App.vue depending on the URL.
 *
 * It also is used to detect whether or not a route requires the user to have first authenticated.
 * If the user has not yet authenticated (and needs to) they are redirected to /login
 * If they have (or don't need to) they're allowed to go about their way.
 */

const router = new Router({
  mode: 'history',
  base: process.env.BASE_URL,
  routes: [
    {
      path: "/not-found",
      name: "NotFound",
      component: NotFound
    },
    {
      path: '/',
      name: 'landing',
      component: Landing,
      meta: {
        requiresAuth: false
      }
    },
    {
      path: '/home',
      name: 'home',
      component: Home,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: "/login",
      name: "login",
      component: Login,
      meta: {
        requiresAuth: false
      }
    },
    {
      path: "/logout",
      name: "logout",
      component: Logout,
      meta: {
        requiresAuth: false
      }
    },
    {
      path: "/register",
      name: "register",
      component: Register,
      meta: {
        requiresAuth: false
      }
    },
    {
      path: "/modifyDeck/:deckId",
      name: "modify-deck",
      component: ModifyDeck,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: "/favoriteDecks",
      name: "favorite-decks",
      component: MyFavoriteDecks,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: "/allDecks",
      name: "all-decks",
      component: AllMyDecks,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: "/createDeck",
      name: "create-deck",
      component: NewDeck,
      meta: {
        requiresAuth: true
      }
    },
    {
      path: "/studyDeck/:deckId",
      name: "study-deck",
      component: StudySession,
      meta: {
        requiresAuth: false
      }
    },
    {
      path: "/studyDeck/:deckId/cards",
      name: "study-flashCards",
      component: StudyFlashCards,
      meta: {
        requiresAuth: false
      }
    },
    {
      path: "/searchResults",
      name: "search-results",
      component: ShowSearchResults,
      meta: {
        requiresAuth: false
      }
    }
  ]
})

router.beforeEach((to, from, next) => {
  // Determine if the route requires Authentication
  const requiresAuth = to.matched.some(x => x.meta.requiresAuth);

  // If it does and they are not logged in, send the user to "/login"
  if (requiresAuth && store.state.token === '') {
    next("/login");
  } else {
    // Else let them go to their next destination
    next();
  }
});

export default router;
