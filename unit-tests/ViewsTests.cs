using NUnit.Framework;
using System;
using System.Data.SqlClient;

namespace YourNamespace.Tests
{
    [TestFixture]
    public class ViewsTests
    {
        //TODO: find out what db conection string is
        private string connectionString = "";

        [Test]
        public void TestClientDetailsView()
        {
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                // Query ClientDetailsView
                string query = "SELECT * FROM ClientDetailsView";
                using (var command = new SqlCommand(query, connection))
                {
                    using (var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            // Assert that each column has a non-null value
                            Assert.IsNotNull(reader["client_id"]);
                            Assert.IsNotNull(reader["first_name"]);
                            Assert.IsNotNull(reader["last_name"]);
                            Assert.IsNotNull(reader["email"]);
                            Assert.IsNotNull(reader["contact_number"]);
                            Assert.IsNotNull(reader["date_of_birth"]);
                            Assert.IsNotNull(reader["joined_date"]);
                            Assert.IsNotNull(reader["program_id"]);
                            Assert.IsNotNull(reader["program_name"]);
                            Assert.IsNotNull(reader["start_date"]);
                            Assert.IsNotNull(reader["end_date"]);
                        }
                    }
                }
            }
        }

        [Test]
        public void TestBillingDetailsView()
        {
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                // Query BillingDetailsView
                string query = "SELECT * FROM BillingDetailsView";
                using (var command = new SqlCommand(query, connection))
                {
                    using (var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            // Assert that each column has a non-null value
                            Assert.IsNotNull(reader["billing_id"]);
                            Assert.IsNotNull(reader["client_id"]);
                            Assert.IsNotNull(reader["amount"]);
                            Assert.IsNotNull(reader["payment_due_date"]);
                            Assert.IsNotNull(reader["payment_id"]);
                            Assert.IsNotNull(reader["payment_amount"]);
                            Assert.IsNotNull(reader["payment_date"]);
                        }
                    }
                }
            }
        }

        [Test]
        public void TestProgramExercisesView()
        {
            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                // Query ProgramExercisesView
                string query = "SELECT * FROM ProgramExercisesView";
                using (var command = new SqlCommand(query, connection))
                {
                    using (var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            // Assert that each column has a non-null value
                            Assert.IsNotNull(reader["program_id"]);
                            Assert.IsNotNull(reader["exercise_id"]);
                            Assert.IsNotNull(reader["exercise_name"]);
                            Assert.IsNotNull(reader["exercise_type"]);
                            Assert.IsNotNull(reader["exercise_description"]);
                            Assert.IsNotNull(reader["set_count"]);
                            Assert.IsNotNull(reader["rep_count"]);
                            Assert.IsNotNull(reader["rest_period_seconds"]);
                        }
                    }
                }
            }
        }
    }
}
