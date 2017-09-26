# Python Ubuntu Docker image with FIPS compliant OpenSSL

## To build it
```
docker build -t fipsubuntu .
```

## To run it
```
docker run -it -d --name fips fipsubuntu
```

## Exec bash
```
docker exec -it fips bash
```
