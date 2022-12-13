# standalone-chrome
Selenium standalone with chrome + Testim Extension

Run
```
#Creating the image locally
docker build standalong-chrome:<tag>

#Running the image locally
docker run -p 127.0.0.1:4444:4444/tcp standalone-chrome:<tag>
```

```
#Execute Testim cli
testim --token "<token>" --project "<projectID>" --host 127.0.0.1
```
