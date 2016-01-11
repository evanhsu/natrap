# Be sure to restart your server when you modify this file.

#Trunk::Application.config.session_store :cookie_store, :key => '_trunk_session' #Rails 3.0.3
Rails.application.config.session_store :cookie_store, key: '_natrap_session' #Rails 4.1

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Trunk::Application.config.session_store :active_record_store
