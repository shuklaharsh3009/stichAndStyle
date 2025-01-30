/*
  # Create Initial Tailor Account

  1. Changes
    - Create initial tailor account with secure credentials
    - Include UUID for user id
*/

-- Insert initial tailor account
INSERT INTO auth.users (
  id,
  email,
  encrypted_password,
  email_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at,
  role,
  instance_id
)
VALUES (
  gen_random_uuid(),
  'tailor@stitchandstyle.com',
  crypt('StitchStyle2024!', gen_salt('bf')),
  now(),
  '{"provider":"email","providers":["email"]}',
  '{"name":"Head Tailor"}',
  now(),
  now(),
  'authenticated',
  '00000000-0000-0000-0000-000000000000'
);