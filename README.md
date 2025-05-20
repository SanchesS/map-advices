# map-advices

Prototype web application for exploring companies. The application now displays
a [MapGL](https://docs.2gis.com/en/mapgl) map of Moscow with 50 random markers
representing mock company names. It can be accessed from a phone or desktop
browser and serves as a starting point for further development.

## Requirements

- [Node.js](https://nodejs.org/) (version 18 or later is recommended)

## Running locally

Install dependencies and start the development server:

```bash
npm install
npm start
```

The application listens on port `3000`. If running on your computer, you can
open `http://localhost:3000` in your browser. To access it from your phone while
on the same network, replace `localhost` with your computer's IP address.

A simple health check endpoint is available at `http://<host>:3000/healthz`.

## Deployment

This project can be deployed to any Node-friendly environment (for example,
Heroku or a Docker container). The default `start` script runs `index.js`, so a
basic `Procfile` for Heroku would look like:

```
web: npm start
```

For Docker-based deployment, build the image and run the container:

```bash
docker build -t map-advices .
docker run -p 3000:3000 map-advices
```

These steps are optional but provide a basis for hosting the app so it can be
accessed from a mobile device.
