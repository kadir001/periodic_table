#!/bin/bash

# Check if an argument is provided
if [ -z "$1" ]; then
  echo "Please provide an element as an argument."
  exit 1
fi

# Use the argument as input
ELEMENT=$1

# Query the database for element information
# Assuming you are using PostgreSQL, you can use psql or any other database client in your shell script.
# The following is a sample of how to call the database from the shell script.

# Connect to the PostgreSQL database and fetch element data
DB_NAME="your_database_name"
DB_USER="your_database_user"
DB_PASSWORD="your_database_password"

# Function to fetch element information by atomic_number, symbol, or name
get_element_info() {
  psql -U $DB_USER -d $DB_NAME -t -c "SELECT elements.atomic_number, elements.name, elements.symbol, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius, types.type 
                                      FROM elements
                                      JOIN properties ON elements.atomic_number = properties.atomic_number
                                      JOIN types ON properties.type_id = types.type_id
                                      WHERE elements.atomic_number = '$1' OR elements.symbol = '$1' OR elements.name = '$1';"
}

# Call the function with the user input
ELEMENT_INFO=$(get_element_info "$ELEMENT")

# If the query returns no result, output error message
if [ -z "$ELEMENT_INFO" ]; then
  echo "I could not find that element in the database."
else
  # Format the output as required
  IFS='|' read -r ATOMIC_NUMBER NAME SYMBOL MASS MELTING_POINT BOILING_POINT TYPE <<< "$ELEMENT_INFO"
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT Celsius and a boiling point of $BOILING_POINT Celsius."
fi
