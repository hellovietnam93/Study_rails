class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      get_reminders
    end
  end

  private
  def get_reminders
    @reminders = {}
    reminders = current_user.reminders.order(occur_date: :desc)
    dates = reminders.map(&:occur_date).uniq

    dates.each do |date|
      @reminders[date] = reminders.select do |reminder|
        reminder.occur_date == date
      end
    end
  end
end
