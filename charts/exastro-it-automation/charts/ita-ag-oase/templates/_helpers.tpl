{{/*
#   Copyright 2022 NEC Corporation
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
*/}}

{{/*
Expand the name of the chart.
*/}}
{{- define "ita-ag-oase.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}

{{- define "ita-ag-oase.agentname" -}}
{{- $top := index . 0 -}}
{{- $agent := index . 1 -}}
{{- $app_name := default $top.Chart.Name $top.Values.nameOverride -}}
{{- $agent_name := default $agent.extraEnv.AGENT_NAME -}}
{{- printf "%s-%s" $app_name $agent_name | trunc 63 | trimSuffix "-" }}
{{- end }}


{{- define "ita-ag-oase.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ita-ag-oase.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ita-ag-oase.labels" -}}
helm.sh/chart: {{ include "ita-ag-oase.chart" . }}
{{ include "ita-ag-oase.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ita-ag-oase.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ita-ag-oase.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Image name
*/}}
{{- define "ita-ag-oase.repository" -}}
{{- $top := index . 0 -}}
{{- $agent := index . 1 -}}
{{- $registry := $top.Values.global.itaGlobalDefinition.image.registry -}}
{{- $organization := $top.Values.global.itaGlobalDefinition.image.organization -}}
{{- $package := $top.Values.global.itaGlobalDefinition.image.package -}}
{{- $tool := replace "ita-" "" $top.Chart.Name -}}
{{- if $top.Values.global.itaGlobalDefinition.image.registry -}}
{{ $agent.image.repository | default (printf "%s/%s/%s-%s" $registry $organization $package $tool) }}
{{- else -}}
{{ $agent.image.repository | default (printf "%s/%s-%s" $organization $package $tool) }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ita-ag-oase.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ita-ag-oase.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
