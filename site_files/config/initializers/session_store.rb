# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_site_files_session',
  :secret      => '25830d7e57b0d80a39119192f3b7c4ee99b4580f12a6cbb56efe68aa52d3002a760324f5a29f4010a978d2d4f82c3293c4b3c3843bfcac9017a9ae14285096fc'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
