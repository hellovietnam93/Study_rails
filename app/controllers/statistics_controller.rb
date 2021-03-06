class StatisticsController < ApplicationController
  authorize_resource :class_room

  def index
    @class_room = ClassRoom.includes(:users, :assignment_submits,
      forum: [posts: [comments: :children]]).find_by_id params[:class_room_id]
    @members = @class_room.user_classes.select do |user_class|
      user_class.status == "take_in"
    end
    @requests = @class_room.user_classes.select do |user_class|
      user_class.status == "waiting"
    end

    @posts = @class_room.forum.posts

    @x_axis = get_chart_data.keys.map {|date| date.strftime t("date.formats.default")}
    @y_axis = get_chart_data.values

    active_member

    if current_user.lecturer?
      statistic_of_member
    else
      get_most_used_tag
      get_high_vote_post
      average_time_reply_of_teacher
    end
  end

  private
  def get_most_used_tag
    @most_value_tags = @posts.tag_counts.most_used Settings.tags.most_used
  end

  def get_high_vote_post
    @high_vote_question = Like.where(likeable_type: "Post",
      likeable_id: @class_room.forum.post_ids).group(:likeable_id).count
  end

  def active_member
    @user_posts = {}
    @user_comments = {}
    @user_good_posts = {}
    @user_good_comments = {}

    @posts.each do |post|
      @members.each do |member|
        get_post_by_user post, member

        get_comment_by_user post, member
      end
    end
  end

  def get_post_by_user post, member
    if post.user_id == member.user_id
      if @user_posts[member.user_id].present?
        @user_posts[member.user_id] += 1
        if post.approved?
          if @user_good_posts[member.user_id].present?
            @user_good_posts[member.user_id] += 1
          else
            @user_good_posts[member.user_id] = 1
          end
        end
      else
        @user_posts[member.user_id] = 1
      end
    end
  end

  def get_comment_by_user post, member
    post.comments.each do |comment|
      get_comment_per_user comment, member

      comment.children.each do |comment_child|
        get_comment_per_user comment, member
      end
    end
  end

  def get_comment_per_user comment, member
    if comment.user_id == member.user_id
      if @user_comments[member.user_id].present?
        @user_comments[member.user_id] += 1
        if comment.approved?
          if @user_good_comments[member.user_id].present?
            @user_good_comments[member.user_id] += 1
          else
            @user_good_comments[member.user_id] = 1
          end
        end
      else
        @user_comments[member.user_id] = 1
      end
    end
  end

  def average_time_reply_of_teacher
    @lecturer_answers = {}
    @lecturer = @class_room.user_classes.find_by_owner true
    sum = 0

    @posts.each do |post|
      answers = post.comments.where user_id: @lecturer.user_id
      if answers.any?
        @lecturer_answers[post] = answers.minimum :created_at
      end
    end

    @donut_chart_data = {}
    @donut_chart_data[t("statistic.post.replied")] = @lecturer_answers.size
    @donut_chart_data[t("statistic.post.non_replied")] = @posts.size - @lecturer_answers.size

    if @lecturer_answers.any?
      @lecturer_answers.each do |key, value|
        sum += (value - key.created_at)
      end

      @average_time = sum.to_f / @lecturer_answers.size / 3600
    end
  end

  def get_chart_data
    posts = @posts.group("date(created_at)").count
    ids = []
    @posts.each do |post|
      post.comments.each do |comment|
        ids + comment.children.map(&:id)
      end
    end

    comments = if ids.any?
      Comment.where("post_id IN ? OR id IN ?", @class_room.post_ids, ids).group("date(created_at)").count
    else
      Comment.where(post_id: @class_room.post_ids).group("date(created_at)").count
    end

    chart_data = {}
    range = @class_room.semester.start_date.strftime(t "date.formats.default").to_date..(Date.today < @class_room.semester.end_date ? Date.today :
      @class_room.semester.end_date).strftime(t "date.formats.default").to_date
    range.to_a.each do |date|
      if posts[date].nil? && comments[date].present?
        chart_data[date] = comments[date]
      elsif posts[date].present? && comments[date].nil?
        chart_data[date] = posts[date]
      elsif posts[date].nil? && comments[date].nil?
        chart_data[date] = 0
      elsif posts[date].present? && comments[date].present?
        chart_data[date] = posts[date] + comments[date]
      end
    end
    chart_data
  end

  def statistic_of_member
    @statistic_of_member = {}

    @members.each do |member|
      @statistic_of_member[member.user] = {}
      @statistic_of_member[member.user][t("statistic.title.number_post")] = @user_posts[member.user_id].nil? ? 0 : @user_posts[member.user_id]
      @statistic_of_member[member.user][t("statistic.title.number_good_post")] = @user_good_posts[member.user_id].nil? ? 0 : @user_good_posts[member.user_id]
      @statistic_of_member[member.user][t("statistic.title.number_comment")] = @user_comments[member.user_id].nil? ? 0 : @user_comments[member.user_id]
      @statistic_of_member[member.user][t("statistic.title.number_good_comment")] = @user_good_comments[member.user_id].nil? ? 0 : @user_good_comments[member.user_id]
      @statistic_of_member[member.user][t("statistic.title.average_score")] = calculate_average_score_of_assignment member, @class_room
    end
  end

  def calculate_average_score_of_assignment user, class_room
    scores = []
    class_room.assignment_submits.each do |assignment_submit|
      if assignment_submit.share_with_team?
        team_id = assignment_submit.user.team_ids & class_room.team_ids
        team = Team.find_by_id team_id
        if team.user_ids.include? user.user_id
          scores << (assignment_submit.score.nil? ? 0 : assignment_submit.score)
        end
      elsif assignment_submit.user_id == user.user_id
        scores << (assignment_submit.score.nil? ? 0 : assignment_submit.score)
      end
    end

    if scores.any?
      scores.inject{|sum, el| sum + el} / scores.size
    else
      0
    end
  end
end
