# Map Advices - Restaurant Discovery App

A prototype web application for discovering restaurants and food places in Moscow. The app features an interactive map with restaurant markers and a modern card-based interface for browsing recommendations.

## Features

### 🗺️ Interactive Map
- **MapGL Integration**: Powered by 2GIS MapGL with custom Moscow map style
- **Dynamic Markers**: 50+ restaurant locations with custom styled markers
- **Smooth Animations**: Marker animations with realistic bounce effects
- **Zoom Controls**: Custom zoom in/out controls
- **Responsive Design**: Optimized for both desktop and mobile devices

### 🃏 Card-Based Interface
- **Stacked Cards**: Instagram-story-style card stack with smooth transitions
- **Swipe Navigation**: Touch-friendly swipe gestures for browsing restaurants
- **Photo Gallery**: Multiple photos per restaurant with navigation dots
- **Rich Information**: Restaurant details including ratings, address, and working hours
- **Interactive Actions**: Like, bookmark, navigation, and dislike actions

### 📸 Photo Integration
- **2GIS Photos API**: Real restaurant photos fetched from 2GIS Photo API
- **Batch Processing**: Efficient photo loading with request batching (10 photos per batch)
- **Fallback Images**: Curated Unsplash photos when real photos unavailable
- **Photo Navigation**: Left/right tap navigation through photo galleries

### 🎯 Smart Features
- **Auto-minimize**: Cards automatically minimize when interacting with map
- **Marker Sync**: Map markers highlight when corresponding card is viewed
- **Loading States**: Skeleton loading animations during data fetch
- **Error Handling**: Graceful error handling with user-friendly messages

## Available Versions

The application includes four different versions for testing various features:

### 1. **Main Version** (`index.html`)
- Mock data with 50 generated restaurants
- Curated Unsplash photos
- Basic functionality demonstration

### 2. **Real Data Version** (`index-real-data.html`)
- Live 2GIS API integration for restaurant data
- Real restaurant information (names, addresses, ratings)
- Actual restaurant photos from 2GIS

### 3. **Real Data + Swyper** (`index-real-data-swyper.html`)
- All real data features
- Enhanced swipe gestures and animations
- Advanced card interactions

### 4. **Onboarding Experiment** (`index-onboarding.html`)
- Real data integration
- Pile-pour onboarding animation (default)
- Interactive onboarding overlay
- Smooth card introduction animations

## Technical Architecture

### Backend (Node.js + Express)
- **Express Server**: Lightweight HTTP server
- **Photo Proxy API**: `/api/photos` endpoint for batching 2GIS Photo API requests
- **Static Files**: Serves frontend files from `public/` directory
- **Health Check**: `/healthz` endpoint for monitoring

### Frontend
- **MapGL**: 2GIS mapping library for interactive maps
- **Vanilla JavaScript**: No framework dependencies for optimal performance
- **CSS Animations**: Hardware-accelerated animations and transitions
- **Responsive Design**: Mobile-first approach with touch gestures

### External APIs
- **2GIS Catalog API**: Restaurant search and business information
- **2GIS Photo API**: High-quality restaurant photos
- **MapGL API**: Interactive mapping and geolocation services

## Requirements

- [Node.js](https://nodejs.org/) (version 18 or later recommended)

## Running Locally

Install dependencies and start the development server:

```bash
npm install
npm start
```

The application listens on port `3000`. Access different versions:
- Main demo: `http://localhost:3000`
- Real data: `http://localhost:3000/index-real-data.html`
- Swyper version: `http://localhost:3000/index-real-data-swyper.html`
- Onboarding: `http://localhost:3000/index-onboarding.html`

To access from mobile devices on the same network, replace `localhost` with your computer's IP address.

A health check endpoint is available at `http://localhost:3000/healthz`.

## API Endpoints

### POST `/api/photos`
Fetches restaurant photos from 2GIS Photo API with request batching.

**Request Body:**
```json
{
  "object_ids": ["string_array_of_restaurant_ids"]
}
```

**Response:**
```json
{
  "items": {
    "restaurant_id": {
      "previews": ["array_of_photo_urls"],
      "count": "number_of_photos"
    }
  }
}
```

## Deployment

### Heroku
The project includes a `Procfile` for Heroku deployment:

```bash
git push heroku main
```

### Docker
Build and run with Docker:

```bash
docker build -t map-advices .
docker run -p 3000:3000 map-advices
```

### Environment Variables
- `PORT`: Server port (default: 3000)

## Development Notes

- **Photo API Rate Limits**: The backend implements request batching to respect 2GIS API limits
- **Mobile Optimization**: Touch gestures and responsive design for mobile devices
- **Performance**: Optimized animations and efficient DOM manipulation
- **Accessibility**: Semantic HTML and keyboard navigation support
