# Build KeyCloak Identity Providers

## The `build_jar.sh` Shell Script
Run [build_jar.sh](build_jar.sh) to build KeyCloak identity providers.

```
Usage: build_jar.sh [-t=url] [-s=url] [-o=host [-p=port] [-u=user] [-w=password]] [-n=hosts]
    -t http proxy full url like http://ip:port, if omitted, use system env http_proxy
    -s https proxy full url like https://ip:port, if omitted, use system env https_proxy
    -o maven proxy host without port like example.com
    -p maven proxy port like 12345, if omitted, defaults to 80
    -u maven proxy username
    -w maven proxy password
    -n no proxy hosts like localhost,127.0.0.1, if omitted, use system env no_proxy
```

The generated jar file(s) will be created in the `./out/` directory.

### Build Behind Proxy
If working behind proxy, you have to specify the proxy settings in the command line.

For example, assume that your proxy is `http://user:pass@example.com:8080`, then the full command line is:
```
build_jar.sh \
  -t http://user:pass@example.com:8080 \
  -s http://user:pass@example.com:8080 \
  -o example.com -p 8080 -u user -w pass
```

