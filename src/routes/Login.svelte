<script lang="ts">
  import { supabase } from '../lib/supabase';
  import { user, isAuthenticated } from '../lib/stores';
  import { push } from 'svelte-spa-router';

  let email = '';
  let password = '';
  let loading = false;
  let error = '';
  let showSignUp = false;

  async function handleLogin() {
    try {
      loading = true;
      error = '';
      const { data, error: loginError } = await supabase.auth.signInWithPassword({
        email,
        password
      });

      if (loginError) throw loginError;

      user.set(data.user);
      isAuthenticated.set(true);
      push('/dashboard');
    } catch (err) {
      error = err.message;
    } finally {
      loading = false;
    }
  }

  async function handleSignUp() {
    try {
      loading = true;
      error = '';
      const { data, error: signUpError } = await supabase.auth.signUp({
        email,
        password,
        options: {
          data: {
            name: 'Head Tailor'
          }
        }
      });

      if (signUpError) throw signUpError;

      error = 'Account created successfully! You can now sign in.';
      showSignUp = false;
    } catch (err) {
      error = err.message;
    } finally {
      loading = false;
    }
  }
</script>

<div class="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
  <div class="max-w-md w-full space-y-8">
    <div>
      <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
        Stitch & Style Tailor Portal
      </h2>
      <p class="mt-2 text-center text-sm text-gray-600">
        {#if showSignUp}
          Already have an account?
          <button
            on:click={() => showSignUp = false}
            class="font-medium text-primary hover:text-opacity-80"
          >
            Sign in
          </button>
        {:else}
          Need an account?
          <button
            on:click={() => showSignUp = true}
            class="font-medium text-primary hover:text-opacity-80"
          >
            Sign up
          </button>
        {/if}
      </p>
    </div>
    <form class="mt-8 space-y-6" on:submit|preventDefault={showSignUp ? handleSignUp : handleLogin}>
      <div class="rounded-md shadow-sm -space-y-px">
        <div>
          <input
            bind:value={email}
            type="email"
            required
            class="input"
            placeholder="Email address"
          />
        </div>
        <div class="mt-4">
          <input
            bind:value={password}
            type="password"
            required
            class="input"
            placeholder="Password"
            minlength="6"
          />
        </div>
      </div>

      {#if error}
        <div class="text-sm text-center" class:text-red-500={error.includes('error') || error.includes('invalid')} class:text-green-500={error.includes('success')}>
          {error}
        </div>
      {/if}

      <div>
        <button
          type="submit"
          disabled={loading}
          class="btn btn-primary w-full"
        >
          {loading ? (showSignUp ? 'Signing up...' : 'Signing in...') : (showSignUp ? 'Sign up' : 'Sign in')}
        </button>
      </div>
    </form>
  </div>
</div>