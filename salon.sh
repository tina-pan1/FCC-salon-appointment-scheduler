#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Welcome to Tina's Salon ~~~~~\n"

MAIN_MENU () {
  # prints extra line if there is input
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\nWhat would you like to schedule an appointment for?"

  # gets the list of services
  LIST_OF_SERVICES=$($PSQL "SELECT service_id, name FROM services")

  # formats the list correctly
  echo "$LIST_OF_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do 
    echo -e "$SERVICE_ID) $SERVICE_NAME"
  done

  # stores input for the selected service
  read SERVICE_ID_SELECTED

  # determines if it's valid input; could use if statement but used case in lessons
  case $SERVICE_ID_SELECTED in
    1) APPOINTMENT ;;
    2) APPOINTMENT ;;
    3) APPOINTMENT ;;
    *) MAIN_MENU "Please choose an available service." ;;
  esac
}

APPOINTMENT () {
  # get customer phone number
  echo -e "\nWhat is your phone number?"
  read CUSTOMER_PHONE

  # get customer name 
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # if customer is new
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nWhat is your name?"
    read CUSTOMER_NAME
    echo $($PSQL "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi

  # this is a very basic scheduler so it does not check for conflicts and does not correct formatting
  echo -e "\nWhat time would you like to schedule your appointment for?"

  read SERVICE_TIME

  # gets the customer id and service name
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  echo $($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed 's/ //g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed 's/ //g')."
}

MAIN_MENU