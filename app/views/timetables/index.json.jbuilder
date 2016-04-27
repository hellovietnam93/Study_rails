json.array!(@timetables) do |timetable|
  json.extract! timetable, :created_at, :updated_at, :class_room_id
  json.id timetable.id
  json.content timetable.content
  json.title timetable.title
  json.start timetable.time_start
  json.end timetable.time_end
end
