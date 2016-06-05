namespace :db do
  desc "Create posts"
  task create_post: :environment do
    puts "Create posts"
    member_ids = ClassRoom.first.user_classes.take_in.map &:user_id

    range = ClassRoom.first.start_date.to_date..ClassRoom.first.end_date.to_date
    range = range.step(7).to_a
    a = [1, 2, 0]

    range.each do |date|
      member_ids.each do |user_id|
        a.sample.times do |n|
          post = Post.create name: "Post number in day #{date} of user #{user_id}",
            content: "Content of post", created_at: date,
            user_id: user_id, class_room_id: 1
          post.update_attributes postable: ClassRoom.first.forum
          5.times do |m|
            post.comments.create content: "New comment #{m}",
              user_id: member_ids.sample, created_at: range.sample
          end
        end
      end
    end

    puts "Completed rake data"
  end
end
