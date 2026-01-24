# ДЗ-1 ПРСП, Prometheus

## Установка и запуск

```bash
minikube addons enable ingress
```

```bash
minikube tunnel
```

```bash
docker-compose up -d
```

```bash
kubectl apply -f all.yaml
```

По адресу localhost:9090 будет Prometheus.

После действий выше по [адресу](http://muffin-wallet.ru/actuator/prometheus) можно найти метрики из `muffin-wallet`. Можно скопировать любую и найти её в UI Prometheus.

Работоспособность системы можно проверить путём проделывания запросов в Swagger UI к серверу:
1. Завести кошелёк с именем `string` и типом `PLAIN`
2. Завести кошелёк с именем `string1` и типом `PLAIN`
3. Сделать перевод с кошелька `string` на `string1`, используя `id` кошельков.

Ожидается, что на все запросы будет получен ответ 200.

## Метрики

### Количество запросов в секунду по каждому методу REST API
```
sum by (method) (rate(http_server_requests_seconds_count[1m]))
```

Для проверки можно запустить скрипт `ddos.sh` - он делает 1000 запросов по ручке с метриками muffin-wallet. Ожидается, что значение метрики станет >1. 

### Количество ошибок в логах приложения
```
sum(logback_events_total{level="error"})
```

Для проверки нужно выключить контейнер с PostgreSQL и пострелять в ручку `/v1/muffin-wallets`.

### 99-й персентиль времени ответа HTTP (обработка запросов)
```
histogram_quantile(
  0.99,
  sum by (le) (
    rate(http_server_requests_seconds_bucket[5m])
  )
)
```
Посмотрите значение метрики и запомните его. Запустите скрипт `ddos2.sh`. Ожидается, что значение метрики увеличится кратно относительно первого значения.
### Количество активных соединений к базе данных PostgreSQL
Сгруппированные по `job`
```
sum by (job) (jdbc_connections_active)
```
Все подключения:
```
sum (jdbc_connections_active)
```

Для проверки запустите скрипт `ddos2.sh`. Ожидается, что значение метрики станет ненулевым.