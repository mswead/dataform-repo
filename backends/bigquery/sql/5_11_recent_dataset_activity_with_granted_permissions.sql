/*
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

SELECT
  timestamp,
  REGEXP_EXTRACT(protopayload_auditlog.resourceName, 'projects/([^/]+)') as projectid,
  REGEXP_EXTRACT(protopayload_auditlog.resourceName, '/datasets/([^/]+)') AS datasetid,
  protopayload_auditlog.authenticationInfo.principalEmail as principalemail,
  protopayload_auditlog.requestMetadata.callerIp as callerip,
  auth.permission as permission,
  protopayload_auditlog.requestMetadata.callerSuppliedUserAgent as agent,
  protopayload_auditlog.methodName as method,
  protopayload_auditlog.status.message as status,
  auth.granted as granted
FROM `[MY_PROJECT_ID].[MY_DATASET_ID].cloudaudit_googleapis_com_activity`,
  UNNEST(protopayload_auditlog.authorizationInfo) as auth
WHERE
  LOWER(protopayload_auditlog.methodName) like '%dataset%'
  AND timestamp >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY);