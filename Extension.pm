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
use base qw(Bugzilla::Extension);

use Data::Dumper;
use REST::Client;
use JSON;
use Digest::MD5 qw(md5_hex);

our $VERSION = '1.0';

use constant CONFIG_HOST=>'https://prod.practitest.com'; #or http://demo.practitest.com
use constant CONFIG_API_KEY=>'key-apikey'; #copy this from your account settings
use constant CONFIG_API_SECRET_KEY=>'you_api_secret_key'; #copy this from your account settings
use constant  CONFIG_VERSION=>'1.0';

use constant NAME => 'PractiTest';

sub bug_end_of_create
{
  my ($self, $args) = @_;

  my $bug = $args->{'bug'};

  my $is_pt_bug = &_is_pt_bug($bug);
  my $is_updated = $is_pt_bug ? 1 : 0;
  if ($is_updated eq '1')
  {
    &_notify_practitest($bug);
  }
}

sub bug_end_of_update
{
  my ($self, $args) = @_;

  my $bug = $args->{'bug'};
  my $changes = $args->{'changes'};

  my $is_pt_bug = &_is_pt_bug($bug);
  my $is_updated = 0 ;
  if ($is_pt_bug eq '1')
  {
    $is_updated = &_is_pt_bug_changes($bug, $changes);
  }
  if ($is_updated eq '1')
  {
    &_notify_practitest($bug);
  }
}

sub _is_pt_bug
{
  my ($bug) = shift;

  my $result = (defined $bug->cf_pt_id) && ($bug->cf_pt_id ne '') ? 1 : 0;
  return $result;
}

sub _is_pt_bug_changes
{
  my ($bug, $changes) = @_;

  if (defined $changes->{cf_pt_id} && ($changes->{cf_pt_id}->[0] ne $changes->{cf_pt_id}->[1])  && ($changes->{cf_pt_id}->[1] ne '') && ($changes->{cf_pt_id}->[1] ne '0'))
  {
    return 1;
  }

  if (defined $changes->{short_desc} && ($changes->{short_desc}->[0] ne $changes->{short_desc}->[1]))
  {
    return 1;
  }
  if (defined $changes->{bug_status} && ($changes->{bug_status}->[0] ne $changes->{bug_status}->[1]))
  {
    return 1;
  }

  return 0;
}

sub _create_authorization_value
{
  my $timestamp   = time;
  my $signature=md5_hex(CONFIG_API_KEY.CONFIG_API_SECRET_KEY . $timestamp);

  my $result = '';
  $result .= "custom api_key=".CONFIG_API_KEY;
  $result .= ", signature=" . $signature;
  $result .= ", ts=" . $timestamp;

  return $result;
}

sub _notify_practitest
{
  my ($bug) = shift;

  my $host = CONFIG_HOST;
  $host .= '/' unless $host =~ m(\/$);
  my $url = "api/integration_issues/" . $bug->cf_pt_id .".json?v=".CONFIG_VERSION;

  my %json_data = (
    integration_issue => {
      external_id => $bug->id,
      description => $bug->short_desc,
      status => $bug->bug_status
    }
  );
  #translate the perl hash in json notation
  my $payload = encode_json(\%json_data);

  my $headers = {Content_Type => 'application/json', Accept => 'application/json', Authorization => _create_authorization_value()};


# Sometimes (Ubuntu 12.04) this line is needed on https:
# $ENV{HTTPS_CA_DIR} = '/etc/ssl/certs/';

  my $client = REST::Client->new();
  $client->setHost($host);
  $client->PUT(
    $url,
    $payload,
    $headers
  );
  my $response =decode_json ($client->responseContent());
  #	warn "_notify_practitest_response=".Dumper($response);
  if (defined $response->{'error'})
  {
    warn  "Practitest error response=".$response->{'error'};
  }
  return 1;
}

# This must be the last line of your extension.
__PACKAGE__->NAME;
