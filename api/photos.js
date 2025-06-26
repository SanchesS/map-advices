// Vercel serverless function for photos API
export default async function handler(req, res) {
  // Handle GET requests for testing
  if (req.method === 'GET') {
    return res.json({ 
      message: 'Photos API is working! Use POST method with object_ids array in body to fetch photos.',
      example: {
        method: 'POST',
        url: '/api/photos',
        body: {
          object_ids: ['example_id_1', 'example_id_2']
        }
      }
    });
  }
  
  // Only allow POST requests for actual functionality
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

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
} 