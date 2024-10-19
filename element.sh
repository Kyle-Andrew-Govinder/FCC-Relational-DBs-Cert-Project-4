#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then 

  echo "Please provide an element as an argument."

else 

  if [[ $1 =~ ^[0-9]+$ ]]
  then

    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1;")
  
  else

    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' OR name = '$1';") 

  fi
  
  if [[ -z $ATOMIC_NUMBER ]] 
  then

    echo "I could not find that element in the database."

  else 

    ELEMENT_DETAILS=$($PSQL "SELECT * FROM elements INNER JOIN properties USING (atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number = $ATOMIC_NUMBER;")
    echo $ELEMENT_DETAILS | while IFS='|' read TYPE_ID ATOMIC_NUM SYMBOL NAME ATOMIC_MASS MELT_POINT BOIL_POINT TYPE
    do

      echo "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius."

    done

  fi

fi