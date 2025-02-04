#!/bin/bash

SOSIE_OUT_DIR="/MEDIA/data/eNATL60/comp_satellites"


for cb in "GulfS" "Azores"; do

    pmax=2 ; pmin=-6
    #if [ "${cb}" = "GulfS" ]; then pmax=2; pmin=-6; fi
    
    
    for cs in "JAS" "JFM"; do

        yyyy="2016"; cp="2009"
        if [ "${cs}" = "JFM" ]; then yyyy="2017"; cp="2010"; fi

        ./spectra_SSH_sat_vs_mod.py -i ${SOSIE_OUT_DIR}/result__sossheig_box_${cb}_eNATL60-BLBT02_${cs}-${yyyy}_gridT-2D_copy${cp}__to__dt_global_alg_sla_vxxc_${cs}_${yyyy}_SARAL-Altika.nc -m sossheig -s sla_unfiltered -B ${cb} -M eNATL60-tide -S SARAL -a ${pmin} -b ${pmax}

        ./spectra_SSH_sat_vs_mod.py -i ${SOSIE_OUT_DIR}/result__sossheig_box_${cb}_eNATL60-BLBT02_${cs}-${yyyy}_gridT-2D_copy${cp}__to__dt_global_s3a_sla_vxxc_${cs}_${yyyy}_Sentinel3.nc -m sossheig -s sla_unfiltered -B ${cb} -M eNATL60-tide -S Sentinel3 -a ${pmin} -b ${pmax}

        ./spectra_SSH_sat_vs_mod.py -i ${SOSIE_OUT_DIR}/result__sossheig_box_${cb}_eNATL60-BLB002_${cs}-${yyyy}_gridT-2D_copy${cp}__to__dt_global_alg_sla_vxxc_${cs}_${yyyy}_SARAL-Altika.nc -m sossheig -s sla_unfiltered -B ${cb} -M eNATL60-notide -S SARAL -a ${pmin} -b ${pmax}

        ./spectra_SSH_sat_vs_mod.py -i ${SOSIE_OUT_DIR}/result__sossheig_box_${cb}_eNATL60-BLB002_${cs}-${yyyy}_gridT-2D_copy${cp}__to__dt_global_s3a_sla_vxxc_${cs}_${yyyy}_Sentinel3.nc -m sossheig -s sla_unfiltered -B ${cb} -M eNATL60-notide -S Sentinel3 -a ${pmin} -b ${pmax}

    done

done
