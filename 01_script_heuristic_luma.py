
"""This script specifies the naming heuristic of MAPS data DICOM files to be converted to BIDS format. The script is structured to be read by nipy/heudiconv so it must be kept in this format, though adjustments are possible. Please do not make changes to this script directly, though feel free to make a copy to adapt to your purposes."""

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
	task1 = create_key('sub-{subject}/func/sub-{subject}_task-uncertainty_run-1_bold')
	task2 = create_key('sub-{subject}/func/sub-{subject}_task-uncertainty_run-2_bold')
	task3 = create_key('sub-{subject}/func/sub-{subject}_task-luma_bold')
	task4 = create_key('sub-{subject}/func/sub-{subject}_task-recall_bold')
	field_map_p = create_key('sub-{subject}/fmap/sub-{subject}_acq-gre_phasediff')
	field_map_m = create_key('sub-{subject}/fmap/sub-{subject}_acq-gre_magnitude')
	
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
		if (s.dim3 == 256) and (s.dim4 == 1) and ('t1' in s.series_description):
			info[t1w].append(s.series_id)
		if (s.dim4 == 729) and (s.TR == 2) and ('task-1' in s.series_description):
			info[task1].append(s.series_id)
		if (s.dim4 == 729) and (s.TR == 2) and ('task-2' in s.series_description):
			info[task2].append(s.series_id)
		if (s.dim4 == 210) and (s.TR == 2) and ('task-3' in s.series_description):
			info[task3].append(s.series_id)
		if (s.TR == 2) and ('task-4' in s.series_description):
			info[task4].append(s.series_id)
		if (s.dim3 == 80) and ('field_map' in s.series_description) and ('M' in s.image_type):
			info[field_map_m].append(s.series_id)
		if (s.dim3 == 40) and ('field_map' in s.series_description) and ('P' in s.image_type):
		 	info[field_map_p].append(s.series_id)

	return info