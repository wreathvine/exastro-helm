{{/*
#   Copyright 2023 NEC Corporation
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
{{- define "platform-migration.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "platform-migration.podname" -}}
{{- $name := default .Chart.Name .Values.nameOverride | trunc 50 | trimSuffix "-" }}
{{- $ver  := .Chart.Version | replace "." "-" }}
{{- $rand := randAlphaNum 4 | lower | nospace }}
{{- printf "%s-%s-%s" $name $ver $rand | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "platform-migration.fullname" -}}
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
{{- define "platform-migration.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "platform-migration.labels" -}}
helm.sh/chart: {{ include "platform-migration.chart" . }}
{{ include "platform-migration.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "platform-migration.selectorLabels" -}}
app.kubernetes.io/name: {{ include "platform-migration.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Image name
*/}}
{{- define "platform-migration.repository" -}}
{{- $registry := .Values.global.pfGlobalDefinition.image.registry -}}
{{- $organization := .Values.global.pfGlobalDefinition.image.organization -}}
{{- $package := .Values.global.pfGlobalDefinition.image.package -}}
{{- $tool := replace "platform-" "" .Chart.Name -}}
{{- if .Values.global.pfGlobalDefinition.image.registry -}}
{{ .Values.image.repository | default (printf "%s/%s/%s-%s" $registry $organization $package $tool) }}
{{- else -}}
{{ .Values.image.repository | default (printf "%s/%s-%s" $organization $package $tool) }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "platform-migration.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "platform-migration.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
