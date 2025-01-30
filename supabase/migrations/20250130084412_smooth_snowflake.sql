/*
  # Initial Schema Setup for Stitch & Style

  1. New Tables
    - `customers`
      - `id` (uuid, primary key)
      - `name` (text)
      - `email` (text)
      - `phone` (text)
      - `address` (text)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)
    
    - `measurements`
      - `id` (uuid, primary key)
      - `customer_id` (uuid, foreign key)
      - `chest` (numeric)
      - `waist` (numeric)
      - `hips` (numeric)
      - `shoulder` (numeric)
      - `sleeve_length` (numeric)
      - `inseam` (numeric)
      - `notes` (text)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)
    
    - `orders`
      - `id` (uuid, primary key)
      - `customer_id` (uuid, foreign key)
      - `status` (text)
      - `total_amount` (numeric)
      - `due_date` (date)
      - `notes` (text)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users
*/

-- Create customers table
CREATE TABLE customers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text,
  phone text,
  address text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create measurements table
CREATE TABLE measurements (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id uuid REFERENCES customers(id) ON DELETE CASCADE,
  chest numeric,
  waist numeric,
  hips numeric,
  shoulder numeric,
  sleeve_length numeric,
  inseam numeric,
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create orders table
CREATE TABLE orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id uuid REFERENCES customers(id) ON DELETE CASCADE,
  status text NOT NULL DEFAULT 'pending',
  total_amount numeric DEFAULT 0,
  due_date date,
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE measurements ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Allow authenticated read access" ON customers
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "Allow authenticated insert access" ON customers
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Allow authenticated update access" ON customers
  FOR UPDATE TO authenticated USING (true);

CREATE POLICY "Allow authenticated read access" ON measurements
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "Allow authenticated insert access" ON measurements
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Allow authenticated update access" ON measurements
  FOR UPDATE TO authenticated USING (true);

CREATE POLICY "Allow authenticated read access" ON orders
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "Allow authenticated insert access" ON orders
  FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Allow authenticated update access" ON orders
  FOR UPDATE TO authenticated USING (true);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_customers_updated_at
    BEFORE UPDATE ON customers
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_measurements_updated_at
    BEFORE UPDATE ON measurements
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_orders_updated_at
    BEFORE UPDATE ON orders
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();