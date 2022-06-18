{{- define "cert-manager-prod.annotations" }}
    cert-manager.io/issuer: letsencrypt-prod
{{- end }}
{{- define "cert-manager-staging.annotations" }}
    cert-manager.io/issuer: letsencrypt-staging
{{- end }}
