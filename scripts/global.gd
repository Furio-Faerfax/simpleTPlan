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

const total_day_time := 24
var remaining_planned_time :float = total_day_time
var remaining_is_time :float = total_day_time

var stop_min_max := false

func change_remaining_time(label: String, val: float):
	match label:
		"planned":
			if stop_min_max && remaining_planned_time+val >= 0.0 && remaining_planned_time <= total_day_time-val || !stop_min_max:
				remaining_planned_time += val
				#print(remaining_time)
				timing_changed.emit()
		"is":
			if stop_min_max && remaining_is_time+val >= 0.0 && remaining_is_time <= total_day_time-val || !stop_min_max:
				remaining_is_time += val
				timing_changed.emit()
		_:
			pass
