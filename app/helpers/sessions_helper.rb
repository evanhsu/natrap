module SessionsHelper
  def login_link(text, username, password)
    form_tag(url_for('/login'), :style => "display:inline") do
      hidden_field_tag("person[username]", username) +
      hidden_field_tag("person[password]", password) +
      link_to(text, '#', :onclick => 'this.up("form").submit()')
    end
  end
end
