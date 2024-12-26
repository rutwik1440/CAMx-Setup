#!/bin/bash

date

DOM=$1
RESOLUTION=$2
exp=$4
year=${15}

EXEC="/home/udit/Documents/jigisha/build_camx/src.v7.20/CAMx.v7.20.MPICH3.NCF4.gfortran"
RUN="v7.20.36.12"
ICBC="/home/udit/Documents/jigisha/build_camx/out_ss/mozart2camx_v4.2/output/${DOM}_${year}_${RESOLUTION}_${exp}"
INPUT="/home/udit/Documents/jigisha/build_camx/inputs"
TUV="/home/udit/Documents/jigisha/build_camx/out_ss/tuv4.8.camx7.20/output/${DOM}_${year}_${RESOLUTION}_${exp}"
OZ="/home/udit/Documents/jigisha/build_camx/out_ss/ozone/output/${DOM}_${year}_${RESOLUTION}_${exp}"
MET="/home/udit/Documents/jigisha/build_camx/out_ss/wrfcamx_v5.2/output/${DOM}_${year}_${RESOLUTION}_${exp}"
PTSRCE="/home/udit/Documents/jigisha/build_camx/out_ss/emiss/output/${DOM}_${year}_${RESOLUTION}_elevated_${exp}"
OUTPUT="/home/udit/Documents/jigisha/build_camx/runfiles/output/${DOM}_${year}_${RESOLUTION}_${exp}"

mkdir -p $OUTPUT

#  --- Create the nodes file ---

NUMPROCS=10
#
#  --- set the dates and times ----
#
RESTART="NO"
start_day=$3
end_day=${13}
d=$start_day
x=0
jul=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31)
while [ "$d" != $end_day ]; do
        if [ ${RESTART} == "NO" ]
        then
            RESTART="false"
        else
            RESTART="true"
        fi
        echo ${d:0:10}
        d_y=$(date -I -d "$d - 1 day")
        year=("${d[@]:0:4}")
        years=("${d[@]:2:2}")
        month=("${d[@]:5:2}")
        ymonth=("${d_y[@]:5:2}")
        y1=("${d_y[@]:0:4}")
        day=("${d[@]:8:2}")
        yesterday=("${d_y[@]:8:2}")
#
#  --- Create the input file (always called CAMx.in)
#
cat << EOF > CAMx.in

 &CAMx_Control

 Run_Message      = 'CAMx 7.20 Test Problem -- CB6R4 CF SOAP $CALDAY',

!--- Model clock control ---

 Time_Zone        = 0,                 ! (0=UTC,5=EST,6=CST,7=MST,8=PST)
 Restart          = .${RESTART}.,
 Start_Date_Hour  = $year,$month,$day,0000,   ! (YYYY,MM,DD,HHmm)
 End_Date_Hour    = $year,$month,$day,2400,   ! (YYYY,MM,DD,HHmm)

 Maximum_Timestep    = 15.,            ! minutes
 Met_Input_Frequency = 60.,            ! minutes
 Ems_Input_Frequency = 60.,            ! minutes
 Output_Frequency    = 60.,            ! minutes

!--- Map projection parameters ---

 Map_Projection = 'LAMBERT',  ! (LAMBERT,POLAR,RPOLAR,MERCATOR,LATLON,UTM)
 UTM_Zone       = 0,
 Longitude_Pole =  71.28,      ! deg (west<0,south<0)
 Latitude_Pole  =  22.73,        ! deg (west<0,south<0)
 True_Latitude1 =  22.73,        ! deg (west<0,south<0)
 True_Latitude2 =  22.73,        ! deg (west<0,south<0, can = True_Latitude1)

!--- Parameters for the master (first) grid ---

 Number_of_Grids      = 1,
 Master_SW_XCoord     = -31.50,        ! km or deg, SW corner of cell(1,1)
 Master_SW_YCoord     = -94.50,        ! km or deg, SW corner of cell (1,1)
 Master_Cell_XSize    = 5.,           ! km or deg
 Master_Cell_YSize    = 5.,           ! km or deg
 Master_Grid_Columns  = 64,
 Master_Grid_Rows     = 50,
 Number_of_Layers     = 20,

!--- Parameters for the second grid ---

 Nest_Meshing_Factor(2) = 5,           ! Cell size relative to master grid
 Nest_Beg_I_Index(2)    = 2,          ! Relative to master grid
 Nest_End_I_Index(2)    = 15,         ! Relative to master grid
 Nest_Beg_J_Index(2)    = 2,          ! Relative to master grid
 Nest_End_J_Index(2)    = 6,          ! Relative to master grid

