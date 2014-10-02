module ProfileHelper
  include EmailPreferencesHelper

  #
  # Constructs a checkbox and associated label inside a <div> for use on the
  # profile edit screen, as part of the email preferences.
  #
  # @param name [String] the name of the checkbox
  # @param value [Symbol] the value the checkbox should have
  #
  # @return [String] the HTML to show
  #
  def email_preference(name, value)
    id_value = "user_#{name}_#{value}"
    meth = "#{name}?".to_sym

    content_tag(:div) do
      [
        check_box_tag(
          "user[#{name}][]",
          value.to_s,
          current_user.send(meth, value),
          id: id_value
        ),

        label_tag(id_value, pretty_email_name(value))
      ].join.html_safe
    end
  end

  def setup_user(user)
    (SystemEmail.all - user.system_emails).each do |system_email|
      user.email_preferences.build(system_email: system_email)
    end
    user
  end

  def sorted_email_preferences(user)
    user.email_preferences.sort_by { |ep| ep.system_email.name }
  end
end
