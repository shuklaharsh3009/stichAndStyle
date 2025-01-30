<script lang="ts">
  import { onMount } from 'svelte';
  import { user } from '../lib/stores';
  import { supabase } from '../lib/supabase';
  import { push } from 'svelte-spa-router';
  
  let customers = [];
  let measurements = [];
  let stats = {
    totalCustomers: 0,
    pendingOrders: 0,
    completedOrders: 0
  };
  let loading = true;

  async function fetchDashboardData() {
    try {
      // Fetch customers
      const { data: customersData } = await supabase
        .from('customers')
        .select('*')
        .order('created_at', { ascending: false })
        .limit(5);

      // Fetch measurements
      const { data: measurementsData } = await supabase
        .from('measurements')
        .select('*, customers(name)')
        .order('created_at', { ascending: false })
        .limit(5);

      // Fetch stats
      const { count: totalCustomers } = await supabase
        .from('customers')
        .select('*', { count: 'exact', head: true });

      const { count: pendingOrders } = await supabase
        .from('orders')
        .select('*', { count: 'exact', head: true })
        .eq('status', 'pending');

      const { count: completedOrders } = await supabase
        .from('orders')
        .select('*', { count: 'exact', head: true })
        .eq('status', 'completed');

      customers = customersData || [];
      measurements = measurementsData || [];
      stats = {
        totalCustomers: totalCustomers || 0,
        pendingOrders: pendingOrders || 0,
        completedOrders: completedOrders || 0
      };
    } catch (error) {
      console.error('Error fetching dashboard data:', error);
    } finally {
      loading = false;
    }
  }

  async function handleLogout() {
    await supabase.auth.signOut();
    push('/login');
  }

  onMount(fetchDashboardData);
</script>

<div class="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100">
  <nav class="bg-primary shadow-lg">
    <div class="container mx-auto px-4 py-3">
      <div class="flex justify-between items-center">
        <div class="flex items-center space-x-4">
          <h1 class="text-2xl font-bold text-white">Stitch & Style</h1>
          <div class="hidden md:flex space-x-4">
            <a href="#/dashboard" class="text-white hover:text-gray-200">Dashboard</a>
            <a href="#/customers" class="text-white hover:text-gray-200">Customers</a>
            <a href="#/measurements" class="text-white hover:text-gray-200">Measurements</a>
            <a href="#/orders" class="text-white hover:text-gray-200">Orders</a>
          </div>
        </div>
        <div class="flex items-center space-x-4">
          <span class="text-white">{$user?.email}</span>
          <button 
            on:click={handleLogout}
            class="px-4 py-2 bg-white text-primary rounded-md hover:bg-gray-100 transition-colors duration-200"
          >
            Logout
          </button>
        </div>
      </div>
    </div>
  </nav>

  <main class="container mx-auto py-8 px-4">
    {#if loading}
      <div class="flex justify-center items-center h-64">
        <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
      </div>
    {:else}
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div class="bg-white p-6 rounded-xl shadow-md transform hover:scale-105 transition-transform duration-200">
          <h3 class="text-lg font-semibold mb-2 text-gray-700">Total Customers</h3>
          <p class="text-4xl font-bold text-primary">{stats.totalCustomers}</p>
        </div>
        <div class="bg-white p-6 rounded-xl shadow-md transform hover:scale-105 transition-transform duration-200">
          <h3 class="text-lg font-semibold mb-2 text-gray-700">Pending Orders</h3>
          <p class="text-4xl font-bold text-accent">{stats.pendingOrders}</p>
        </div>
        <div class="bg-white p-6 rounded-xl shadow-md transform hover:scale-105 transition-transform duration-200">
          <h3 class="text-lg font-semibold mb-2 text-gray-700">Completed Orders</h3>
          <p class="text-4xl font-bold text-green-600">{stats.completedOrders}</p>
        </div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <div class="bg-white p-6 rounded-xl shadow-md">
          <div class="flex justify-between items-center mb-6">
            <h2 class="text-xl font-bold text-gray-800">Recent Customers</h2>
            <a href="#/customers" class="text-primary hover:text-opacity-80">View All →</a>
          </div>
          <div class="overflow-x-auto">
            <table class="min-w-full">
              <thead>
                <tr class="border-b border-gray-200">
                  <th class="text-left py-3 px-4 font-semibold text-gray-600">Name</th>
                  <th class="text-left py-3 px-4 font-semibold text-gray-600">Phone</th>
                  <th class="text-left py-3 px-4 font-semibold text-gray-600">Email</th>
                </tr>
              </thead>
              <tbody>
                {#each customers as customer}
                  <tr class="border-b border-gray-100 hover:bg-gray-50">
                    <td class="py-3 px-4">{customer.name}</td>
                    <td class="py-3 px-4">{customer.phone}</td>
                    <td class="py-3 px-4">{customer.email}</td>
                  </tr>
                {/each}
              </tbody>
            </table>
          </div>
        </div>

        <div class="bg-white p-6 rounded-xl shadow-md">
          <div class="flex justify-between items-center mb-6">
            <h2 class="text-xl font-bold text-gray-800">Recent Measurements</h2>
            <a href="#/measurements" class="text-primary hover:text-opacity-80">View All →</a>
          </div>
          <div class="overflow-x-auto">
            <table class="min-w-full">
              <thead>
                <tr class="border-b border-gray-200">
                  <th class="text-left py-3 px-4 font-semibold text-gray-600">Customer</th>
                  <th class="text-left py-3 px-4 font-semibold text-gray-600">Date</th>
                  <th class="text-left py-3 px-4 font-semibold text-gray-600">Details</th>
                </tr>
              </thead>
              <tbody>
                {#each measurements as measurement}
                  <tr class="border-b border-gray-100 hover:bg-gray-50">
                    <td class="py-3 px-4">{measurement.customers?.name}</td>
                    <td class="py-3 px-4">{new Date(measurement.created_at).toLocaleDateString()}</td>
                    <td class="py-3 px-4">
                      <button class="text-primary hover:text-opacity-80">View</button>
                    </td>
                  </tr>
                {/each}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    {/if}
  </main>
</div>