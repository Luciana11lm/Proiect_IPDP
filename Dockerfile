FROM python:3.10  
WORKDIR /code
USER test_user

COPY requerements.txt requerements.txt

RUN pip install -requerements.txt

COPY src/* /code 

ENV DB_URL=mysql://root:admin@localhost:3306


ENTRYPOINT [ "python" ]
CMD [ "main.py" ]
