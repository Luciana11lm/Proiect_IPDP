#FROM python:3.10  
#WORKDIR /code
#USER test_user
#
#COPY requerements.txt requerements.txt
#
#RUN pip install -requerements.txt
#
#COPY src/* /code 
#
#ENV DB_URL=mysql://root:admin@localhost:3306
#
#
#ENTRYPOINT [ "python" ]
#CMD [ "main.py" ]

FROM php:8.0-apache

# Install mysqli
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
