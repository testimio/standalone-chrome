FROM selenium/standalone-chrome:3.141.59-20210422

ARG CHROME_VERSION="108.0.5359.71"
ARG CHROME_DRIVER_VERSION="108.0.5359.71"

ENV EXT_HEADLESS_URL https://testimstatic.blob.core.windows.net/extension/testim-headless.zip
ENV EXT_HEADLESS_ZIP_LOC /opt/testim-headless.zip
ENV EXT_HEADLESS_LOC /opt/testim-headless

USER root

#============================================
# Google Chrome
# Update CHROME_VERSION with the relevant version 
#============================================

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy
RUN wget --no-verbose -O /tmp/chrome.deb https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERSION}-1_amd64.deb \
  && apt install -y /tmp/chrome.deb \
  && rm /tmp/chrome.deb
RUN apt-get -qqy install google-chrome-stable=${CHROME_VERSION}-1 \
  && rm /etc/apt/sources.list.d/google-chrome.list \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

#=================================
# Chrome Launch Script Wrapper
#=================================

USER root

#============================================
# Chrome webdriver
#============================================
# can specify versions by CHROME_DRIVER_VERSION
# Latest released version will be used by default
#============================================
RUN if [ -z "$CHROME_DRIVER_VERSION" ]; \
  then CHROME_MAJOR_VERSION=$(google-chrome --version | sed -E "s/.* ([0-9]+)(\.[0-9]+){3}.*/\1/") \
    && CHROME_DRIVER_VERSION=$(wget --no-verbose -O - "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROME_MAJOR_VERSION}"); \
  fi \
  && echo "Using chromedriver version: "$CHROME_DRIVER_VERSION \
  && wget --no-verbose -O /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip \
  && rm -rf /opt/selenium/chromedriver \
  && unzip /tmp/chromedriver_linux64.zip -d /opt/selenium \
  && rm /tmp/chromedriver_linux64.zip \
  && mv /opt/selenium/chromedriver /opt/selenium/chromedriver-$CHROME_DRIVER_VERSION \
  && chmod 755 /opt/selenium/chromedriver-$CHROME_DRIVER_VERSION \
  && sudo ln -fs /opt/selenium/chromedriver-$CHROME_DRIVER_VERSION /usr/bin/chromedriver


# Testim's extension version
RUN apt-get update -qqy \
  && apt-get -qqy install curl fonts-indic \
  && wget --no-verbose -O $EXT_HEADLESS_ZIP_LOC $EXT_HEADLESS_URL \
  && unzip $EXT_HEADLESS_ZIP_LOC -d $EXT_HEADLESS_LOC \
  && echo $(curl -sI -X HEAD "${EXT_HEADLESS_URL}" | tr -d '\r' | sed -En 's/^ETag: (.*)/\1/p') > /opt/testim-headless-info \
  && rm -rf /var/lib/apt/lists/*

USER seluser
