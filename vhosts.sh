#!/bin/bash

echo
echo "RESMGR VHOST RESET "
echo
echo "Resets Control Center virtual host names to default "
echo " - hbase "
echo " - opentsdb "
echo " - rabbitmq "
echo " - zenoss5 "
echo
echo -e "Control Center Username: \c"
read -r USER
echo -e "Control Center Password: \c"

unset PASSWD;
while IFS= read -r -s -n1 char; do
  if [[ -z $char ]]; then
     echo
     break
  else
     echo -n '*'
     PASSWD+=$char
  fi
done

echo
echo " [.] Found Hostname: ${HOSTNAME} "
echo " [.] Using Creditails for ${USER} "

curl "https://${HOSTNAME}/login" -H 'Origin: https://srvr6' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36' -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept: application/json, text/plain, */*' -H 'Referer: https://srvr6/' -H 'Cookie: ZUsername=root' -H 'Connection: keep-alive' --data-binary "{\"Username\":\"${USER}\",\"Password\":\"${PASSWD}\"}" --compressed --insecure -c - > tmp 2>&1

COOKIE="$(tail -2 tmp | head -1 | awk '{print $7}' | tr -d '\n')"

if [ $COOKIE = "0" ] ; then
  echo " [x] Could not login to https://${HOSTNAME}/login"
else
  echo " [.] Using Cookie ${COOKIE}.."
  ID_ZENOSS="$(serviced service status | grep Zenoss.resmgr | awk '{print $2}')"
  echo " [.] Using Resmgr ID: ${ID_ZENOSS}"

  echo " [.] Adding temporary zenoss5x host.."
curl "https://${HOSTNAME}/services/${ID_ZENOSS}/endpoint/zproxy/vhosts/zenoss5x" -X PUT -H "Origin: https://${HOSTNAME}" -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36' -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept: application/json, text/plain, */*' -H "Referer: https://${HOSTNAME}" -H "Cookie: ZCPToken=${COOKIE}; ZUsername=${USER}" -H 'Connection: keep-alive' --data-binary "{\"ServiceID\":\"${ID_ZENOSS}\",\"Application\":\"zproxy\",\"VirtualHostName\":\"zenoss5x\"}" --compressed --insecure

  echo " [.] Deleting zenoss5 host.."
curl "https://${HOSTNAME}/services/${ID_ZENOSS}/endpoint/zproxy/vhosts/zenoss5" -X DELETE -H "Origin: https://${HOSTNAME}" -H "Accept-Encoding: gzip, deflate, sdch" -H "Accept-Language: en-US,en;q=0.8" -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36" -H "Accept: application/json, text/plain, */*" -H "Referer: https://${HOSTNAME}/" -H "Cookie: ZCPToken=${COOKIE}; ZUsername=${USER}" -H "Connection: keep-alive" --compressed --insecure

  echo " [.] Adding zenoss5 host.."
curl "https://${HOSTNAME}/services/${ID_ZENOSS}/endpoint/zproxy/vhosts/zenoss5" -X PUT -H "Origin: https://${HOSTNAME}" -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36' -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept: application/json, text/plain, */*' -H "Referer: https://${HOSTNAME}" -H "Cookie: ZCPToken=${COOKIE}; ZUsername=${USER}" -H 'Connection: keep-alive' --data-binary "{\"ServiceID\":\"${ID_ZENOSS}\",\"Application\":\"zproxy\",\"VirtualHostName\":\"zenoss5\"}" --compressed --insecure

  echo " [.] Deleting temporary zenoss5x host.."
