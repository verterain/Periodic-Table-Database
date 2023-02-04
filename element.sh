#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

CHOOSE_ELEMENT_INFO(){

  if [[ ! $1 ]]
  then
    echo "Please provide an element as an argument."
  else

    if [[ $1 =~ ^[0-9]+$ ]]
    then
      NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1")
      TYPE=$($PSQL "SELECT t.type FROM types AS t INNER JOIN properties USING(type_id) WHERE atomic_number=$1")
      ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$1")
      M_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$1")
      B_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$1")
      echo "The element with atomic number $1 is$NAME ($(echo $SYMBOL | sed -r 's/^ *//g')). It's a$TYPE, with a mass of $(echo $ATOMIC_MASS | sed -r 's/^ *//g') amu.$NAME has a melting point of $(echo $M_POINT | sed -r 's/^ *//g') celsius and a boiling point of $(echo $B_POINT | sed -r 's/^ *//g') celsius."
    elif [[ $1 =~ [a-z]? ]]
    then
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'")
      
      if [[ -z $ATOMIC_NUMBER ]]
      then
        echo "I could not find that element in the database."
      else
        NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
        SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
        TYPE=$($PSQL "SELECT t.type FROM types AS t INNER JOIN properties USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
        ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
        M_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
        B_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
        echo "The element with atomic number $(echo $ATOMIC_NUMBER | sed -r 's/^ *//g') is$NAME ($(echo $SYMBOL | sed -r 's/^ *//g')). It's a$TYPE, with a mass of $(echo $ATOMIC_MASS | sed -r 's/^ *//g') amu.$NAME has a melting point of $(echo $M_POINT | sed -r 's/^ *//g') celsius and a boiling point of $(echo $B_POINT | sed -r 's/^ *//g') celsius."
      fi
    fi
  fi
}

CHOOSE_ELEMENT_INFO $1
