
seq 10000 | xargs -n1 -P16 -I{} curl -X 'POST' \
    -s -o /dev/null -w "%{http_code}\n" \
    'http://muffin-wallet.ru/v1/muffin-wallets' \
    -H 'accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
    "type": "PLAIN",
    "owner_name": "323232"
    }'