class EditUserForm
  def initialize user
    @user = user
    @profile = @user.profile
  end

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def persisted?
    false
  end

  class << self
    def model_name
      ActiveModel::Name.new self, nil, User.name
    end
  end

  delegate :username, :email, :password, :passoword_confirmation, to: :user
  delegate :school, :cohort, :program, :class_name, :uid, :birthday,
    :address, :phone, to: :profile

  def user
    @user
  end

  def profile
    @profile
  end

  def submit params
    user.attributes = params.slice :username, :email, :password, :passoword_confirmation
    profile.attributes = params.slice :school, :cohort, :program, :class_name, :uid, :birthday,
      :address, :phone

    if valid?
      user.save!
      profile.save!

      true
    else
      false
    end
  end
end
