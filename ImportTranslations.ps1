# Define connection string
$connectionString = "Server=SRVBESQL01\SQL2016;Database=SP6_SPiDemo;Trusted_Connection=yes"

# Define the CSV file path
$csvFilePath = "./spi_translations_e.csv"

# Read CSV file into a variable with ';' delimiter
$csvData = Import-Csv -Path $csvFilePath -Delimiter ';'

# Initialize the update count
$updateCount = 0

# Create a SQL connection
$sqlConnection = New-Object System.Data.SqlClient.SqlConnection
$sqlConnection.ConnectionString = $connectionString
$sqlConnection.Open()

# Loop through each row in the CSV
foreach ($csvRow in $csvData) {
    $csvArea = $csvRow.Area.Replace("'", "''")
    $csvType = $csvRow.Type.Replace("'", "''")
    $csvName = $csvRow.Name.Replace("'", "''")
    $csvE = $csvRow.E.Replace("'", "''")

    # Define the SQL query to check and update the matching row
    $sqlQuery = @"
    UPDATE dbo.SPi_ConfLocales
    SET E = '$csvE'
    WHERE Area = '$csvArea' AND Type = '$csvType' AND Name = '$csvName'
"@

    # Create the SQL command
    $sqlCommand = $sqlConnection.CreateCommand()
    $sqlCommand.CommandText = $sqlQuery

    # Execute the SQL command and count the number of rows updated
    $rowsUpdated = $sqlCommand.ExecuteNonQuery()
    $updateCount += $rowsUpdated
}

# Close the SQL connection
$sqlConnection.Close()

# Output the number of rows updated
Write-Output "Number of rows updated: $updateCount"
