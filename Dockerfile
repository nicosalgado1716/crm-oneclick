FROM nginx:alpine
COPY crm.html /usr/share/nginx/html/index.html
COPY onboarding.html /usr/share/nginx/html/onboarding.html
