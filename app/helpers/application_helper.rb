module ApplicationHelper
  def round(number)
    number_with_precision(number, precision: 1)
  end

  def edit_and_destroy_buttons(item)
    return if current_user.nil?

    edit = link_to('Edit', url_for([:edit, item]), class: "btn btn-primary")
    del = link_to('Destroy', url_for(action: :destroy, id: item.id), data: { turbo_method: :delete, turbo_confirm: 'Are you sure?' }, class: "btn btn-danger")
    raw("#{edit} #{del}")
  end
end
