#!/bin/bash

scf="$(readlink -f "$0")"
scd="$(dirname "$scf")"

usage()
{
  echo ""
  echo "Usage: $(basename "$scf") [-t=url] [-s=url] [-o=host [-p=port] [-u=user] [-w=password]] [-n=hosts]"
  echo -e "\t-t http proxy full url like http://ip:port, if omitted, use system env http_proxy"
  echo -e "\t-s https proxy full url like https://ip:port, if omitted, use system env https_proxy"
  echo -e "\t-o maven proxy host without port like example.com"
  echo -e "\t-p maven proxy port like 12345, if omitted, defaults to 80"
  echo -e "\t-u maven proxy username"
  echo -e "\t-w maven proxy password"
  echo -e "\t-n no proxy hosts like localhost,127.0.0.1, if omitted, use system env no_proxy"
  exit 2
}

while getopts "t:s:o:p:u:w:n:" opt
do
  case "$opt" in
    t ) http_proxy=$OPTARG ;;
    s ) https_proxy=$OPTARG ;;
    o ) proxy_host=$OPTARG ;;
    p ) proxy_port=$OPTARG ;;
    u ) proxy_user=$OPTARG ;;
    w ) proxy_pwd=$OPTARG ;;
    n ) no_proxy=$OPTARG ;;
    ? ) usage ;;
  esac
done

dntag="apicurio-keycloak-extensions:tmp"

echo "Building docker image..."
bargs=""
if [ -n "$http_proxy" ]; then bargs="$bargs --build-arg HTTP_PROXY=$http_proxy"; fi
if [ -n "$https_proxy" ]; then bargs="$bargs --build-arg HTTPS_PROXY=$https_proxy"; fi
if [ -n "$no_proxy" ]; then bargs="$bargs --build-arg NO_PROXY=$no_proxy"; fi
if [ -n "$proxy_host" ]; then bargs="$bargs --build-arg PROXY_SERVER_HOST=$proxy_host"; fi
if [ -n "$proxy_port" ]; then bargs="$bargs --build-arg PROXY_SERVER_PORT=$proxy_port"; fi
if [ -n "$proxy_user" ]; then bargs="$bargs --build-arg PROXY_SERVER_USER=$proxy_user"; fi
if [ -n "$proxy_pwd" ]; then bargs="$bargs --build-arg PROXY_SERVER_PASSWORD=$proxy_pwd"; fi
if [ -n "$no_proxy" ]; then bargs="$bargs --build-arg NO_PROXY_HOSTS=$no_proxy"; fi
bargs="$bargs -t $dntag ./dist"
docker build $bargs

echo "Generating jar file..."
docker run --rm -v $scd/out:/opt/jboss/out $dntag

echo "Cleaning up..."
docker rmi $dntag

echo "The generated jar file can be found at: $scd/out/"

