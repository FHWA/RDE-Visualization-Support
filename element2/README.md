### Element 2 Data Preparation

This directory contains the scripts needed to recreate the data used in Element 2.
First you will need to download the following datasets from RDE.

1. `Basic Safety Message` : [BsmP1 file](https://www.its-rde.net/data/showdf?dataSetNumber=10178)
2. `Roadside Equpment` : [BSM file](https://www.its-rde.net/data/showdf?dataSetNumber=10182)

Once you have downloaded you should have two zip files.  Unzip both the files.  Inside each zip should be one folder.  Place both folders into this directory.

Next run the `Element 2 - DownSample` Script.  This script will populate /data with several data files.  The most imporant of which will be `data/p1_latlon_min.csv`, `data/rse_latlon_min.csv`, and `data/heat.csv`.  These three files are used in the Element 2 visualization.

___
There is also a script called `vertex_generation.js` which was used to generate `large3_vertex_variable.js` for Element 3.  This script generates a large number of points inside the bounds of Minnesota so that we could create a smoother extrapolation area for the weather data.

Here `Jason` will describe how to use the script....