const express = require('express');
const path = require('path');

const app = express();
const port = process.env.PORT || 3000;

// Parse JSON request bodies
app.use(express.json());

app.use(express.static(path.join(__dirname, 'public')));

// 2GIS Photo API endpoint with batching
app.post('/api/photos', async (req, res) => {
  try {
    const { object_ids } = req.body;
    
    if (!object_ids || !Array.isArray(object_ids) || object_ids.length === 0) {
      return res.status(400).json({ error: 'object_ids array is required' });
    }
    
    // Dynamic import for node-fetch ESM module
    const fetch = (await import('node-fetch')).default;
    
    // Split object_ids into batches of 10 to avoid API limits
    const batchSize = 10;
    const batches = [];
    for (let i = 0; i < object_ids.length; i += batchSize) {
      batches.push(object_ids.slice(i, i + batchSize));
    }
    
    console.log(`Processing ${object_ids.length} object IDs in ${batches.length} batches`);
    
    // Fetch photos for each batch
    const allPhotoData = { items: {} };
    
    for (let i = 0; i < batches.length; i++) {
      const batch = batches[i];
      console.log(`Fetching batch ${i + 1}/${batches.length} with ${batch.length} IDs`);
      
      try {
        const photoApiUrl = new URL('https://api.photo.2gis.com/3.0/media/light');
        photoApiUrl.searchParams.append('key', 'gYu1s9N1wP');
        photoApiUrl.searchParams.append('object_ids', batch.join(','));
        photoApiUrl.searchParams.append('preview_size', '656x340,328x170,232x232,176x176,116x116,88x88');
        photoApiUrl.searchParams.append('size', '10');
        
        const response = await fetch(photoApiUrl.toString(), {
          headers: {
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/137.0.0.0 Safari/537.36',
            'Accept': 'application/json, text/plain, */*',
            'Referer': 'https://2gis.ru/'
          }
        });
        
        if (response.ok) {
          const batchData = await response.json();
          if (batchData.items) {
            // Merge batch results into the main result
            Object.assign(allPhotoData.items, batchData.items);
            console.log(`Batch ${i + 1} successful: got photos for ${Object.keys(batchData.items).length} objects`);
          }
        } else {
          console.warn(`Batch ${i + 1} failed with status: ${response.status}`);
        }
        
        // Small delay between requests to be respectful to the API
        if (i < batches.length - 1) {
          await new Promise(resolve => setTimeout(resolve, 100));
        }
        
      } catch (batchError) {
        console.error(`Error in batch ${i + 1}:`, batchError.message);
        // Continue with other batches even if one fails
      }
    }
    
    console.log(`Total photos fetched for ${Object.keys(allPhotoData.items).length} objects`);
    res.json(allPhotoData);
    
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
