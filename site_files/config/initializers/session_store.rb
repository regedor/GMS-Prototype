# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_GMS_session',
  :secret      => 'a925783f8e7d67fd7a226e56909fea1847233fe7e5eb4aa0a6e9836f0963524d3ff2a868266a5f37bef86fbabeb51fb88d8d51a3f18acc0a4415f68a2b2770f1'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
