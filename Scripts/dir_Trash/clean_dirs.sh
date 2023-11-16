path=/data/Uncertainty/data/raw/sub-8746

for scan in 10-gre_field_mapping3mm 1-localizer 2-t1_mpg_07sag_iso 3-task_1 4-t1_fl2d_sag_p2 5-task_2 6-t1_fl2d_sag_p2 7-task_3 8-task_4 9-gre_field_mapping3mm 99-PhoenixZIPReport; do

    mkdir ${path}/${scan}/DICOM
    mv ${path}/${scan}/resources/DICOM/files/* ${path}/${scan}/DICOM/
    rmdir ${path}/${scan}/resources/DICOM/files/
    rmdir ${path}/${scan}/resources/DICOM/
    rmdir ${path}/${scan}/resources/

done 