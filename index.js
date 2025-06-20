const express = require('express');
const path = require('path');

const app = express();
const port = process.env.PORT || 3000;

// Parse JSON request bodies
app.use(express.json());

app.use(express.static(path.join(__dirname, 'public')));

// 2GIS Photo API endpoint
app.post('/api/photos', async (req, res) => {
  try {
    const { object_ids } = req.body;
    
    if (!object_ids || !Array.isArray(object_ids) || object_ids.length === 0) {
      return res.status(400).json({ error: 'object_ids array is required' });
    }
    
    // Dynamic import for node-fetch ESM module
    const fetch = (await import('node-fetch')).default;
    
    // Prepare the 2GIS Photo API request
    const photoApiUrl = new URL('https://api.photo.2gis.com/3.0/media/light');
    photoApiUrl.searchParams.append('key', 'gYu1s9N1wP');
    photoApiUrl.searchParams.append('object_ids', object_ids.join(','));
    photoApiUrl.searchParams.append('preview_size', '656x340,328x170,232x232,176x176,116x116,88x88');
    photoApiUrl.searchParams.append('size', '10');
    
    console.log('Fetching photos from:', photoApiUrl.toString());
    
    // Add headers that match the example
    const response = await fetch(photoApiUrl.toString(), {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36',
        'Accept': 'application/json, text/plain, */*',
        'Referer': 'https://2gis.ru/'
      }
    });
    
    if (!response.ok) {
      console.error(`Photo API responded with status: ${response.status}`);
      throw new Error(`Photo API responded with status: ${response.status}`);
    }
    
    const photoData = await response.json();
    console.log('Photo API response:', JSON.stringify(photoData, null, 2));
    res.json(photoData);
    
  } catch (error) {
    console.error('Error fetching photos:', error);
    res.status(500).json({ error: 'Failed to fetch photos', details: error.message });
  }
});

app.get('/healthz', (req, res) => {
  res.send('ok');
});

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
