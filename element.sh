#!/bin/bash

# Database query command
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check for argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# Query the database
ELEMENT=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius 
                 FROM elements 
                 INNER JOIN properties ON elements.atomic_number = properties.atomic_number
                 INNER JOIN types ON properties.type_id = types.type_id 
                 WHERE elements.atomic_number = '$1' OR elements.symbol = '$1' OR elements.name ILIKE '$1'")

# Handle no results
if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
  exit
fi

# Parse the results
IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$ELEMENT"

# Output the results
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
