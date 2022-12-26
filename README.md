# standalone-chrome
Selenium standalone with chrome + Testim Extension for intel-based chip.


Creating the image locally
```
docker build standalong-chrome:3.x-108
```

Running the image locally
```
docker run -p 127.0.0.1:4444:4444/tcp standalone-chrome:3.x-108
```

Execute Testim cli
```
testim --token "<token>" --project "<projectID>" --host 127.0.0.1
```
