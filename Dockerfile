FROM nginx:alpine

ADD run.sh /run.sh
ADD default.conf /etc/nginx/conf.d/default.conf

CMD sh run.sh
