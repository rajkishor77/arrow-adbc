# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

$Uri = "https://$($env:GEMFURY_PUSH_TOKEN)@push.fury.io/arrow-adbc-nightlies/"

for ($i = 0; $i -lt $args.count; $i++) {
    echo "Uploading $($args[$i])"
    $Form = @{
        package = Get-Item -Path $args[$i]
    }
    try {
        Invoke-WebRequest -uri $Uri -Method Post -Form $Form
    } catch {
        $StatusCode = $_.Exception.Response.StatusCode.value__
        if ($StatusCode -eq 409) {
            continue
        } else {
            echo "Failed to upload: $($StatusCode) $($_.Exception)"
            exit 1
        }
    }
}
