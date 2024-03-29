{{/*
Expand the name of the chart.
*/}}
{{- define "iotdb-confignode.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "iotdb-confignode.fullname" -}}
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
{{- define "iotdb-confignode.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "iotdb-confignode.labels" -}}
helm.sh/chart: {{ include "iotdb-confignode.chart" . }}
{{ include "iotdb-confignode.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "iotdb-confignode.selectorLabels" -}}
app.kubernetes.io/name: {{ include "iotdb-confignode.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "iotdb-confignode.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "iotdb-confignode.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}



{{/*
Create chart full name.
*/}}
{{- define "iotdb-chart.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{/*
Create chart chart label
*/}}
{{- define "iotdb-chart.labels" -}}
app.kubernetes.io/name: {{ include "iotdb-chart.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Create iotdb-chart.selectorLabels.
*/}}
{{- define "iotdb-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "iotdb-chart.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}


{{/* Define helper template to calculate JVM MAX_HEAP_SIZE from memory limit */}}
{{- define "chart.maxHeapSize" -}}
  {{- $memoryMiStr := regexReplaceAllLiteral "Mi" .Values.resources.limits.memory "" -}}
  {{- $memoryMiInt := atoi $memoryMiStr -}}
  {{- $maxHeapSize := div (mul $memoryMiInt 75) 100 -}}
  {{- printf "%dM" $maxHeapSize -}}
{{- end -}}


{{/* Define helper template to calculate JVM MAX_DIRECT_MEMORY_SIZE from memory limit */}}
{{- define "chart.maxdirmem" -}}
  {{- $memoryMiStr := regexReplaceAllLiteral "Mi" .Values.resources.limits.memory "" -}}
  {{- $memoryMiInt := atoi $memoryMiStr -}}
  {{- $maxdirmem := div (mul $memoryMiInt 25) 100 -}}
  {{- printf "%dM" $maxdirmem -}}
{{- end -}}