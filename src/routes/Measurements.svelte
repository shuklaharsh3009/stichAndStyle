<script lang="ts">
  import { onMount } from 'svelte';
  import { supabase } from '../lib/supabase';

  let measurements = [];
  let customers = [];
  let loading = true;
  let showAddModal = false;
  let newMeasurement = {
    customer_id: '',
    chest: '',
    waist: '',
    hips: '',
    shoulder: '',
    sleeve_length: '',
    inseam: '',
    notes: ''
  };

  async function fetchData() {
    try {
      const [measurementsResponse, customersResponse] = await Promise.all([
        supabase
          .from('measurements')
          .select('*, customers(name)')
          .order('created_at', { ascending: false }),
        supabase
          .from('customers')
          .select('id, name')
          .order('name')
      ]);

      if (measurementsResponse.error) throw measurementsResponse.error;
      if (customersResponse.error) throw customersResponse.error;

      measurements = measurementsResponse.data;
      customers = customersResponse.data;
    } catch (error) {
      console.error('Error fetching data:', error);
    } finally {
      loading = false;
    }
  }

  async function addMeasurement() {
    try {
      const { error } = await supabase
        .from('measurements')
        .insert([newMeasurement]);

      if (error) throw error;
      
      showAddModal = false;
      newMeasurement = {
        customer_id: '',
        chest: '',
        waist: '',
        hips: '',
        shoulder: '',
        sleeve_length: '',
        inseam: '',
        notes: ''
      };
      await fetchData();
    } catch (error) {
      console.error('Error adding measurement:', error);
    }
  }

  onMount(fetchData);
</script>

<div class="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100 p-6">
  <div class="max-w-6xl mx-auto">
    <div class="flex justify-between items-center mb-6">
      <h1 class="text-3xl font-bold text-gray-800">Measurements</h1>
      <button
        class="px-4 py-2 bg-primary text-white rounded-md hover:bg-opacity-90 transition-colors duration-200"
        on:click={() => showAddModal = true}
      >
        Add Measurement
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
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Customer</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Chest</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Waist</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Hips</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            {#each measurements as measurement}
              <tr class="hover:bg-gray-50">
                <td class="px-6 py-4 whitespace-nowrap">{measurement.customers?.name}</td>
                <td class="px-6 py-4 whitespace-nowrap">{new Date(measurement.created_at).toLocaleDateString()}</td>
                <td class="px-6 py-4 whitespace-nowrap">{measurement.chest}</td>
                <td class="px-6 py-4 whitespace-nowrap">{measurement.waist}</td>
                <td class="px-6 py-4 whitespace-nowrap">{measurement.hips}</td>
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
        <h2 class="text-2xl font-bold mb-4">Add New Measurement</h2>
        <form on:submit|preventDefault={addMeasurement}>
          <div class="space-y-4">
            <div>
              <label class="block text-sm font-medium text-gray-700">Customer</label>
              <select
                bind:value={newMeasurement.customer_id}
                class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring focus:ring-primary focus:ring-opacity-50"
                required
              >
                <option value="">Select a customer</option>
                {#each customers as customer}
                  <option value={customer.id}>{customer.name}</option>
                {/each}
              </select>
            </div>
            <div class="grid grid-cols-2 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700">Chest</label>
                <input
                  type="number"
                  bind:value={newMeasurement.chest}
                  class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring focus:ring-primary focus:ring-opacity-50"
                  step="0.1"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700">Waist</label>
                <input
                  type="number"
                  bind:value={newMeasurement.waist}
                  class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring focus:ring-primary focus:ring-opacity-50"
                  step="0.1"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700">Hips</label>
                <input
                  type="number"
                  bind:value={newMeasurement.hips}
                  class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring focus:ring-primary focus:ring-opacity-50"
                  step="0.1"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700">Shoulder</label>
                <input
                  type="number"
                  bind:value={newMeasurement.shoulder}
                  class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring focus:ring-primary focus:ring-opacity-50"
                  step="0.1"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700">Sleeve Length</label>
                <input
                  type="number"
                  bind:value={newMeasurement.sleeve_length}
                  class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring focus:ring-primary focus:ring-opacity-50"
                  step="0.1"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700">Inseam</label>
                <input
                  type="number"
                  bind:value={newMeasurement.inseam}
                  class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring focus:ring-primary focus:ring-opacity-50"
                  step="0.1"
                />
              </div>
            </div>
            <div>
              <label class="block text-sm font-medium text-gray-700">Notes</label>
              <textarea
                bind:value={newMeasurement.notes}
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
              Add Measurement
            </button>
          </div>
        </form>
      </div>
    </div>
  {/if}
</div>