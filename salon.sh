#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n" 

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  
  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services")
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME BAR
  do
    echo "$SERVICE_ID) $NAME"
  done

  read SERVICE_ID_SELECTED

  DOES_SERVICE_EXIST=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  if [[ -z $DOES_SERVICE_EXIST ]]
  then
    MAIN_MENU "I could not find that service. What would you like today?"

  else
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

    #We are only selecting the name because we will print it if found
    DOES_PHONE_NUMBER_EXIST=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
    

    

    if [[ -z $DOES_PHONE_NUMBER_EXIST ]]
    then
#IF NOT FOUND
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME

      CREATE_NEW_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
      CUSTOMER_ID_NEW_CUSTOMER=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

      echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
      read SERVICE_TIME
      
      INSERT_INTO_APPOINTMENTS=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES ('$SERVICE_TIME','$CUSTOMER_ID_NEW_CUSTOMER','$SERVICE_ID_SELECTED')")
      echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

    else
#IFFFFFFFFFFF FOUNDDDDDD
      
      echo -e "\nWhat time would you like your$SERVICE_NAME,$DOES_PHONE_NUMBER_EXIST?"
      read SERVICE_TIME

      
      INSERT_INTO_APPOINTMENTS=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES ('$SERVICE_TIME','$CUSTOMER_ID','$SERVICE_ID_SELECTED')")
      echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME,$DOES_PHONE_NUMBER_EXIST."

    fi


  fi

}



MAIN_MENU