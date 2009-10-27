# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_wsse1_session',
  :secret      => '0471a9784f0472397a010c65379e8f5181ee697e5ebdffdb5570f44605a10c8a761bfaf785941439d3d91ff2f4935bf8a55b4cd95ee663e657fff0c372725421'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
