# Spectral analysis of along-track altimetry: eNATL60 vs SARAL-AltiKa

## Rationale

Compare the spectrum of along-track SSH between a model output and satellite altimeter data

## Method

- Hourly model SSH extracted on a rectangular region is interpolated in space and time on the along-track trajectory read into the satellite data (lon[t], lat[t], time[t])

- Fast Fourier transform is applied to all valid continuous (tappered) along-track segments, that include at least *Np* points, included in the rectangular box (all segments have a length of *Np* points)

- Average of all these FFTs provides the spectrum

## Authors

Laurent Brodeau ([Ocean Next](https://ocean-next.fr))

## Date

08/06/2020

## Technical aspects

###  Model data:

A netCDF file containing hourly (preferably) SSH on the rectangular region and the time window of your choice.

**Requirements:**
- record dimension `t` (or any other name) is `UNLIMITED` !
- field of SSH is record-dependent and two-dimensional in space (ex: `SSH(x,y,t)`)
- spatial coordinates (*i.e.* arrays of longitude and latitude) are NOT record-dependent and must be included in the file (ex: `lon(x,y)` & `lat(x,y)`)
- for the field of SSH, land points are flagged by means of the`_FillValue` netCDF attribute 
- time/calendar variable `time` (or any other name) must be included in the file  (ex: `time(t)`)
- unit for time variable `time` must be of the kind: `seconds since <DATE>` (ex: `seconds since 1950-01-01 00:00:00`)
- time/calendar variable must be consistent with the time window of the satellite data you plan to use!

### Satellite data:

The script `download_saral.sh` allows the user to directly download the relevant satellite data
from the [CMEMS](https://resources.marine.copernicus.eu/?option=com_csw&task=results) data archive, provided the user has previously registered on the CMEMS website.

Technically, this script downloads the netCDF data hosted by CMEMS for the requested period and convert it to a usable netCDF files:

- make the record dimension 'UNLIMITED' as it should always be
- unpack fields
- generate one single netCDF file for the whole period
- ensure efficient netCDF-4 deflation

**Software dependencies for script `download_saral.sh` :**
- `python 2.7`
- `motuclient` https://marine.copernicus.eu/faq/what-are-the-motu-and-python-requirements/
- `nco` http://nco.sourceforge.net/

**Requirements:**

(When not using the `download_saral.sh` script to download and process the satellite data)

- record dimension `t` (or any other name) is `UNLIMITED` !
- field of SSH/SLA is record-dependent and punctual in space (ex: `sla_unfiltered(t)`)
- field `cycle` is record-dependent and punctual in space (ex: `cycle(t)`)
- spatial coordinates are record-dependent and punctual in space (ex: `longitude(t)` & `latitude(t)`)
- for the field of SSH/SLA, missing values must be flagged by means of the`_FillValue` netCDF attribute 
- time/calendar variable `time` (or any other name) must be included in the file  (ex: `time(t)`)
- unit for time variable `time` must be of the kind: `seconds since <DATE>` (ex: `seconds since 1950-01-01 00:00:00`)
- time/calendar variable must be consistent with the time window of the model SSH data you plan to use!


### Space-time interpolation of model SSH along satellite ground track

Program `interp_to_ground_track.x`, part of the collection of tools included
in [SOSIE](https://github.com/brodeau/sosie) allows...

In SOSIE, once the architecture-dependent `make.macro` file is configured according to your Fortran compiler and netCDF installation, `interp_to_ground_track.x` is compiled by simply running:

    make i2gt

Example of a call:

    interp_to_ground_track.x -i sossheig_box_GulfS_eNATL60_JFM2017.nc -v sossheig \
                             -p SARAL_20170101-20170331.nc -n sla_unfiltered \
                             -S

* Use of the `-S` option spawns file `NP_track__<model_data>__to__<satellite_data>.nc`, in which the nearest-point along-track trajectory is shown on the model domain. This is useful for debugging purposes... In our example this file is named:
`NP_track__sossheig_box_GulfS_eNATL60_JFM2017__to__SARAL_20170101-20170331.nc`


![plot](https://github.com/ocean-next/eNATL60/blob/master/04_assessment/along-track_spectra/plots/track_GulfS_viridis.svg)
*Figure 1: Zoom over the west coast of the US on the NEMO-eNATL60 grid: nearest-point ground track of the SARAL-AltiKa satellite (during JFM 2017) as found and used by `interp_to_ground_track.x` of SOSIE.* 


* `interp_to_ground_track.x` saves the model SSH interpolated on the satellite ground track (both bilinear and nearest-point for space interpolation) as well as the original satellite data into file `result__<model_data>__to__<satellite_data>.nc`. 
This file is the only file that the Jupyter notebook requires to produce the comparison of SSH spectrum (`notebooks` sub-directory).
In our example this file is named:
`result__sossheig_box_GulfS_eNATL60_JFM2017__to__SARAL_20170101-20170331.nc`


### Spectrum computation and comparison 

The python script `scripts/spectra_SSH_sat_vs_mod.py` takes the output file of `interp_to_ground_track.x` of SOSIE to:
- compute the mean power spectrum of SSH as an average of the spectra obtained from all valid SSH track segments inside the regional box and under the common time window
- display the comparison in a figure
- saves the two power spectra into npz files

The script is called as follows (the `-h` option would let you know more):

    spectra_SSH_sat_vs_mod.py -i result__sossheig_box_GulfS_eNATL60_JFM2017__to__SARAL_20170101-20170331.nc \
                              -m sossheig     -s sla_unfiltered \
                              -M NEMO-eNATL60 -S SARAL-Altika -B GulfStream -a -6 -b 2

![plot](https://github.com/ocean-next/eNATL60/blob/master/04_assessment/along-track_spectra/plots/SSH_pow-spectrum_GulfStream__NEMO-eNATL60--SARAL-Altika__JFM.svg)

*Figure 2: Figure obtained with `spectra_SSH_sat_vs_mod.py`, see previous command.*


Note: script `spectra_SSH_sat_vs_mod.py` also *savez* the two spectra (`S(k)`) into *npz* files. In our example:

    SSH_pow-spectrum_GulfStream__NEMO-eNATL60--SARAL-Altika__JFM_mod.npz
    SSH_pow-spectrum_GulfStream__NEMO-eNATL60--SARAL-Altika__JFM_sat.npz

<br>


## Results







<!-- ## External libraries needed

  - the `TIDAL_TOOLS` :  https://github.com/molines/TIDAL_TOOLS
  - [python libraries](environment.yaml)
-->


## License
This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.