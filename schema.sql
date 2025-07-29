CREATE TABLE conditions (
    id SERIAL PRIMARY KEY,                             -- Unique identifier for each condition
    name VARCHAR(255) NOT NULL,                        -- Name of the condition (e.g., fever)
    precautions TEXT,                                  -- Precautions for the condition
    diet TEXT,                                         -- Recommended diet
    if_not_working TEXT,                               -- Instructions if condition worsens
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Timestamp when record is created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP    -- Timestamp for last update
);

-- To auto-update 'updated_at' on row modification (PostgreSQL):
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_conditions_updated_at
BEFORE UPDATE ON conditions
FOR EACH ROW
EXECUTE PROCEDURE update_updated_at_column();


CREATE TABLE medications (
    id SERIAL PRIMARY KEY,                             -- Unique identifier for each medication
    condition_id INT NOT NULL,                         -- Foreign key to conditions table
    name VARCHAR(255) NOT NULL,                        -- Medication name (e.g., paracetamol)
    dosage VARCHAR(255),                               -- Dosage for the medication
    link TEXT,                                         -- URL link for purchasing medication
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Timestamp when record is created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP    -- Timestamp for last update
);

CREATE TRIGGER update_medications_updated_at
BEFORE UPDATE ON medications
FOR EACH ROW
EXECUTE PROCEDURE update_updated_at_column();

-- Foreign key constraint
ALTER TABLE medications
ADD CONSTRAINT fk_condition
FOREIGN KEY (condition_id) REFERENCES conditions(id) ON DELETE CASCADE;
