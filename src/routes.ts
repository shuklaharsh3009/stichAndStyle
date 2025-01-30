import Login from './routes/Login.svelte';
import Dashboard from './routes/Dashboard.svelte';
import Customers from './routes/Customers.svelte';
import Measurements from './routes/Measurements.svelte';

export const routes = {
  '/': Login,
  '/login': Login,
  '/dashboard': Dashboard,
  '/customers': Customers,
  '/measurements': Measurements,
};