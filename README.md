# Concerto 2 Aeropuertos Argentina 2000 Plugin

This plugin is based deeply on the [concerto-weather plugin](https://github.com/concerto/concerto-weather) and is used
to provide an iframe content to concerto with the flight status of the Argentinian airports

It does not use an API but rather a bit of screen-scraping and this means it might break with any changes from the content provider.

It extracts the data from [Aeropuertos Argentina 2000](http://www.aa2000.com.ar/) and bundles it in an iframe object for concerto to display

This means it needs the concerto-iframe plugin installed (comes by default) 

Concerto 2 Aeropuerto is licensed under the Apache License, Version 2.0.

## Installation 
1. Visit the plugin management page in Concerto, select RubyGems as the source and "concerto_aeropuerto" as the gem name.
2. For any issues displaying the custom weather icons, make sure to precompile assets using:

    (for production)
    ``` RAILS_ENV=production rake assets:precompile```
    
    (for development)
    ``` RAILS_ENV=development rake assets:precompile```

