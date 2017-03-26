Bugzilla-Test-Management
========================

Bugzilla extension to synchronize its issues with PractiTest (two way integration)

1. Install Bugzilla
2. Install extra perl modules: REST::Client, JSON, Data::Dumper (via cpan)
3. Copy this folder to the 'extensions' directory of bugzilla
4. Rename this directory to PractiTest
5. In Config.pm, update the the following constants (line 43-44): CONFIG_HOST, CONFIG_API_TOKEN.
6. Add custom field - cf_pt_id (Type is 'Free Text'), select that it can be set on bug creation.
7. Restart bugzilla


* If you need disable extension, create empty file with name 'disabled'
