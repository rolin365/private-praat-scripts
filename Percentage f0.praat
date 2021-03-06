# Form to input some information.
form Enter the following:
	comment Which tier should be analysed?
	integer Which_tier: 2
	comment (do not add trailing slash to your paths)
	sentence Input_folder: C:\Users\rolin\OneDrive\Oxford Research\Thesis related\data\4\妈妈\mama-zi
	sentence Output_folder: C:\Users\rolin\OneDrive\Oxford Research\Thesis related\data\4\妈妈\mama-zi
endform

# Creating lists of WAV and TextGrid files contained in your
# input_folder. The script assumes that your WAVS and TextGrids have
# the same name (but different extensions: ".TextGrid" and ".wav").
tgd_list_ID = Create Strings as file list: "tgd_list", input_folder$ + "\*.TextGrid"
wav_list_ID = Create Strings as file list: "wav_list", input_folder$ + "\*.wav"
total_n_items = Get number of strings

# Creating table to save results later.
table_ID = Create Table with column names: "data_table", 0, "file tier 
	...interval label start end duration pitch_0% pitch_10% pitch_20% pitch_30% pitch_40% pitch_50% pitch_60% pitch_70% pitch_80% pitch_90% pitch_100%"

# For loop to iterate through files (pairs of WAV + TextGrid).
row_counter = 0
for i to total_n_items
	
	# Obtaining WAV name and opening file from input folder.
	selectObject: wav_list_ID
	current_wav_name$ = Get string: i
	current_wav_ID = Read from file: current_wav_name$

	# Creating Pitch object from WAV file (default values).
	current_pitch_ID = To Pitch: 0.0, 75, 800

	# Obtaining TextGrid name and opening file from input folder. Also
	# querying how many intervals are present in target tier.
	selectObject: tgd_list_ID
	current_tgd_name$ = Get string: i
	current_tgd_ID = Read from file: current_tgd_name$
	total_n_intervals = Get number of intervals: which_tier

	# Fruity loop to iterate through each interval of target tier.
	for x to total_n_intervals
		
		# Obtaining the label of each interval and calculating its
		# length.
		selectObject: current_tgd_ID
		current_label$ = Get label of interval: which_tier, x
		length_label = length (current_label$)
		
		# Conditional jump: only labels of n characters larger than 0
		# will be further analysed.
		if length_label > 0
			
			# Querying duration points from labelled interval and
			# calculating three points of interest.
			start = Get start point: which_tier, x
			end = Get end point: which_tier, x
			point_o_0 = start
			point_a_1st = ((end - start) * 0.1) + start
			point_b_2nd = ((end - start) * 0.2) + start
			point_c_3rd = ((end - start) * 0.3) + start
			point_d_4th = ((end - start) * 0.4) + start
			point_e_5th = ((end - start) * 0.5) + start
			point_f_6th = ((end - start) * 0.6) + start
			point_g_7th = ((end - start) * 0.7) + start
			point_h_8th = ((end - start) * 0.8) + start
			point_i_9th = ((end - start) * 0.9) + start
			point_j_10th = end
			
			duration = end - start
			
			# Querying the Pitch object to obtain desired measurements
			# in three target points.
			selectObject: current_pitch_ID
			pitch_o = Get value at time: point_o_0, "Hertz", "Linear"
			pitch_a = Get value at time: point_a_1st, "Hertz", "Linear"
			pitch_b = Get value at time: point_b_2nd, "Hertz", "Linear"
			pitch_c = Get value at time: point_c_3rd, "Hertz", "Linear"
			pitch_d = Get value at time: point_d_4th, "Hertz", "Linear"
			pitch_e = Get value at time: point_e_5th, "Hertz", "Linear"
			pitch_f = Get value at time: point_f_6th, "Hertz", "Linear"
			pitch_g = Get value at time: point_g_7th, "Hertz", "Linear"
			pitch_h = Get value at time: point_h_8th, "Hertz", "Linear"
			pitch_i = Get value at time: point_i_9th, "Hertz", "Linear"
			pitch_j = Get value at time: point_j_10th, "Hertz", "Linear"

			# Modifying Table object to save results.
			selectObject: table_ID
			Append row
			row_counter += 1
			Set string value: row_counter, "file", current_wav_name$
			Set numeric value: row_counter, "tier", which_tier
			Set numeric value: row_counter, "interval", x
			Set string value: row_counter, "label", current_label$
			Set numeric value: row_counter, "start", start
			Set numeric value: row_counter, "end", end
			Set numeric value: row_counter, "pitch_0%", pitch_o
			Set numeric value: row_counter, "pitch_10%", pitch_a
			Set numeric value: row_counter, "pitch_20%", pitch_b
			Set numeric value: row_counter, "pitch_30%", pitch_c
			Set numeric value: row_counter, "pitch_40%", pitch_d
			Set numeric value: row_counter, "pitch_50%", pitch_e
			Set numeric value: row_counter, "pitch_60%", pitch_f
			Set numeric value: row_counter, "pitch_70%", pitch_g
			Set numeric value: row_counter, "pitch_80%", pitch_h
			Set numeric value: row_counter, "pitch_90%", pitch_i
			Set numeric value: row_counter, "pitch_100%", pitch_j
		endif
	endfor

	# Selecting all objects that won't be used any longer and remove
	# them from the Objects window.
	selectObject: current_wav_ID
	plusObject: current_tgd_ID
	plusObject: current_pitch_ID
	Remove

endfor

# Selecting Table object in order to save it as CSV file in
# output_folder destination.
selectObject: table_ID
Save as comma-separated file: output_folder$ + "\results.csv"