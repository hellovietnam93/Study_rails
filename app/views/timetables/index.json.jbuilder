json.array!(@timetables) do |timetable|
  json.extract! timetable, :created_at, :updated_at, :class_room_id
  json.id timetable.id
  json.content timetable.content
  json.title timetable.title
  json.start timetable.start_time
  json.end timetable.end_time
end
