# standalone-chrome
Selenium standalone with chrome + Testim Extension for intel-based chips.

# Creating the image locally
```
docker build -t testim/standalone-chrome:4.x-108 .
```

# Running the image locally
```
docker run --rm -it -p 4444:4444 -p 5900:5900 -p 7900:7900 --shm-size 2g testim/stanalone-chrome:4.x-108
```

# Execute Testim cli
```
testim --token "<token>" --project "<projectID>" --host 127.0.0.1
```
