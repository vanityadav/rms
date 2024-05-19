-- +goose Up
-- +goose StatementBegin
CREATE TABLE users (
    userId SERIAL PRIMARY KEY,

    first_name VARCHAR NOT NULL CHECK (first_name <> ''),
    middle_name VARCHAR,
	last_name VARCHAR NOT NULL CHECK (last_name <> ''),

    country_code INTEGER DEFAULT 91,
    state_code INTEGER DEFAULT NULL,
    phone INTEGER NOT NULL,
    UNIQUE(country_code, state_code, phone),

    father_name VARCHAR DEFAULT NULL,
    mother_name VARCHAR DEFAULT NULL,

	dob TIMESTAMP DEFAULT NULL,
	gender SMALLINT REFERENCES genders (id),

    govt_id VARCHAR DEFAULT NULL,
    govt_id_number VARCHAR DEFAULT NULL, 
    id_front TEXT DEFAULT NULL,
    id_back TEXT DEFAULT NULL,


    username VARCHAR NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,


    address TEXT DEFAULT NULL,
    zip_code SMALLINT DEFAULT NULL,
    city VARCHAR DEFAULT NULL,
    state VARCHAR DEFAULT NULL, 
    country VARCHAR DEFAULT NULL,
    permanent_address TEXT DEFAULT NULL,

    user_type VARCHAR DEFAULT NULL,
    status VARCHAR DEFAULT NULL,
    tag VARCHAR DEFAULT NULL,

    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT NULL
);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS users;
-- +goose StatementEnd
