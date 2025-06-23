#Copyright (c) 2025 Furio Faerfax
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

extends Node
signal timing_changed
signal time_card_done(card)
signal time_card_undone(card)
signal time_card_reposition(card, dir)
signal time_card_done_status_changed(difference)


const total_day_time := 24

var remaining_planned_time :float = total_day_time
var remaining_is_time :float = total_day_time
var remaining_is_time_2 : float = remaining_is_time
var stop_min_max := false

func _ready() -> void:
	time_card_done.connect(into_void)
	time_card_undone.connect(into_void)
	time_card_reposition.connect(into_void2)
	time_card_done_status_changed.connect(into_void)

func into_void(_val):
	pass

func into_void2(_val, _val2):
	pass

func change_remaining_time(label: String, val: float,  long: bool):
	match label:
		"planned":
			if stop_min_max && remaining_planned_time+val >= 0.0 && remaining_planned_time <= total_day_time-val || !stop_min_max:
				remaining_planned_time += val
				#print(remaining_time)
				timing_changed.emit()
		"is":
				if long:
					remaining_is_time_2 += val
					remaining_is_time = remaining_is_time_2
				else:
					var split = str(remaining_is_time_2).split(".")
					split = float(str(split[0]+"."+split[1][0]+split[1][1]) if split[1].length() > 1 else str(split[0]+"."+split[1][0]))
					remaining_is_time = split+val
					remaining_is_time_2 = remaining_is_time
				timing_changed.emit()
		_:
			pass


				#if long:
					#remaining_is_time_2 += val
					#remaining_is_time = remaining_is_time_2
				#else:
					#var split = str(remaining_is_time_2).split(".")
					#split = float(str(split[0]+"."+split[1][0]+split[1][1]) if split[1].length() > 1 else str(split[0]+"."+split[1][0]))
					#remaining_is_time = split+val
					#remaining_is_time_2 = remaining_is_time
				#timing_changed.emit()
