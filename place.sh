#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
# этот скрипт работает так - при запуске, если на диске осталось менее 3 гигабайт, выполняется truncate базы public.nodestore
# reqspace указан в килобайтах. В данном случае указано 10 гигов чтоб заббикс ебало своё сомкнул
reqSpace=10485760
availSpace=$(df "/mnt" | awk 'NR==2 { print $4 }')
if (( availSpace < reqSpace )); then
  echo "Недостаточно места. Сношу индексы..." >&2
  docker exec -i --user=root sentry-self-hosted-postgres-1 psql -U postgres -c "TRUNCATE public.nodestore_node;"
  exit 1
fi
