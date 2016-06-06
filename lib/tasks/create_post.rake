namespace :db do
  desc "Create posts"
  task create_post: :environment do
    puts "Create posts"
    member_ids = ClassRoom.first.user_classes.take_in.map &:user_id

    range = ClassRoom.first.start_date.to_date..ClassRoom.first.end_date.to_date
    range = range.step(7).to_a
    a = [1, 2, 0]

    tag_list = ["chap 1", "chap 2", "chap 3", "chap 4", "chap 5", "chap 6", "chap 7",
      "chap 8", "chap 9", "chap 10", "chap 11", "chap 12", "chap 13"]
    tag_drop = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    range.each do |date|
      member_ids.each do |user_id|
        a.sample.times do |n|
          post = Post.create name: "Post number in day #{date} of user #{user_id}",
            content: "Content of post", created_at: date,
            user_id: user_id, class_room_id: 1, postable: ClassRoom.first.forum,
            tag_list: tag_list.drop(tag_drop.sample)
          5.times do |m|
            post.comments.create content: "New comment #{m}",
              user_id: member_ids.sample, created_at: range.sample
          end
        end
      end
    end
  end
end
