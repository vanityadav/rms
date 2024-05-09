CREATE TABLE users (
	id SERIAL CONSTRAINT userId PRIMARY KEY,
	first_name VARCHAR(30) NOT NULL CHECK (first_name <> ''),
	middle_name VARCHAR(30) NOT NULL CHECK (middle_name <> ''),
	last_name VARCHAR(30) NOT NULL CHECK (last_name <> ''),
	gender SMALLINT REFERENCES genders (id),
	email VARCHAR(255) NOT NULL UNIQUE,
	photo TEXT UNIQUE,
	country_code INTEGER DEFAULT 91,
	state_code INTEGER DEFAULT NULL,
	phone INTEGER NOT NULL,
	UNIQUE (country_code, state_code, phone),
	username VARCHAR(255) NOT NULL UNIQUE,
	user_type INTEGER REFERENCES user_types (id),
	id_type INTEGER REFERENCES govt_ids (id),
	id_number TEXT,
	id_front_photo TEXT,
	id_back_photo TEXT,
	address TEXT,
	zip_code SMALLINT,
	city VARCHAR(255),
	state VARCHAR(255),
	country VARCHAR(255),
	status INTEGER REFERENCES status (id),
	
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (first_name, middle_name, last_name, email, photo, phone, username, id_number, address, zip_code, city, state, country, gender, user_type, id_type, status)
		values('Raj', 'Kumar', 'Yadav', 'raj@gamil.com', 'http://dummyimage.com/178x100.png/asda/rew2d/d/fwfffffff', 2342, 'rajumanager', 73480, '991 Carpenter Drive', 12200, 'Al Matlīn', 'NYC', 'Tunisia', (
				SELECT
					id FROM genders
				WHERE
					gender = 'MALE'), (
					SELECT
						id FROM user_types
					WHERE
						TYPE = 'MANAGER'), (
						SELECT
							id FROM govt_ids
						WHERE
							name = 'AADHAR'), (
							SELECT
								id FROM status
							WHERE
								name = 'ACTIVE'));



CREATE TABLE user_types (
	id SERIAL CONSTRAINT userTypeId PRIMARY KEY,
	TYPE VARCHAR(50) NOT NULL UNIQUE,
	status INTEGER REFERENCES status (id),
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

select * from usertypes;
insert into user_types (type, status  ) values ('TENANT',  (SELECT id from status where name = 'ACTIVE'));

CREATE TABLE manager_building (
	user_id INTEGER REFERENCES users (id),
	manager_id INTEGER REFERENCES users (id),
	building_id INTEGER REFERENCES buildings (id),
	block_id INTEGER REFERENCES blocks (id),
	manager_building_access VARCHAR [], -- [C,R,U,D]
	manager_blocks_access VARCHAR [],
	manager_floor_access VARCHAR [],
	manager_rooms_access VARCHAR [],
	start_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	-- also works as created at
	end_date TIMESTAMP WITH TIME ZONE DEFAULT NULL,
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT NULL
);

CREATE TABLE buildings (
	id SERIAL CONSTRAINT buildingId PRIMARY KEY,
	name TEXT NOT NULL CHECK (name <> ''),
	photos TEXT [],
	address TEXT,
	zip_code SMALLINT,
	city VARCHAR(255),
	state VARCHAR(255),
	country VARCHAR(255),
	perodic_date NUMERIC CHECK (perodic_date > 0) DEFAULT(1), -- starting/ ending date of every month
	status INTEGER REFERENCES status (id),
	using_blocks_model BOOLEAN DEFAULT FALSE,
	using_floors_model BOOLEAN DEFAULT FALSE,

	
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO buildings (name, address, zip_code, city, state, country,using_blocks_model, using_floors_model, status)
		values('block and floor binola', '991 Carpenter Drive', 12200, 'Al Matlīn', 'NYC', 'Tunisia', true, true, (
				SELECT
					id FROM status
				WHERE
					name = 'ACTIVE'));




CREATE TABLE blocks (
	id SERIAL CONSTRAINT blockId PRIMARY KEY,
	building_id INTEGER REFERENCES buildings (id) index,
	block_name TEXT NOT NULL CHECK (block_name <> ''),
	photos TEXT [],
	rental 300
	electricy null (Select elect from bulting wheer e od  = djfhdj)
	status INTEGER REFERENCES status (id),
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

alter table blocks ALTER COLUMN building_id SET NOT NULL;
INSERT INTO blocks (block_name, status, building_id)
		values('C', (
				SELECT
					id FROM status
				WHERE
					name = 'ACTIVE'), (
					SELECT
						id FROM buildings
					WHERE
						id = 5
						AND using_blocks_model = TRUE));


CREATE TABLE floors (
	id SERIAL CONSTRAINT floorId PRIMARY KEY,
	building_id INTEGER REFERENCES buildings (id),
	block_id INTEGER REFERENCES blocks (id),
	floor_number TEXT NOT NULL CHECK (floor_number <> ''),
	photos TEXT [],
	status INTEGER REFERENCES status (id),
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


alter table floors ALTER COLUMN building_id SET NOT NULL;

INSERT INTO floors (floor_number,block_id, status, building_id)
		values('2',(Select id from blocks where id = 6), (
				SELECT
					id FROM status
				WHERE
					name = 'ACTIVE'), (
					SELECT
						id FROM buildings
					WHERE
						id = 5
						AND using_blocks_model = TRUE));

DELETE from floors where block_id is  null;


CREATE TABLE rooms (
	id SERIAL CONSTRAINT roomId PRIMARY KEY,
	building_id INTEGER REFERENCES buildings (id),
	block_id INTEGER REFERENCES blocks (id),
	floor_id INTEGER REFERENCES floors (id),
	room_number TEXT NOT NULL CHECK (room_number <> ''),
	photos TEXT [],
	status INTEGER REFERENCES status (id),
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO rooms (room_number,floor_id,block_id, status, building_id)
		values('3',(Select id from floors where id =12),(Select id from blocks where id = 6), (
				SELECT
					id FROM status
				WHERE
					name = 'ACTIVE'), (
					SELECT
						id FROM buildings
					WHERE
						id = 5
						AND using_blocks_model = TRUE));


CREATE TABLE bookings (
	id SERIAL CONSTRAINT bookingId PRIMARY KEY,
	building_id INTEGER REFERENCES buildings (id),
	block_id INTEGER REFERENCES blocks (id),
	floor_id INTEGER REFERENCES floors (id),
	room_id INTEGER REFERENCES rooms (id) ,
	booking_agent_id INTEGER REFERENCES users (id), -- manager id/ admin id
	
	
	tenant_id INTEGER REFERENCES users (id), -- room residant id
	
	prev_booking_id INTEGER DEFAULT NULL REFERENCES bookings (id),
	prev_dues_amount INTEGER DEFAULT NULL,
	
	rental INTEGER NOT NULL CHECK (rental > 0), -- per month as of booking month price
	cost_of_electricity INTEGER NOT NULL CHECK (rental > 0), -- per unit
	electric_meter_starting_units INTEGER NOT NULL CHECK (rental > 0), -- in units 
	electric_meter_ending_units INTEGER NOT NULL CHECK (rental > 0),
	
	rental_bill_amount INTEGER GENERATED ALWAYS AS  (EXTRACT(DAY FROM (end_date - start_date)) * (rental / 30)) STORED,
	-- (endDate - startDate) * (rental/30)
	electric_bill_amount INTEGER GENERATED ALWAYS AS ((electric_meter_ending_units - electric_meter_starting_units) * cost_of_electricity )  STORED,
	-- (ending - starting) * cost_of_electricity
	total_bill_amount INTEGER,
	--  calc_rental + calc_electric + prev_dues is_trash BOOLEAN DEFAULT FALSE,
	
	start_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	end_date TIMESTAMP WITH TIME ZONE,
	
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE payments (
	id SERIAL CONSTRAINT paymentId PRIMARY KEY,
	tenant id
	room_id INTEGER REFERENCES rooms (id) ,
	booking_agent_id INTEGER REFERENCES users (id), 
	
	booking_id INTEGER REFERENCES bookings (id),
	payment_type INTEGER REFERENCES payment_types (id),
	mode_of_payment INTEGER REFERENCES mode_of_payments (id),
	amount INTEGER CHECK (amount > 0),
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE payment_types (
	id SERIAL CONSTRAINT paymentTypes PRIMARY KEY,
	name VARCHAR(100) NOT NULL UNIQUE,
	status INTEGER REFERENCES status (id),
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

insert into payment_types (name, status  ) values ('PARKING',  (SELECT id from status where name = 'ACTIVE'));

CREATE TABLE mode_of_payments (
	id SERIAL CONSTRAINT paymentMethods PRIMARY KEY,
	mode VARCHAR(40) CHECK (mode IN('ONLINE', 'OFFLINE')),
	method VARCHAR(100) NOT NULL,
	UNIQUE (mode, method),
	status INTEGER REFERENCES status (id),
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


insert into mode_of_payments (mode, method, status  ) values ('OFFLINE', 'RTGS', (SELECT id from status where name = 'ACTIVE'));


CREATE TABLE status (
	id SERIAL CONSTRAINT statusId PRIMARY KEY,
	name VARCHAR(50) NOT NULL UNIQUE, --'ACTIVE', 'PAUSED','TRASH', 'INACTIVE', 'VERIFIED'
	created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
) ;

insert into status (name ) values ('');

CREATE TABLE govt_ids (
	id SERIAL CONSTRAINT govtId PRIMARY KEY,
	name TEXT UNIQUE NOT NULL check (name <>''),
   range int4range DEFAULT null 
);
insert into govt_ids (name , number_length_max, number_length_min) values ('Passport', 8, 19);