!--- Model options ---

 Diagnostic_Error_Check = .false.,      ! True = will stop after model setup
 Flexi_Nest             = .false.,      ! True = expect flexi-nested inputs
 Advection_Solver       = 'PPM',        ! (PPM,BOTT)
 Vadvection_Solver      = 'PPM',        ! (PPM,IMPLICIT)
 Chemistry_Solver       = 'EBI',        ! (EBI,LSODE)
 PiG_Submodel           = 'None',       ! (None,GREASD,IRON)
 Probing_Tool           = 'None',         ! (None,SA,DDM,HDDM,PA,IPR,IRR,RTRAC,RTCMC)
 Chemistry              = .true.,
 Drydep_Model           = 'WESELY89',    ! (None,WESELY89,ZHANG03)
 Bidi_NH3_Drydep        = .false.,
 Wet_Deposition         = .true.,
 ACM2_Diffusion         = .false.,
 Surface_Model          = .false.,
 Inline_Ix_Emissions    = 'TRUE',
 Super_Stepping         = .true.,
 Gridded_Emissions      = .false.,
 Point_Emissions        = .false.,
 Ignore_Emission_Dates  = .true.,

!--- Output specifications ---

 Root_Output_Name         = '$OUTPUT/CAMx.$RUN.$DOM.$year$month$day',
 Average_Output_3D        = .false.,
 NetCDF_Format_Output     = .true.,
 NetCDF_Use_Compression   = .false.,
 Output_Species_Names(1)   = 'NO',     ! or set "ALL" or "ALLR"
 Output_Species_Names(2)   = 'NO2',
 Output_Species_Names(3)   = 'SO2',
 Output_Species_Names(4)   = 'PNO3',
 Output_Species_Names(5)  = 'PSO4',
 Output_Species_Names(6)  = 'PNH4',
 Output_Species_Names(7)  = 'POA',
 Output_Species_Names(8)  = 'PEC',
 Output_Species_Names(9)  = 'FPRM',
 Output_Species_Names(10)  = 'CPRM',
 Output_Species_Names(11)  = 'CCRS',
 Output_Species_Names(12)  = 'FCRS',
 Output_Species_Names(13)  = 'SOA1',
 Output_Species_Names(14)  = 'SOA2',
 Output_Species_Names(15)  = 'SOA3',
 Output_Species_Names(16)  = 'SOA4',
 Output_Species_Names(17)  = 'SOPB',
 Output_Species_Names(18)  = 'SOPA',
 Output_Species_Names(19)  = 'NA',
 Output_Species_Names(20)  = 'PCL',
 

!--- Input files ---

 Chemistry_Parameters = '$INPUT/CAMx7.2.chemparam.CB6r5_CF2E',
 Photolysis_Rates     = '$TUV/tuv.ps2str_CB6r5.$years$month$day.$DOM.$RESOLUTION',
 Ozone_Column         = '$OZ/o3map.$DOM.$RESOLUTION.$year$month$day',
 Initial_Conditions   = '$ICBC/ic.$DOM-$RESOLUTION.$year$month$day.nc',
 Boundary_Conditions  = '$ICBC/bc.$DOM-$RESOLUTION.$year$month$day.nc',
 Point_Sources(1)     = '$PTSRCE/camx_guj_5_elevated.191231.nc',
 Master_Grid_Restart  = '$OUTPUT/CAMx.$RUN.$DOM.$y1$ymonth$yesterday.inst',
 Nested_Grid_Restart  = '$OUTPUT/CAMx.$RUN.$DOM.$y1$ymonth$yesterday.finst',
 PiG_Restart          = ' ',

 Surface_Grid(1) = '$MET/camx.lu.$DOM-$RESOLUTION.$year$month$day.lam.nc',
 Met3D_Grid(1)   = '$MET/camx.3d.$DOM-$RESOLUTION.$year$month$day.lam.nc',
 Met2D_Grid(1)   = '$MET/camx.2d.$DOM-$RESOLUTION.$year$month$day.lam.nc',
 Vdiff_Grid(1)   = '$MET/camx.kv.$DOM-$RESOLUTION.$year$month$day.lam.nc.YSU',
/

!--------------------------------------------------------------------




!-------------------------------------------------------------------------------

EOF

#
#  --- Execute the model ---
#
/home/udit/Documents/jigisha/build_wrf/libraries/mpich/bin/mpirun -np $NUMPROCS $EXEC

#if( ! { /home/paparao/CAPS/Build_WRF/LIBRARIES/mpich/bin/mpirun/mpiexec -launcher rsh -machinefile #nodes -np $NUMPROCS $EXEC } ) then
#   exit
#endif

RESTART = "YES"
d=$(date -I -d "$d + 1 day")

done
date
