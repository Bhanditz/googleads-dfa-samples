#!/usr/bin/env ruby
# Encoding: utf-8
#
# Author:: api.jimper@gmail.com (Jonathon Imperiosi)
#
# Copyright:: Copyright 2014, Google Inc. All Rights Reserved.
#
# License:: Licensed under the Apache License, Version 2.0 (the "License");
#           you may not use this file except in compliance with the License.
#           You may obtain a copy of the License at
#
#           http://www.apache.org/licenses/LICENSE-2.0
#
#           Unless required by applicable law or agreed to in writing, software
#           distributed under the License is distributed on an "AS IS" BASIS,
#           WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
#           implied.
#           See the License for the specific language governing permissions and
#           limitations under the License.
#
# This example fetches and prints the available placement types.
#
# Tags: placement.getPlacementTypes

require_relative 'dfa_utils'

def get_placement_types(auth_token)
  # Get the placement service.
  placement_service = Savon.client(
    :wsdl => DfaUtils.generate_wsdl_url('placement'),
    # Set the WSSE authentication header.
    :wsse_auth => [DfaUtils.get_dfa_username(), auth_token])

  # Fetch placement types.
  response = placement_service.call(
    :get_placement_types,
    :soap_header => DfaUtils.generate_request_header())

  response = response.to_hash[:multi_ref]

  # Display placement types.
  response.each do |placement_type|
    puts 'Placement type with name "%s" and ID %d was found.' %
        [placement_type[:name], placement_type[:id]]
  end
end

if __FILE__ == $0
  # Generate a DFA authentication token.
  auth_token = DfaUtils.authenticate()

  get_placement_types(auth_token)
end
