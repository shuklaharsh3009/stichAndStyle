<script lang="ts">
  import { onMount } from 'svelte';
  import { supabase } from '../lib/supabase';

  let customers = [];
  let loading = true;
  let showAddModal = false;
  let newCustomer = {
    name: '',
    email: '',
    phone: '',
    address: ''
  };

  async function fetchCustomers() {
    try {
      const { data, error } = await supabase
        .from('customers')
        .select('*')
        .order('created_at', { ascending: false });

      if (error) throw error;
      customers = data;
    } catch (error) {
      console.error('Error fetching customers:', error);
    } finally {
      loading = false;
    }
  }

  async function addCustomer() {
    try {
      const { error } = await supabase
        .from('customers')
        .insert([newCustomer]);

      if (error) throw error;
      
      showAddModal = false;
      newCustomer = { name: '', email: '', phone: '', address: '' };
      await fetchCustomers();
    } catch (error) {
      console.error('Error adding customer:', error);
    }
  }

  onMount(fetchCustomers);
</script>

<div class="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100 p-6">
  <div class="max-w-6xl mx-auto">
    <div class="flex justify-between items-center mb-6">
      <h1 class="text-3xl font-bold text-gray-800">Customers</h1>
      <button
        class="px-4 py-2 bg-primary text-white rounded-md hover:bg-opacity-90 transition-colors duration-200"
        on:click={() => showAddModal = true}
      >
        Add Customer
      </button>
    </div>

    {#if loading}
      <div class="flex justify-center items-center h-64">
        <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
      </div>
    {:else}
      <div class="bg-white rounded-xl shadow-md overflow-hidden">
        <table class="min-w-full">
          <thead>
            <tr class="bg-gray-50">
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Name</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Email</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Phone</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Address</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            {#each customers as customer}
              <tr class="hover:bg-gray-50">
                <td class="px-6 py-4 whitespace-nowrap">{customer.name}</td>
                <td class="px-6 py-4 whitespace-nowrap">{customer.email}</td>
                <td class="px-6 py-4 whitespace-nowrap">{customer.phone}</td>
                <td class="px-6 py-4 whitespace-nowrap">{customer.address}</td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <button class="text-primary hover:text-opacity-80 mr-2">Edit</button>
                  <button class="text-accent hover:text-opacity-80">Delete</button>
                </td>
              </tr>
            {/each}
          </tbody>
        </table>
      </div>
    {/if}
  </div>

  {#if showAddModal}
    <div class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center">
      <div class="bg-white rounded-lg p-8 max-w-md w-full">
        <h2 class="text-2xl font-bold mb-4">Add New Customer</h2>
        <form on:submit|preventDefault={addCustomer}>
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-700">Name</label>
              <input
                type="text"
                bind:value={newCustomer.name}
                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring focus:ring-primary focus:ring-opacity-50"
                required
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700">Email</label>
              <input
                type="email"
                bind:value={newCustomer.email}
                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring focus:ring-primary focus:ring-opacity-50"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700">Phone</label>
              <input
                type="tel"
                bind:value={newCustomer.phone}
                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring focus:ring-primary focus:ring-opacity-50"
              />
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700">Address</label>
              <textarea
                bind:value={newCustomer.address}
                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring focus:ring-primary focus:ring-opacity-50"
                rows="3"
              ></textarea>
            </div>
          </div>
          <div class="mt-6 flex justify-end space-x-3">
            <button
              type="button"
              class="px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50"
              on:click={() => showAddModal = false}
            >
              Cancel
            </button>
            <button
              type="submit"
              class="px-4 py-2 bg-primary text-white rounded-md hover:bg-opacity-90"
            >
              Add Customer
            </button>
          </div>
        </form>
      </div>
    </div>
  {/if}
</div>