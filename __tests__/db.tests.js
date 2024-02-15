console.log("Running tests...");

const pgp = require("pg-promise")();

const db = pgp({
	host: process.env.PGHOST,
	port: process.env.PGPORT,
	database: "testdb",
	user: process.env.PGUSER,
	password: process.env.PGPASSWORD,
});
//tests for table existence
describe("PostgreSQL Views Tests", () => {
	test("Check if required tables exist", async () => {
		const tables = [
			"clients",
			"programs",
			"exercises",
			"client_program",
			"program_exercise",
			"billing",
			"payments",
			"difficulty",
		];

		for (let table of tables) {
			const query = `
				SELECT EXISTS (
					SELECT FROM information_schema.tables
					WHERE table_schema = 'public' AND table_name = $1
				);
			`;
			const result = await db.one(query, [table]);
			expect(result.exists).toBe(true);
		}
	});

	// Tests for the views
	test("ClientDetailsView should return expected columns", async () => {
		const query = `
            SELECT * FROM ClientDetailsView;
        `;
		const result = await db.any(query);
		expect(result.length).toBeGreaterThan(0);
		result.forEach((row) => {
			expect(row.client_id).toBeDefined();
			expect(row.first_name).toBeDefined();
			expect(row.last_name).toBeDefined();
			expect(row.email).toBeDefined();
			expect(row.contact_number).toBeDefined();
			expect(row.date_of_birth).toBeDefined();
			expect(row.joined_date).toBeDefined();
			expect(row.program_name).toBeDefined();
			expect(row.program_start_date).toBeDefined();
			expect(row.program_end_date).toBeDefined();
		});
	});

	test("BillingDetailsView should return expected columns", async () => {
		const query = `
            SELECT * FROM BillingDetailsView;
        `;
		const result = await db.any(query);
		expect(result.length).toBeGreaterThan(0);
		result.forEach((row) => {
			expect(row.billing_id).toBeDefined();
			expect(row.first_name).toBeDefined();
			expect(row.last_name).toBeDefined();
			expect(row.email).toBeDefined();
			expect(row.total_billed).toBeDefined();
			expect(row.amount_paid).toBeDefined();
			expect(row.amount_owed).toBeDefined();
		});
	});

	test("ProgramExercisesView should return expected columns", async () => {
		const query = `
            SELECT * FROM ProgramExercisesView;
        `;
		const result = await db.any(query);
		expect(result.length).toBeGreaterThan(0);
		result.forEach((row) => {
			expect(row.program_name).toBeDefined();
			expect(row.exercise_name).toBeDefined();
			expect(row.exercise_type).toBeDefined();
			expect(row.exercise_description).toBeDefined();
			expect(row.set_count).toBeDefined();
			expect(row.rep_count).toBeDefined();
			expect(row.rest_period_seconds).toBeDefined();
		});
	});
});

describe("PostgreSQL Stored Procedures Tests", () => {
	test("CreateClient procedure should create a new client", async () => {
		const result = await db.proc("createclient", [
			"sam",
			"fin",
			"john.doe@example.com",
			"123456789",
			"1990-01-01",
			"2024-02-15",
		]);

		expect(result).toBeDefined();

		const client = await db.one(
			"SELECT * FROM clients WHERE first_name = 'sam' AND last_name = 'fin'"
		);
		expect(client).toBeDefined();
	});

	test("CreateClientBillingProgram procedure should create a new client with billing and program", async () => {
		const result = await db.proc("createclientbillingprogram", [
			"Jarro",
			"Smith",
			"jane.smith@example.com",
			"987654321",
			"1995-05-15",
			"2024-02-15",
			100.0,
			1,
		]);

		expect(result).toBeDefined();

		const client = await db.one(
			"SELECT * FROM clients WHERE first_name = 'Jarro' AND last_name = 'Smith'"
		);
		expect(client).toBeDefined();

		const billing = await db.one("SELECT * FROM billing WHERE client_id = $1", [
			client.client_id,
		]);
		expect(billing).toBeDefined();

		const program = await db.one(
			"SELECT * FROM client_program WHERE client_id = $1",
			[client.client_id]
		);
		expect(program).toBeDefined();
	});

	test("UpdateClient procedure should update client information", async () => {
		const result = await db.proc("updateclient", [
			"2",
			"UpdatedFirstName",
			"UpdatedLastName",
			"updated.email@example.com",
			"9876543210",
		]);

		expect(result).toBeDefined();

		const updatedClient = await db.one(
			"SELECT * FROM clients WHERE client_id = 2"
		);
		expect(updatedClient.first_name).toBe("UpdatedFirstName");
		expect(updatedClient.last_name).toBe("UpdatedLastName");
		expect(updatedClient.email).toBe("updated.email@example.com");
		expect(updatedClient.contact_number).toBe("9876543210");
	});
});

//test for tbf
describe("PostgreSQL Table-Valued Functions Tests", () => {
	test("CalculateClientProgramDuration function should return program durations for a client", async () => {
		const programDurations = await db.any(
			"SELECT * FROM CalculateClientProgramDuration($1)",
			[4]
		);

		expect(programDurations).toHaveLength(1);
		expect(programDurations[0].program_id_result).toBe(2);
		expect(programDurations[0].duration_days).toBe(22);
	});

	test("GetUnpaidBills function should return clients with unpaid bills", async () => {
		const unpaidBills = await db.any("SELECT * FROM GetUnpaidBills()");

		expect(unpaidBills).toBeDefined();

		expect(unpaidBills.length).toBeGreaterThan(0);
		expect(unpaidBills[0]).toHaveProperty("firstname");
		expect(unpaidBills[0]).toHaveProperty("lastname");
		expect(unpaidBills[0]).toHaveProperty("clientemail");
		expect(unpaidBills[0]).toHaveProperty("amountstillowed");

		const firstEntry = unpaidBills[0];

		expect(firstEntry.firstname).toBe("Leila");
		expect(firstEntry.lastname).toBe("Gouldstone");
		expect(firstEntry.clientemail).toBe("lgouldstone5@a8.net");
		expect(parseFloat(firstEntry.amountstillowe)).toBe(4373.0);
	});
});

//test for scalar function
describe("PostgreSQL Scalar Functions Tests", () => {
	test("CalculateTotalPayment function should return total payment for a client", async () => {
		const totalPayment = await db.one(
			"SELECT CalculateTotalPayment($1) AS total_payment",
			[4]
		);
		expect(totalPayment.total_payment).toBe(3078.0);
	});
});
