# -*- Mode: perl; indent-tabs-mode: nil -*-
#
# The contents of this file are subject to the Mozilla Public
# License Version 1.1 (the "License"); you may not use this file
# except in compliance with the License. You may obtain a copy of
# the License at http://www.mozilla.org/MPL/
#
# Software distributed under the License is distributed on an "AS
# IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
# implied. See the License for the specific language governing
# rights and limitations under the License.
#
# The Original Code is the Bugzilla Bug Tracking System.
#
# The Initial Developer of the Original Code is Everything Solved, Inc.
# Portions created by the Initial Developers are Copyright (C) 2009 the
# Initial Developer. All Rights Reserved.
#
# Contributor(s):
#   Michael K <mgsstms@gmail.com>

package Bugzilla::Extension::PractiTest;
use strict;
use constant NAME => 'PractiTest';
use constant REQUIRED_MODULES => [
    {
        package => 'Data-Dumper',
        module  => 'Data::Dumper',
        version => 0,
    },
    {
        package => 'REST-Client',
        module  => 'REST::Client',
        version => 0,
    },
    {
        package => 'JSON',
        module  => 'JSON',
        version => 0,
    },
];

use constant CONFIG_HOST=>'https://api.practitest.com';
use constant CONFIG_API_TOKEN=>'your_api_token'; #copy this from your account -> keys
use constant  CONFIG_VERSION=>'1.1.0';

__PACKAGE__->NAME;
