#!/usr/bin/env python

# import json
import requests
from datetime import datetime

WEATHER_ICON = {
    '01d': ' ',
    '01n': ' ',
    '02d': ' ',
    '02n': ' ',
    '03d': ' ',
    '03n': ' ',
    '04d': ' ',
    '04n': ' ',
    '09d': ' ',
    '09n': ' ',
    '10d': ' ',
    '10n': ' ',
    '11d': ' ',
    '11n': ' ',
    '13d': ' ',
    '13n': ' ',
    '50d': ' ',
    '50n': ' '
}
apiKey = "1333a34675e6bd39b096bed851932792"
lat = 54.6197
lon = 39.74

text = "󰑓  "

now = datetime.now()
last_update = now.strftime("%a, %H:%M")

try:
    weather = requests.get(
        f'https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={apiKey}&units=metric').json()
    text = WEATHER_ICON[weather['weather'][0]['icon']] + \
        " "+str(int(weather['main']['feels_like']))+"° "
except:
    pass

print(f'{text}\nLast update: {last_update}')
