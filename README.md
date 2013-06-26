Bugzilla-Test-Management
========================

Bugzilla extension to synchronize its issues with PractiTest (two way integration)

1. Install Bugzilla
2. Install extra perl modules: REST::Client,  JSON, Digest::MD5, Crypt::SSLeay, Data::Dumper (via cpan)
3. Copy this folder to the 'extensions' directory of bugzilla
4. Rename this directory to PractiTest
5. In Extension.pm, update the the following constants (line 33-35): CONFIG_HOST, CONFIG_API_KEY, CONFIG_API_SECRET_KEY.
6. Add custom field - cf_pt_id (Type is 'Free Text') to Bugzilla
7. Restart Bugzilla


* If you need to disable extension, create empty file with name 'disabled'
