URL="http://muffin-wallet.ru/actuator/prometheus"

for i in {1..1000}; do
  curl -s -o /dev/null -w "%{http_code}\n" "$URL" || true
done