curl "https://${HOSTNAME}/services/${ID_ZENOSS}/endpoint/zproxy/vhosts/zenoss5x" -X DELETE -H "Origin: https://${HOSTNAME}" -H "Accept-Encoding: gzip, deflate, sdch" -H "Accept-Language: en-US,en;q=0.8" -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36" -H "Accept: application/json, text/plain, */*" -H "Referer: https://${HOSTNAME}/" -H "Cookie: ZCPToken=${COOKIE}; ZUsername=${USER}" -H "Connection: keep-alive" --compressed --insecure

  ID_HBASE="$(serviced service status | grep HMaster | awk '{print $2}')"
  echo " [.] Using HMaster ID: ${ID_HBASE}"

  echo " [.] Adding temporary hbasex host.."
curl "https://${HOSTNAME}/services/${ID_HBASE}/endpoint/hbase-masterinfo-1/vhosts/hbasex" -X PUT -H "Origin: https://${HOSTNAME}" -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36' -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept: application/json, text/plain, */*' -H "Referer: https://${HOSTNAME}" -H "Cookie: ZCPToken=${COOKIE}; ZUsername=${USER}" -H 'Connection: keep-alive' --data-binary "{\"ServiceID\":\"${ID_HBASE}\",\"Application\":\"hbase-masterinfo-1\",\"VirtualHostName\":\"hbasex\"}" --compressed --insecure

  echo " [.] Deleting hbase host.."
curl "https://${HOSTNAME}/services/${ID_HBASE}/endpoint/hbase-masterinfo-1/vhosts/hbase" -X DELETE -H "Origin: https://${HOSTNAME}" -H "Accept-Encoding: gzip, deflate, sdch" -H "Accept-Language: en-US,en;q=0.8" -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36" -H "Accept: application/json, text/plain, */*" -H "Referer: https://${HOSTNAME}/" -H "Cookie: ZCPToken=${COOKIE}; ZUsername=${USER}" -H "Connection: keep-alive" --compressed --insecure

  echo " [.] Adding hbase host.."
curl "https://${HOSTNAME}/services/${ID_HBASE}/endpoint/hbase-masterinfo-1/vhosts/hbase" -X PUT -H "Origin: https://${HOSTNAME}" -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36' -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept: application/json, text/plain, */*' -H "Referer: https://${HOSTNAME}" -H "Cookie: ZCPToken=${COOKIE}; ZUsername=${USER}" -H 'Connection: keep-alive' --data-binary "{\"ServiceID\":\"${ID_HBASE}\",\"Application\":\"hbase-masterinfo-1\",\"VirtualHostName\":\"hbase\"}" --compressed --insecure

  echo " [.] Deleting temporary hbasex host.."
curl "https://${HOSTNAME}/services/${ID_HBASE}/endpoint/hbase-masterinfo-1/vhosts/hbasex" -X DELETE -H "Origin: https://${HOSTNAME}" -H "Accept-Encoding: gzip, deflate, sdch" -H "Accept-Language: en-US,en;q=0.8" -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36" -H "Accept: application/json, text/plain, */*" -H "Referer: https://${HOSTNAME}/" -H "Cookie: ZCPToken=${COOKIE}; ZUsername=${USER}" -H "Connection: keep-alive" --compressed --insecure

  ID_READER="$(serviced service status | grep reader | awk '{print $2}')"
  echo " [.] Using Reader ID: ${ID_READER}"

  echo " [.] Adding temporary opentsdbx host.."
curl "https://${HOSTNAME}/services/${ID_READER}/endpoint/opentsdb-reader/vhosts/opentsdbx" -X PUT -H "Origin: https://${HOSTNAME}" -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36' -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept: application/json, text/plain, */*' -H "Referer: https://${HOSTNAME}" -H "Cookie: ZCPToken=${COOKIE}; ZUsername=${USER}" -H 'Connection: keep-alive' --data-binary "{\"ServiceID\":\"${ID_READER}\",\"Application\":\"opentsdb-reader\",\"VirtualHostName\":\"opentsdbx\"}" --compressed --insecure

  echo " [.] Deleting opentsdb host.."
