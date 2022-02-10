# Quality_control_FluxNet_Data
Minor adjustments made to the original FLUXNET data to preserve the integrity of the measurements.

Adjustments to the FLUXNET data were as follows: 

Step 1: if the measured energy balance (net radiation minus latent, sensible, and ground heat flux) at any half-hourly measurement exceeded 300 J·m−2·s−1, the fluxes for that half hour were treated as missing; 

Step 2: if the measured energy balance averaged over the day exceeded 50 J·m−2·s−1, the whole day was excluded from the analysis; 

Step 3: if data gaps were less than 6 h in length, linear interpolation was used to estimate the missing data; 

Step 4: any day which, after interpolation, did not have a complete diurnal cycle (i.e., 48 half-hourly values) of the necessary measurements for estimation was not used in the analysis.
