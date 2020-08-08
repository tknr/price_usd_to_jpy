#!/bin/bash

MAILADDRESS_TO=example@example.com
PRICE_USD=100

if [ $# -lt 1 ]; then
  echo "usage:${BASH_SOURCE[0]##*/} [us dollar price] [mailaddress]"
  exit 1
fi

MAILADDRESS_TO=$2
PRICE_USD=$1

JPY=`wget -q -O - 'https://api.exchangeratesapi.io/latest?base=USD&symbols=JPY'`
RATE=`echo $JPY | jq -r '.rates["JPY"]'`
PRICE_JPY=$PRICE_USD*$RATE
PRICE=`echo $PRICE_JPY|bc -l`

if [ $# -eq 1 ]; then
  printf '%.0f yen\n' $PRICE
  exit 0
fi

BODY="$PRICE_USD USD is $PRICE JPY ."
echo "rate : $RATE"$'\n'"$BODY" | mail -s "[price report] $BODY" $MAILADDRESS_TO