curl "https://${HOSTNAME}/services/${ID_READER}/endpoint/opentsdb-reader/vhosts/opentsdb" -X DELETE -H "Origin: https://${HOSTNAME}" -H "Accept-Encoding: gzip, deflate, sdch" -H "Accept-Language: en-US,en;q=0.8" -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36" -H "Accept: application/json, text/plain, */*" -H "Referer: https://${HOSTNAME}/" -H "Cookie: ZCPToken=${COOKIE}; ZUsername=${USER}" -H "Connection: keep-alive" --compressed --insecure

  echo " [.] Adding opentsdb host.."
curl "https://${HOSTNAME}/services/${ID_READER}/endpoint/opentsdb-reader/vhosts/opentsdb" -X PUT -H "Origin: https://${HOSTNAME}" -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36' -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept: application/json, text/plain, */*' -H "Referer: https://${HOSTNAME}" -H "Cookie: ZCPToken=${COOKIE}; ZUsername=${USER}" -H 'Connection: keep-alive' --data-binary "{\"ServiceID\":\"${ID_READER}\",\"Application\":\"opentsdb-reader\",\"VirtualHostName\":\"opentsdb\"}" --compressed --insecure

  echo " [.] Deleting temporary opentsdb host.."
curl "https://${HOSTNAME}/services/${ID_READER}/endpoint/opentsdb-reader/vhosts/opentsdbx" -X DELETE -H "Origin: https://${HOSTNAME}" -H "Accept-Encoding: gzip, deflate, sdch" -H "Accept-Language: en-US,en;q=0.8" -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36" -H "Accept: application/json, text/plain, */*" -H "Referer: https://${HOSTNAME}/" -H "Cookie: ZCPToken=${COOKIE}; ZUsername=${USER}" -H "Connection: keep-alive" --compressed --insecure


  ID_RABBITMQ="$(serviced service status | grep RabbitMQ | awk '{print $2}')"
  echo " [.] Using RabbitMQ ID: ${ID_RABBITMQ}"

  echo " [.] Adding temporary rabbitmqx host.."
curl "https://${HOSTNAME}/services/${ID_RABBITMQ}/endpoint/rabbitmq_admin/vhosts/rabbitmqx" -X PUT -H "Origin: https://${HOSTNAME}" -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36' -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept: application/json, text/plain, */*' -H "Referer: https://${HOSTNAME}" -H "Cookie: ZCPToken=${COOKIE}; ZUsername=${USER}" -H 'Connection: keep-alive' --data-binary "{\"ServiceID\":\"${ID_RABBITMQ}\",\"Application\":\"rabbitmq_admin\",\"VirtualHostName\":\"rabbitmqx\"}" --compressed --insecure

  echo " [.] Deleting rabbitmq host.."
curl "https://${HOSTNAME}/services/${ID_RABBITMQ}/endpoint/rabbitmq_admin/vhosts/rabbitmq" -X DELETE -H "Origin: https://${HOSTNAME}" -H "Accept-Encoding: gzip, deflate, sdch" -H "Accept-Language: en-US,en;q=0.8" -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36" -H "Accept: application/json, text/plain, */*" -H "Referer: https://${HOSTNAME}/" -H "Cookie: ZCPToken=${COOKIE}; ZUsername=${USER}" -H "Connection: keep-alive" --compressed --insecure

  echo " [.] Adding rabbitmq host.."
curl "https://${HOSTNAME}/services/${ID_RABBITMQ}/endpoint/rabbitmq_admin/vhosts/rabbitmq" -X PUT -H "Origin: https://${HOSTNAME}" -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36' -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept: application/json, text/plain, */*' -H "Referer: https://${HOSTNAME}" -H "Cookie: ZCPToken=${COOKIE}; ZUsername=${USER}" -H 'Connection: keep-alive' --data-binary "{\"ServiceID\":\"${ID_RABBITMQ}\",\"Application\":\"rabbitmq_admin\",\"VirtualHostName\":\"rabbitmq\"}" --compressed --insecure

  echo " [.] Deleting rabbitmqx host.."
curl "https://${HOSTNAME}/services/${ID_RABBITMQ}/endpoint/rabbitmq_admin/vhosts/rabbitmqx" -X DELETE -H "Origin: https://${HOSTNAME}" -H "Accept-Encoding: gzip, deflate, sdch" -H "Accept-Language: en-US,en;q=0.8" -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.111 Safari/537.36" -H "Accept: application/json, text/plain, */*" -H "Referer: https://${HOSTNAME}/" -H "Cookie: ZCPToken=${COOKIE}; ZUsername=${USER}" -H "Connection: keep-alive" --compressed --insecure

fi
