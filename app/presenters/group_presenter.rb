class GroupPresenter < BasePresenter
  presenters :group

  def edit_group user
    if is_manager_of_group? user
      link_to "#", "data-toggle": "modal",
        "data-target": "#edit-group-modal" do
        "<i class='fa fa-pencil-square-o'></i>".html_safe + " " +
          I18n.t("groups.actions.edit", name: "")
      end
    end
  end

  private
  def group_users
    group.group_users
  end

  def is_manager_of_group? user
    group_users.find do |group_user|
      group_user.manager && group_user.user_id == user.id
    end
  end
end
