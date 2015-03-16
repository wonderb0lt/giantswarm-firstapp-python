import os

from flask import Flask
from flask.ext.cache import Cache
import requests

app = Flask(__name__)
cache = Cache(app, config={
    "CACHE_TYPE": "redis",
    "CACHE_REDIS_HOST": os.getenv("REDIS_PORT_6379_TCP_ADDR"),
    "CACHE_REDIS_PORT": os.getenv("REDIS_PORT_6379_TCP_PORT")
})

@app.route('/')
@cache.cached(timeout=60)
def index():
    print("Querying live weather data")
    r = requests.get("http://api.openweathermap.org/data/2.5/weather?q=Cologne")
    data = r.json()
    weather_string = data["weather"][0]["description"];
    weather_string += ", temperature %.1f" % (data["main"]["temp"] - 273);
    weather_string += " degrees, wind %d km/h" % (data["wind"]["speed"] * 3.6)
    return weather_string

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=False)
