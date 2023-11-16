
"""This script specifies the naming heuristic of MAPS data DICOM files to be converted to BIDS format. The script is structured to be read by nipy/heudiconv so it must be kept in this format, though adjustments are possible. Please do not make changes to this script directly, though feel free to make a copy to adapt to you rpurposes."""


import os


def create_key(template, outtype=('nii.gz',), annotation_classes=None):
	if template is None or not template:
		raise ValueError('Template must be a valid format string')
	return template, outtype, annotation_classes


def infotodict(seqinfo):
	"""Heuristic evaluator for determining which runs belong where

	allowed template fields - follow python string module:

	item: index within category
	subject: participant id
	seqitem: run number during scanning
	subindex: sub index within group
	"""
	
	# create the naming template for each kind of scan
	t1w = create_key('sub-{subject}/anat/sub-{subject}_T1w')
	#t2w = create_key('sub-{subject}/anat/sub-{subject}_T2w')
	#rest = create_key('sub-{subject}/func/sub-{subject}_task-rest_run-{item}_bold')
	task1 = create_key('sub-{subject}/func/sub-{subject}_task-uncertainty_run-1_bold')
	task2 = create_key('sub-{subject}/func/sub-{subject}_task-uncertainty_run-2_bold')
	task3 = create_key('sub-{subject}/func/sub-{subject}_task-fish_bold')
	task4 = create_key('sub-{subject}/func/sub-{subject}_task-recall_bold')
	#dwi = create_key('sub-{subject}/dwi/sub-{subject}_dwi')
	#adc = create_key('sub-{subject}/dwi/sub-{subject}_acq-adc_dwi')
	#tracew = create_key('sub-{subject}/dwi/sub-{subject}_acq-tracew_dwi')
	#fa = create_key('sub-{subject}/dwi/sub-{subject}_acq-fa_dwi')
	#colfa = create_key('sub-{subject}/dwi/sub-{subject}_acq-colfa_dwi')
	#tensor = create_key('sub-{subject}/dwi/sub-{subject}_acq-tensor_dwi')
	field_map_p = create_key('sub-{subject}/fmap/sub-{subject}_acq-gre_phasediff')
	field_map_m = create_key('sub-{subject}/fmap/sub-{subject}_acq-gre_magnitude')
	#sefield_ap = create_key('sub-{subject}/fmap/sub-{subject}_acq-ap_magnitude')
	#sefield_pa = create_key('sub-{subject}/fmap/sub-{subject}_acq-pa_magnitude')
	
	# prepare a dictionary to sort each scan acquired by type into the categories specified above
	info = {t1w:[], task1:[], task2:[], task3:[], task4:[], field_map_m:[], field_map_p:[]}

	for s in seqinfo:
		"""
		The namedtuple `s` contains the following fields:
		
		* total_files_till_now
		* example_dcm_file
		* series_id
		* dcm_dir_name
		* unspecified2
		* unspecified3
		* dim1
		* dim2
		* dim3
		* dim4
		* TR
		* TE
		* protocol_name
		* is_motion_corrected
		* is_derived
		* patient_id
		* study_description
		* referring_physician_name
		* series_description
		* image_type
		"""
		
		# rules to sort each scan into the appropriate catergory by uniquely identifying sets of features specified in the dcminfo .tsv file

		# T1 structural
		if (s.dim3 == 256) and (s.dim4 == 1) and ('t1' in s.series_description):
			info[t1w].append(s.series_id)
		# T2 structural
		#if (s.dim3 == 30) and (s.dim4 == 1) and ('t2' in s.protocol_name):
		#	info[t2w].append(s.series_id)
		# resting-state BOLD 
		#if (s.dim3 == 35) and (s.TR == 2) and ('Rest' in s.series_description):
			#info[rest].append(s.series_id)
		# task-based BOLD
		if (s.dim4 == 759) and (s.TR == 2) and ('task-1' in s.series_description):
			info[task1].append(s.series_id)

		if (s.dim4 == 759) and (s.TR == 2) and ('task-2' in s.series_description):
			info[task2].append(s.series_id)

		if (s.dim4 == 240) and (s.TR == 2) and ('task-3' in s.series_description):
			info[task3].append(s.series_id)

		# Can't depend on timepoints for free recall since it varies in length!

		if (s.TR == 2) and ('task-4' in s.series_description):
			info[task4].append(s.series_id)

		"""# DWI 
		if (s.dim3 == 66) and (s.dim4 == 198) and ('ep2d' in s.protocol_name):
			info[dwi].append(s.series_id)
		# DWI: ADC
		if (s.dim3 == 66) and (s.dim4 == 1) and ('ADC' in s.series_description):
			info[adc].append(s.series_id)
		# DWI: TRACEW
		if (s.dim3 == 330) and (s.dim4 == 1) and ('TRACEW' in s.series_description):
			info[tracew].append(s.series_id)
		# DWI: FA
		if (s.dim3 == 66) and (s.dim4 == 1) and ('FA' in s.series_description):
			info[fa].append(s.series_id)
		# DWI: ColFA
		if (s.dim3 == 66) and (s.dim4 == 198) and ('ep2d' in s.protocol_name) and (("'COLFA'" in s.image_type) or ("'ColFA'" in s.image_type)):
			info[colfa].append(s.series_id)
		# DWI: TENSOR
		if (s.dim3 == 66) and (s.dim4 == 198) and ('ep2d' in s.protocol_name) and ("'TENSOR'" in s.image_type):
			info[tensor].append(s.series_id)"""
		# gradient echo fieldmaps
		if (s.dim3 == 80) and ('field_map' in s.series_description) and ('M' in s.image_type):
			info[field_map_m].append(s.series_id)
		if (s.dim3 == 40) and ('field_map' in s.series_description) and ('P' in s.image_type):
		 	info[field_map_p].append(s.series_id)
		"""# spin echo fieldmaps
		#if (s.dim3 == 60) and (s.TR == 4.2) and ('se_field' in s.protocol_name) and ('3ap' in s.protocol_name):
		#	info[sefield_ap].append(s.series_id)
		#if (s.dim3 == 60) and (s.TR == 4.2) and ('se_field' in s.protocol_name) and ('3pa' in s.protocol_name):
		#	info[sefield_pa].append(s.series_id)"""
	
	return info
