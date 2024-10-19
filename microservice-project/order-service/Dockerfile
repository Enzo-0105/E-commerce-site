FROM python:3.14.0a1-alpine3.19
WORKDIR /app
COPY app.py .
RUN pip install flask
EXPOSE 5002
ENTRYPOINT ["python", "app.py"]
